/**
 * An ActivationState where everything is by default turned on, with the ability to selectively turn handlers and
 * actions off.
 */

global without sharing class ActiveState implements ActivationState {

    private Set<String> inactiveActions = new Set<String> ();
    private Set<SObjectType> inactiveHandlers = new Set<SObjectType> ();
    private Map<SObjectType, Set<String>> partialHandlers = new Map<SObjectType, Set<String>> ();


    /**
     * Constructs a new Active State denoting that everything in the org is turned on by default.
     */
    global ActiveState() {
    }

    /**
     * Deactivate an action.
     *
     * @param actionName Unique name of the action
     *
     * @return This, for Fluent Interface.
     */
    global ActiveState deactivateAction(String actionName) {
        inactiveActions.add(actionName);
        return this;
    }

    /**
     * Plural form of deactivateAction().
     *
     * @param actionNames Unique names of actions to be deactivated.
     *
     * @return This, for Fluent Interface.
     */
    global ActiveState deactivateActions(Set<String> actionNames) {
        inactiveActions.addAll(actionNames);
        return this;
    }

    /**
     * Deactivates an entire handler.  Note that reactivateAction() does not work to activate an action on an otherwise
     * inactive handler - use deactivateAllOnHandlerExcept().  This also prevents execution of the Prefetch method on
     * the handler.
     *
     * @param handledSObjectType The SObjectType handled by the Handler.
     *
     * @return This, for Fluent Interface.
     */
    global ActiveState deactivateAllActionsOn(SObjectType handledSObjectType) {
        inactiveHandlers.add(handledSObjectType);
        partialHandlers.remove(handledSObjectType);
        return this;
    }

    /**
     * Deactivates entire handlers.  Note that reactivateAction() does not work to activate an action on an otherwise
     * inactive handler - use deactivateAllOnHandlerExcept().  This also prevents execution of the Prefetch method on
     * the handler.
     *
     * @param handledSObjectType The SObjectTypes handled by the Handlers.
     *
     * @return This, for Fluent Interface.
     */
    global ActiveState deactivateAllActionsOn(Set<SObjectType> handledSObjectTypes) {
        for (SObjectType sobjType : handledSObjectTypes) {
            deactivateAllActionsOn(sobjType);
        }
        return this;
    }

    /**
     * Puts the handler into a "partially active" state that all of the actions on it are turned off, except for 1
     * action.  The Prefetch method is still called.
     *
     * @param handledSObjectType The SObjectType handled by the handler
     * @param activeActionName The singular action that needs to be active.
     *
     * @return This, for Fluent Interface.
     */
    global ActiveState deactivateAllOnHandlerExcept(SObjectType handledSObjectType, String activeActionName) {
        inactiveHandlers.remove(handledSObjectType);
        inactiveActions.remove(activeActionName);
        deactivateAllOnHandlerExcept(handledSObjectType, new Set<String> {activeActionName});
        return this;
    }

    /**
     * Puts the handler into a "partially active" state that all of the action on it are turned off, except for some
     * actions.  The Prefetch method is still called.
     *
     * @param handledSObjectType The SObjectType handled by the handler.
     * @param activeActionNames The actions that need to be active.
     *
     * @return This, for Fluent Interface.
     */
    global ActiveState deactivateAllOnHandlerExcept(SObjectType handledSObjectType, Set<String> activeActionNames) {
        inactiveHandlers.remove(handledSObjectType);
        inactiveActions.removeAll(activeActionNames);

        partialHandlers.put(handledSObjectType, activeActionNames);
        return this;
    }

    /**
     * Reactivates any action that was deactivated using deactivateAction().  Has no effect on actions deactivated any
     * other way.
     *
     * @param actionName The name of the action to be reactivated.
     *
     * @return This, for Fluent Interface.
     */
    global ActiveState reactivateAction(String actionName) {
        inactiveActions.remove(actionName);
        return this;
    }

    /**
     * Reactivates any actions that were deactivated using deactivateAction().  Has no effect on actions deactivated any
     * other way.
     *
     * @param actionNames The names of the actions to be reactivated.
     *
     * @return This, for Fluent Interface.
     */
    global ActiveState reactivateActions(Set<String> actionNames) {
        for (String actionName : actionNames) {
            reactivateAction(actionName);
        }
        return this;
    }

    /**
     * Reactivates a handler that was deactivated using deactivateAllActionsOn() or deactivateAllOnHandlerExcept().
     *
     * @param handledSObjectType The handled SObjectType of the handler that needs to be reactivated.
     *
     * @return This, for Fluent Interface.
     */
    global ActiveState reactivateHandler(SObjectType handledSObjectType) {
        inactiveHandlers.remove(handledSObjectType);
        partialHandlers.remove(handledSObjectType);
        return this;
    }

    /**
     * Internal method for finding if the given handler and action is active.
     *
     * @param handler The handler to check if active.
     * @param actionName The unique name of the action to check if active.
     *
     * @return True if the given handler and action are active; false otherwise.
     */
    public Boolean isActive(Handler handler, String actionName) {
        SObjectType handledSObjectType = handler.handledSObjectType();

        return !inactiveHandlers.contains(handledSObjectType)
            && (!partialHandlers.containsKey(handledSObjectType) || partialHandlers.get(handledSObjectType).contains(actionName))
            && !inactiveActions.contains(actionName);
    }
}