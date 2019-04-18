/**
 * Created by derekwiers on 2019-04-15.
 */

global without sharing class ActionBehavior {

    public Boolean byId = false;
    public Integer callLimit = null;
    public String uniqueName;
    public Action action;

    /**
     * Constructor for ActionBehavior.  Sets a link to the current action (so that the action behavior can work on the
     *  action directly), and sets a unique action name.
     *
     *
     * @param action The action that this Behavior describes.  Usually, you should put "this" when instantiating inside
     *  an Action.
     * @param uniqueActionName Give a unique action name.  It is recommended to have a good naming scheme for this to
     *  ensure uniqueness - like namespace.object.actionName - but this is not strictly required.
     */
    global ActionBehavior(Action action, String uniqueActionName) {
        this.action = action;
        this.uniqueName = uniqueActionName;
    }

    /**
     * Enables an Anti-Recursion mechanism such that it will only call the run() method if there are records that this
     * action has not seen in this transaction before, and the Context input to the run() method will reflect only those
     * records.  If there are no "new" records that the action hasn't seen before, the run() method will not be called.
     * To mark a record as having been seen, the run() method must return a RunResult object with a Set of Ids that it
     * does not want to see again (enabling repeating Ids if necessary).
     *
     * @return The ActionBehavior object, used for a Fluent interface.
     */
    global ActionBehavior setById() {
        byId = true;
        return this;
    }

    /**
     * Enables an Anti-Recursion mechanism such that it will only call the run() method a "callLimit" number of times,
     * regardless of the Ids being passed in or anything.  The run() method returning a RunResult with a Boolean value
     * will tell Trig whether that call was to be counted against the limit.  For example, if the callLimit is set to 2,
     * the run action will be called potentially as many times as necessary until the the transaction is over or until
     * it returns a new RunResult(true) twice (to count toward the limit).  This can be mixed with the setById()
     * mechanism, in which case returning the RunResult with a non-empty set of Ids will tell Trig that the call counted.
     *
     * @param callLimit The maximum number of times this action should be called in a transaction, not counting calls
     *  that resulted in a null, false, or empty set of Ids as the RunResult.
     *
     * @return The ActionBehavior object, used for a Fluent interface.
     */
    global ActionBehavior setCallLimit(Integer callLimit) {
        this.callLimit = callLimit;
        return this;
    }


    /**
     * Internal method to run the given action, based on contextual data and ActionBehavior member variables.  Checks if
     * the action is active, then works on setById(), then works on call limit.
     *
     * @param handler The handler that originated this Action.
     * @param context The current Trigger Context
     * @param data Any prefetched data from the handler
     */
    public void runAction(Handler handler, Context context, PrefetchedData data) {
        if (Activation.isActive(handler, uniqueName)) {
            Boolean shouldRun = true;
            Context contextToUse = context;
            if (byId) {
                contextToUse = AntiRecursion.getNonRepeatingContext(context, uniqueName);
                if (contextToUse == null) {
                    shouldRun = false;
                }
            }
            if (shouldRun && callLimit != null) {
                if (!AntiRecursion.shouldRun(uniqueName, callLimit)) {
                    shouldRun = false;
                }
            }

            if (shouldRun) {
                RunResult result = action.run(contextToUse, data);

                if (callLimit != null && result != null && (result.markAsComplete != null && result.markAsComplete || (result.completedIds != null && !result.completedIds.isEmpty()))) {
                    AntiRecursion.recordActionRun(uniqueName);
                }
                if (byId && result != null && (result.completedIds != null && !result.completedIds.isEmpty())) {
                    AntiRecursion.recordActionRun(uniqueName, result.completedIds);
                }
            }
        }
    }
}