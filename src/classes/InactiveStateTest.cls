/**
 * Created by derekwiers on 2019-04-15.
 */

@IsTest
private class InactiveStateTest {
    private static testMethod void defaultTest() {
        Trig.Activation.setActivationState(new InactiveState());

        insert generate();
        assertKeys(new Set<String> ());
    }

    private static testMethod void activateSomActionsOnTest() {
        Trig.Activation.setActivationState(new InactiveState()
            .activateSomeActionsOn(Trig_Test_Object__c.SObjectType, TrigTestObjectAction.UNIQUE_NAME)
        );
        insert generate();
        assertKeys(new Set<String> {'BEFORE_INSERT', 'AFTER_INSERT'});
    }

    private static testMethod void activateAllActionsOnTest() {
        Trig.Activation.setActivationState(new InactiveState()
            .activateAllActionsOn(Trig_Test_Object__c.SObjectType)
        );
        insert generate();
        assertKeys(new Set<String> {'BEFORE_INSERT', 'AFTER_INSERT'});
    }

    private static testMethod void deactivateActionTest() {
        Trig.Activation.setActivationState(new InactiveState()
            .activateAllActionsOn(Trig_Test_Object__c.SObjectType)
            .deactivateAction(TrigTestObjectAction.UNIQUE_NAME)
        );
        insert generate();
        assertKeys(new Set<String> ());

        Trig.Activation.setActivationState(new InactiveState()
            .activateAllActionsOn(Trig_Test_Object__c.SObjectType)
            .deactivateActions(new Set<String> {TrigTestObjectAction.UNIQUE_NAME})
        );
        insert generate();
        assertKeys(new Set<String> ());
    }

    private static Trig_Test_Object__c generate() {
        return new Trig_Test_Object__c(Name='Test'+Utils.getRandomAlphaNumericString(10));
    }

    private static void assertKeys(Set<String> keys) {
        System.assertEquals(keys.size(), TrigTestObjectAction.timesRunMap.size());
        System.assertEquals(keys, TrigTestObjectAction.timesRunMap.keySet());
    }
}