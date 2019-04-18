/**
 * @description The class to call as a one-liner for Triggers.  The primary class that controls execution of handlers
 *  and actions.
 */
global without sharing class Dispatcher {

    private static Integer callDepth = 0;

    /**
     * Dispatch the given Handler under a given Context.  This overload is only valid for tests, as it is not
     * safe to insert an arbitrary context into the stack.
     *
     * @param handler The Trig.Handler to run.
     * @param context The Trig.Context to run under.
     */
    global static void run(Handler handler, Context context) {
        if (!Test.isRunningTest()) {
            throw new InvalidOutsideOfTestingException('It is not possible to set context of Dispatcher.run() outside of testing.');
        }
        runInternal(handler, context);
    }

    /**
     * Dispatch the given Handler in a Trigger Context.
     *
     * @param handler The Trig.Handler to run.
     */
    global static void run(Handler handler) {
        runInternal(handler, Context.fromTrigger());
    }

    /**
     * The internal method to dispatch handlers.
     *
     * @param handler The Trig.Handler to run.
     * @param context The Trig.Context to run under.
     */
    public static void runInternal(Handler handler, Context context) {
        callDepth++;
        System.debug('Running handler ' + handler.handledSObjectType() + ' with context ' + context.toSummaryString());

        System.debug('Instantiating actions from handler...');
        List<ActionBehavior> behaviors = getBehaviors(getActionsForOperation(handler, context.operation));

        if (!shouldHandlerRun(handler, behaviors)) {
            System.debug('No active actions found.  Skipping prefetch and action execution stage.');
            callDepth--;
            return;
        }

        System.debug('Running pre-trigger operations...');
        PrefetchedData data = new PrefetchedData(handler.prefetchData(context));

        System.debug('Calling actions...');
        for (ActionBehavior behavior : behaviors) {
            behavior.runAction(handler, context, data);
        }
        if (callDepth == 1) {
            System.debug('Executing deferred DML if any...');
            Defer.executeDml();
        }
        callDepth--;
    }

    /**
     * Helper for runInternal(). Given a handler on the trigger operation, call the correct list method on the handler
     * and return its results.
     *
     * @param handler The handler to call
     * @param operation The TriggerOperation to get actions for.
     *
     * @return The list of actions in the appropriate operation of the handler.
     */
    private static List<Action> getActionsForOperation(Handler handler, TriggerOperation operation) {
        List<Action> actionsToAttempt;
        switch on operation {
            when BEFORE_INSERT {
                actionsToAttempt = handler.beforeInsert();
            }
            when AFTER_INSERT {
                actionsToAttempt = handler.afterInsert();
            }
            when BEFORE_UPDATE {
                actionsToAttempt = handler.beforeUpdate();
            }
            when AFTER_UPDATE {
                actionsToAttempt = handler.afterUpdate();
            }
            when BEFORE_DELETE {
                actionsToAttempt = handler.beforeDelete();
            }
            when AFTER_DELETE {
                actionsToAttempt = handler.afterDelete();
            }
            when AFTER_UNDELETE {
                actionsToAttempt = handler.afterUndelete();
            }
        }
        return actionsToAttempt == null ? new List<Action> () : actionsToAttempt;
    }

    /**
     * Turn a list of actions into a list of ActionBehaviors using the Action.getBehavior() method.
     *
     * @param actions Actions that need to be turned into ActionBehaviors
     *
     * @return The list of Behaviors
     */
    public static List<ActionBehavior> getBehaviors(List<Action> actions) {
        List<ActionBehavior> behaviors = new List<ActionBehavior> ();
        for (Action action : actions) {
            behaviors.add(action.getBehavior());
        }
        return behaviors;
    }

    /**
     * Determines if there are any active actions on the handler for this operation.  If not, the prefetch method need
     * not run.
     *
     * @param handler The handler to check if isActive
     * @param behaviorsOnHandler The list of relevant behaviors on the handler
     *
     * @return True if at least one behavior was found to be active on the handler; false if not.
     */
    public static Boolean shouldHandlerRun(Handler handler, List<ActionBehavior> behaviorsOnHandler) {
        for (ActionBehavior behavior : behaviorsOnHandler) {
            if (Activation.isActive(handler, behavior.uniqueName)) {
                return true;
            }
        }
        return false;
    }

    /**
     * Exception thrown if a call to run(Handler, Context) was made outside of testing, which is not allowed.
     */
    global class InvalidOutsideOfTestingException extends Exception {}
}