/**
 * Created by derekwiers on 2019-04-15.
 */

@IsTest
private class DispatcherTest {

    private static testMethod void triggerOperationTest() {
        Trig_Test_Object__c testObj = new Trig_Test_Object__c(Name='Testy test');
        Trig_Test_Object__c insertedTestObj = new Trig_Test_Object__c(Name='T', Id=(Trig_Test_Object__c.SObjectType.getDescribe().keyPrefix+'00000'+Utils.getRandomAlphaNumericString(7)));
        Handler handler = new TrigTestObjectHandler();
        Dispatcher.run(handler, Context.beforeInsert(testObj));
        AntiRecursion.clearRecursionHistory();
        Dispatcher.run(handler, Context.afterInsert(testObj));
        AntiRecursion.clearRecursionHistory();
        Dispatcher.run(handler, Context.beforeUpdate(insertedTestObj, insertedTestObj));
        AntiRecursion.clearRecursionHistory();
        Dispatcher.run(handler, Context.afterUpdate(insertedTestObj, insertedTestObj));
        AntiRecursion.clearRecursionHistory();
        Dispatcher.run(handler, Context.beforeDelete(insertedTestObj));
        AntiRecursion.clearRecursionHistory();
        Dispatcher.run(handler, Context.afterDelete(insertedTestObj));
        AntiRecursion.clearRecursionHistory();
        Dispatcher.run(handler, Context.afterUndelete(insertedTestObj));
        System.assert(true); // just testing that it ran
    }
}