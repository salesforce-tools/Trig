/**
 * Created by derekwiers on 2019-04-13.
 */

global inherited sharing class InactiveState implements ActivationState {

    private Set<String> inactiveActions = new Set<String> ();
    private Set<SObjectType> activeHandlers = new Set<SObjectType> ();
    private Map<SObjectType, Set<String>> partialHandlers = new Map<SObjectType, Set<String>> ();

    /**
     * Constructs a new Inactive State denoting that everything in the org is turned off by default.
     */
    global InactiveState() {
    }

    global InactiveState activateSomeActionsOn(SObjectType handledSObjectType, Set<String> activeActionNames) {
        partialHandlers.put(handledSObjectType, activeActionNames);
        for (String actionName : activeActionNames) {
            inactiveActions.remove(actionName);
        }
        return this;
    }

    global InactiveState activateSomeActionsOn(SObjectType handledSObjectType, String activeActionName) {
        return activateSomeActionsOn(handledSObjectType, new Set<String> {activeActionName});
    }

    global InactiveState activateAllActionsOn(Set<SObjectType> handledSObjectTypes) {
        activeHandlers.addAll(handledSObjectTypes);
        return this;
    }

    global InactiveState activateAllActionsOn(SObjectType handledSObjectType) {
        return activateAllActionsOn(new Set<SObjectType> {handledSObjectType});
    }

    global InactiveState deactivateAction(String actionName) {
        inactiveActions.add(actionName);
        return this;
    }

    global InactiveState deactivateActions(Set<String> actionNames) {
        inactiveActions.addAll(actionNames);
        return this;
    }

    public Boolean isActive(Handler handler, String actionName) {
        SObjectType handledSObjectType = handler.handledSObjectType();

        return activeHandlers.contains(handledSObjectType) && !inactiveActions.contains(actionName)
            || partialHandlers.containsKey(handledSObjectType) && partialHandlers.get(handledSObjectType).contains(actionName);
    }

}