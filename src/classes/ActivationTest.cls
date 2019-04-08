/**
 * Created by derekwiers on 2019-03-21.
 */

@IsTest
private class ActivationTest {

    private static testMethod void defaultTest() {
        insert new Trig_Test_Object__c(Name='Test');
        System.assertEquals(1, TrigTestObjectAction.timesRunMap.size());
    }

    private static testMethod void activateAllTest() {
        Activation.activateAll();
        insert new Trig_Test_Object__c(Name='Test');
        System.assertEquals(3, TrigTestObjectAction.timesRunMap.size());
    }

    private static testMethod void deactivateAllTest() {
        Activation.activateAll();
        Activation.deactivateAll();
        insert new Trig_Test_Object__c(Name='Test');
        System.assertEquals(1, TrigTestObjectAction.timesRunMap.size());
    }

    private static testMethod void activateSObjectTypeTest() {
        Activation.deactivateAll();
        Activation.activateSObjectType(Trig_Test_Object__c.SObjectType, true);
        insert new Trig_Test_Object__c(Name='Test');
        System.assertEquals(3, TrigTestObjectAction.timesRunMap.size());
    }

    private static testMethod void activateActionTest() {
        Activation.deactivateAll();
        Activation.activateSObjectType(Trig_Test_Object__c.SObjectType, false);
        Activation.activateAction(Trig_Test_Object__c.SObjectType, new TrigTestObjectAction().getUniqueName());
        insert new Trig_Test_Object__c(Name='Test');
        System.debug(TrigTestObjectAction.timesRunMap);
        System.assertEquals(3, TrigTestObjectAction.timesRunMap.size());
    }

    private static testMethod void activateSObjectTypesTest() {
        Activation.deactivateAll();
        Activation.activateSObjectTypes(new Set<SObjectType> {Trig_Test_Object__c.SObjectType}, true);
        insert new Trig_Test_Object__c(Name='Test');
        System.assertEquals(3, TrigTestObjectAction.timesRunMap.size());
    }

    private static testMethod void activateActionsTest() {
        Activation.deactivateAll();
        Activation.activateSObjectType(Trig_Test_Object__c.SObjectType, false);
        Activation.activateActions(Trig_Test_Object__c.SObjectType, new Set<String> {new TrigTestObjectAction().getUniqueName()});
        insert new Trig_Test_Object__c(Name='Test');
        System.assertEquals(3, TrigTestObjectAction.timesRunMap.size());
    }

    private static testMethod void deactivateSObjectTypeTest() {
        Activation.activateAll();
        Activation.activateSObjectType(Trig_Test_Object__c.SObjectType, true);
        insert new Trig_Test_Object__c(Name='Test');
        System.assertEquals(3, TrigTestObjectAction.timesRunMap.size());
    }

    private static testMethod void deactivateActionTest() {
        Activation.activateAll();
        Activation.activateSObjectType(Trig_Test_Object__c.SObjectType, false);
        Activation.activateAction(Trig_Test_Object__c.SObjectType, new TrigTestObjectAction().getUniqueName());
        insert new Trig_Test_Object__c(Name='Test');
        System.assertEquals(3, TrigTestObjectAction.timesRunMap.size());
    }

    private static testMethod void deactivateSObjectTypesTest() {
        Activation.activateAll();
        Activation.activateSObjectTypes(new Set<SObjectType> {Trig_Test_Object__c.SObjectType}, true);
        insert new Trig_Test_Object__c(Name='Test');
        System.assertEquals(3, TrigTestObjectAction.timesRunMap.size());
    }

    private static testMethod void deactivateActionsTest() {
        Activation.activateAll();
        Activation.activateSObjectType(Trig_Test_Object__c.SObjectType, false);
        Activation.activateActions(Trig_Test_Object__c.SObjectType, new Set<String> {new TrigTestObjectAction().getUniqueName()});
        insert new Trig_Test_Object__c(Name='Test');
        System.assertEquals(3, TrigTestObjectAction.timesRunMap.size());
    }
}