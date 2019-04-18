/**
 * Created by derekwiers on 2019-04-13.
 */

@IsTest
private class ActiveStateTest {

    private static testMethod void defaultTest() {
        Trig.Activation.setActivationState(new ActiveState());

        insert generate();
        assertKeys(new Set<String> {'BEFORE_INSERT', 'AFTER_INSERT'});
    }

    private static testMethod void deactivateActionTest() {
        Trig.Activation.setActivationState(new ActiveState()
            .deactivateAction(TrigTestObjectAction.UNIQUE_NAME)
        );
        insert generate();
        assertKeys(new Set<String> ());
    }

    private static testMethod void deactivateActionsTest() {
        Trig.Activation.setActivationState(new ActiveState()
            .deactivateActions(new Set<String> {TrigTestObjectAction.UNIQUE_NAME})
        );
        insert generate();
        assertKeys(new Set<String> ());
    }

    private static testMethod void deactivateAllActionsOnTest() {
        Trig.Activation.setActivationState(new ActiveState()
            .deactivateAllActionsOn(Trig_Test_Object__c.SObjectType)
        );
        insert generate();
        assertKeys(new Set<String> ());

        Trig.Activation.setActivationState(new ActiveState()
            .deactivateAllActionsOn(new Set<SObjectType> {Trig_Test_Object__c.SObjectType})
        );
        insert generate();
        assertKeys(new Set<String> ());
    }


    private static testMethod void deactivateWithExceptionsTest() {
        Trig.Activation.setActivationState(new ActiveState()
            .deactivateAllActionsOn(Trig_Test_Object__c.SObjectType)
            .deactivateAllOnHandlerExcept(Trig_Test_Object__c.SObjectType, TrigTestObjectAction.UNIQUE_NAME)
        );
        insert generate();
        assertKeys(new Set<String> {'BEFORE_INSERT', 'AFTER_INSERT'});
    }

    private static testMethod void reactivationActionTest() {
        Trig.Activation.setActivationState(new ActiveState()
            .deactivateAction(TrigTestObjectAction.UNIQUE_NAME)
            .reactivateAction(TrigTestObjectAction.UNIQUE_NAME)
        );
        insert generate();
        assertKeys(new Set<String> {'BEFORE_INSERT', 'AFTER_INSERT'});
    }

    private static testMethod void reactivationActionsTest() {
        Trig.Activation.setActivationState(new ActiveState()
            .deactivateAction(TrigTestObjectAction.UNIQUE_NAME)
            .reactivateActions(new Set<String> {TrigTestObjectAction.UNIQUE_NAME})
        );
        insert generate();
        assertKeys(new Set<String> {'BEFORE_INSERT', 'AFTER_INSERT'});
    }

    private static testMethod void reactivateHandlerTest() {
        Trig.Activation.setActivationState(new ActiveState()
            .deactivateAllActionsOn(Trig_Test_Object__c.SObjectType)
            .reactivateHandler(Trig_Test_Object__c.SObjectType)
        );
        insert generate();
        assertKeys(new Set<String> {'BEFORE_INSERT', 'AFTER_INSERT'});
    }

    private static Trig_Test_Object__c generate() {
        return new Trig_Test_Object__c(Name='Test'+Utils.getRandomAlphaNumericString(10));
    }

    private static void assertKeys(Set<String> keys) {
        System.assertEquals(keys.size(), TrigTestObjectAction.timesRunMap.size());
        System.assertEquals(keys, TrigTestObjectAction.timesRunMap.keySet());
    }
}