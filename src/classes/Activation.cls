/**
 * Created by derekwiers on 2019-03-19.
 */

global without sharing class Activation {

    private static Mode activationMode;
    private static Set<SObjectType> deactivatedSObjectTypes;
    private static Set<String> exceptionActions;

    static {
        reset();
    }

    private Activation() {}

    private static Boolean canDeactivateInProduction() {
        return Utils.getSettings().get('Can_Deactivate_Actions').Enabled__c;
    }

    private static Set<String> getDeactivatedActions() {
        return Action_Deactivation__c.getAll().keySet();
    }

    global static void reset() {
        activationMode = Test.isRunningTest() ? Mode.DEFAULT_INACTIVE : Mode.DEFAULT_ACTIVE;
        deactivatedSObjectTypes = new Set<SObjectType>();
        exceptionActions = new Set<String> ();
    }

    global static void deactivateAll() {
        if (!Test.isRunningTest() && !canDeactivateInProduction()) {
            throw new CannotDeactivateException('Deactivating outside of Unit Tests is not enabled.  See Trig Settings to enable.');
        }
        reset();
        activationMode = Mode.DEFAULT_INACTIVE;
    }

    global static void activateAll() {
        reset();
        activationMode = Mode.DEFAULT_ACTIVE;
    }

    global static Boolean deactivateAction(String actionName) {
        if (!Test.isRunningTest() && !canDeactivateInProduction()) {
            throw new CannotDeactivateException('Deactivating outside of Unit Tests is not enabled.  See Trig Settings to enable.');
        } else if (activationMode == Mode.DEFAULT_ACTIVE) {
            exceptionActions.add(actionName);
            return true;
        } else {
            return false;
        }
    }

    global static Set<String> deactivateActions(Set<String> actionNames) {
        Set<String> deactivatedActions = new Set<String> ();
        for (String actionName : actionNames) {
            if (deactivateAction(actionName)) {
                deactivatedActions.add(actionName);
            }
        }
        return deactivatedActions;
    }

    global static Boolean deactivateSObjectType(SObjectType sObjType) {
        if (!Test.isRunningTest() && !canDeactivateInProduction()) {
            throw new CannotDeactivateException('Deactivating outside of Unit Tests is not enabled.  See Trig Settings to enable.');
        } else if (activationMode == Mode.DEFAULT_ACTIVE) {
            deactivatedSObjectTypes.add(sObjType);
            return true;
        } else {
            return false;
        }
    }

    global static Set<SObjectType> deactivateSObjectTypes(Set<SObjectType> sObjTypes) {
        Set<SObjectType> deactivatedTypes = new Set<SObjectType> ();
        for (SObjectType t : sObjTypes) {
            if (deactivateSObjectType(t)) {
                deactivatedTypes.add(t);
            }
        }
        return deactivatedTypes;
    }

    global static Boolean activateAction(SObjectType sObjType, String actionName) {
        if (activationMode == Mode.DEFAULT_INACTIVE) {
            Boolean existingExceptionSObjectTypeValue = deactivatedSObjectTypes.contains(sObjType);

            exceptionActions.add(actionName);
            return true;
        }
        return false;
    }

    global static Set<String> activateActions(SObjectType sObjType, Set<String> actionNames) {
        Set<String> activatedActionNames = new Set<String> ();
        for (String actionName : actionNames) {
            if (activateAction(sObjType, actionName)) {
                activatedActionNames.add(actionName);
            }
        }
        return activatedActionNames;
    }

    global static Boolean activateSObjectType(SObjectType sObjType, Boolean activateAllActions) {
        if (activationMode == Mode.DEFAULT_INACTIVE) {
            deactivatedSObjectTypes.put(sObjType, activateAllActions);
            return true;
        }
        return false;
    }

    global static Set<SObjectType> activateSObjectTypes(Set<SObjectType> sObjTypes, Boolean activateAllActions) {
        Set<SObjectType> activatedSObjTypes = new Set<SObjectType> ();
        for (SObjectType sObjType : sObjTypes) {
            if (activateSObjectType(sObjType, activateAllActions)) {
                activatedSObjTypes.add(sObjType);
            }
        }
        return activatedSObjTypes;
    }

    public static Boolean isActive(Handler handler) {
        return !(activationMode == Mode.DEFAULT_INACTIVE || deactivatedSObjectTypes.contains(handler.handledSObjectType()));
        //return (activationMode == Mode.DEFAULT_ACTIVE) != (exceptionSObjectTypes.containsKey(handler.handledSObjectType()) && exceptionSObjectTypes.get(handler.handledSObjectType()));
    }

    public static Boolean isActive(Action action) {
        return ((activationMode == Mode.DEFAULT_ACTIVE) != exceptionActions.contains(action.getUniqueName())) &&
                !getDeactivatedActions().contains(action.getUniqueName());
    }


    global class CannotDeactivateException extends Exception {}

    private enum Mode {
        DEFAULT_ACTIVE,
        DEFAULT_INACTIVE
    }
}