/**
 * @description
 */
global without sharing class Dispatcher {


    private static Map<String, Set<Id>> idHistoryMap = new Map<String, Set<Id>> ();
    //global static Activation actions = new Activation();

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
     * The private method to dispatch handlers.
     *
     * @param handler The Trig.Handler to run.
     * @param context The Trig.Context to run under.
     */
    public static void runInternal(Handler handler, Context context) {
        if (!Activation.isActive(handler)) {
            System.debug('Skipping handler for ' + handler.handledSObjectType() + ' as it is inactive.');
            return;
        }
        System.debug('Running handler ' + handler.handledSObjectType() + ' with context ' + context.toSummaryString());

        System.debug('Running pre-trigger operations...');
        Map<String, Object> prefetchedData = handler.prefetchData(context);

        System.debug('Instantiating actions...');
        List<Action> actionsToAttempt;
        switch on context.operation {
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
            when else {
                throw new OperationNotSupportedException('Trigger Operation Not Supported.  Please contact the Trig developer.');
            }
        }

        System.debug('Calling actions...');
        for (Action action : actionsToAttempt) {
            if (Activation.isActive(action)) {
                Context reducedContext = getReducedContext(context, action);
                if (context.hasIds && reducedContext == null) {
                    System.debug('Action ' + action.getUniqueName() + ' has no unique ids on which to perform, so it is being skipped');
                    continue;
                }
                System.debug('Running Action ' + action.getUniqueName());
                Set<Id> completedIds = action.run(reducedContext, prefetchedData);
                System.debug('End Running Action ' + action.getUniqueName());
                // record ids has having been completed
                if (context.hasIds && completedIds != null) {
                    idHistoryMap.get(action.getUniqueName()).addAll(completedIds);
                }
            }
        }
    }

    private static Context getReducedContext(Context context, Action action) {
        if (!context.hasIds) {
            return context;
        } else if (!idHistoryMap.containsKey(action.getUniqueName())) {
            idHistoryMap.put(action.getUniqueName(), new Set<Id>());
        }
        return context.withRemovedIds(idHistoryMap.get(action.getUniqueName()));
    }

    global static void resetAllRecursionCounters() {
        idHistoryMap = new Map<String, Set<Id>>();
    }

    global class InvalidOutsideOfTestingException extends Exception {}

    global class OperationNotSupportedException extends Exception {}
}