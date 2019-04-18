/**
 * Created by derekwiers on 2019-03-21.
 */

@IsTest
private class ActivationTest {

    private static testMethod void defaultTest() {
        insert new Trig_Test_Object__c(Name='Test'+Utils.getRandomBase64String(6));
        System.assertEquals(0, TrigTestObjectAction.timesRunMap.size());
    }

    private static testMethod void activateAllTest() {
        Activation.activate();
        insert new Trig_Test_Object__c(Name='Test'+Utils.getRandomBase64String(6));
        System.debug(TrigTestObjectAction.timesRunMap);
        System.assertEquals(2, TrigTestObjectAction.timesRunMap.size());
        System.assertEquals(1, TrigTestObjectAction.timesRunMap.get('AFTER_INSERT'));
        System.assertEquals(1, TrigTestObjectAction.timesRunMap.get('BEFORE_INSERT'));
    }

    private static testMethod void deactivateAllTest() {
        Activation.activate();
        Activation.deactivate();
        insert new Trig_Test_Object__c(Name='Test'+Utils.getRandomBase64String(6));
        System.assertEquals(0, TrigTestObjectAction.timesRunMap.size());
    }

    private static testMethod  void recursionTest() {
        Activation.activate();
        Trig_Test_Object__c obj = new Trig_Test_Object__c(Name='Test');
        insert obj;

        System.assertEquals(2, TrigTestObjectAction.timesRunMap.size());
        System.assertEquals(1, TrigTestObjectAction.timesRunMap.get('AFTER_INSERT'));
        System.assertEquals(1, TrigTestObjectAction.timesRunMap.get('BEFORE_INSERT'));

        update obj;
        // test no changes
        System.assertEquals(2, TrigTestObjectAction.timesRunMap.size());
        System.assertEquals(1, TrigTestObjectAction.timesRunMap.get('AFTER_INSERT'));
        System.assertEquals(1, TrigTestObjectAction.timesRunMap.get('BEFORE_INSERT'));

        Trig.AntiRecursion.clearRecursionHistory();

        update obj;

        System.debug(TrigTestObjectAction.timesRunMap);
        System.assertEquals(3, TrigTestObjectAction.timesRunMap.size());
        System.assertEquals(1, TrigTestObjectAction.timesRunMap.get('AFTER_INSERT'));
        System.assertEquals(1, TrigTestObjectAction.timesRunMap.get('BEFORE_INSERT'));
        System.assertEquals(1, TrigTestObjectAction.timesRunMap.get('BEFORE_UPDATE'));
    }

    private static testMethod void canDeactivateOutsideOfTestsTest() {
        System.assertEquals(Utils.getSettings().get('Can_Deactivate_Actions').Enabled__c, Activation.canDeactivateOutsideOfTests());
    }

    private static testMethod void deactivateHandlerTest() {
        Trig.Activation.setActivationState(new ActiveState()
            .deactivateAllActionsOn(Trig_Test_Object__c.SObjectType)
        );
        insert new Trig_Test_Object__c(Name='Test'+Utils.getRandomBase64String(6));
        System.assertEquals(0, TrigTestObjectAction.timesRunMap.size());
    }

    private static testMethod void deactivateActionTest() {
        Trig.Activation.setActivationState(new ActiveState()
            .deactivateAction(TrigTestObjectAction.UNIQUE_NAME)
        );
        insert new Trig_Test_Object__c(Name='Test'+Utils.getRandomBase64String(6));
        System.assertEquals(0, TrigTestObjectAction.timesRunMap.size());
    }

    private static testMethod void deactivateActionsTest() {
        Trig.Activation.setActivationState(new ActiveState()
            .deactivateActions(new Set<String> {TrigTestObjectAction.UNIQUE_NAME})
        );
        insert new Trig_Test_Object__c(Name='Test'+Utils.getRandomBase64String(6));
        System.assertEquals(0, TrigTestObjectAction.timesRunMap.size());
    }

    private static testMethod void setDependOnActionsTest() {
        InactiveState s = new InactiveState()
            .activateSomeActionsOn(Trig_Test_Object__c.SObjectType, TrigTestObjectAction.UNIQUE_NAME);
        Trig.Activation.setActivationState(new InactiveState());
        insert new Trig_Test_Object__c(Name='Test'+Utils.getRandomBase64String(6));
        System.assertEquals(0, TrigTestObjectAction.timesRunMap.size());

        Trig.Activation.setActivationState(s);
        insert new Trig_Test_Object__c(Name='Test'+Utils.getRandomBase64String(6));
        System.assertEquals(2, TrigTestObjectAction.timesRunMap.size());
        System.assertEquals(1, TrigTestObjectAction.timesRunMap.get('AFTER_INSERT'));
        System.assertEquals(1, TrigTestObjectAction.timesRunMap.get('BEFORE_INSERT'));
    }

    private static testMethod void activateAllActionsOnSObjectTypeTest() {
        Trig.Activation.setActivationState(new InactiveState()
            .activateAllActionsOn(Trig_Test_Object__c.SObjectType)
        );
        insert new Trig_Test_Object__c(Name='Test'+Utils.getRandomBase64String(6));
        System.assertEquals(2, TrigTestObjectAction.timesRunMap.size());
        System.assertEquals(1, TrigTestObjectAction.timesRunMap.get('AFTER_INSERT'));
        System.assertEquals(1, TrigTestObjectAction.timesRunMap.get('BEFORE_INSERT'));
    }

    private static testMethod void resetTest() {
        Trig.Activation.activate();
        System.assert(Trig.Activation.state instanceof ActiveState);
        Trig.Activation.reset();
        System.assert(Trig.Activation.state instanceof InactiveState);
    }
}