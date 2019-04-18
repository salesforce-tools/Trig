/**
 * Created by derekwiers on 2019-04-15.
 */

@IsTest
private class DeferTest {

    private static testMethod void enqueueUpdateTest() {
        Trig_Test_Object__c sObj = new Trig_Test_Object__c(Name='Test');
        insert sObj;
        sObj.Name = 'Test2';
        Activation.activate();
        Defer.enqueueUpdate(sObj);
        Defer.enqueueUpdate(new Trig_Test_Object__c(Id=sObj.Id, Name='Test3'));
        Defer.executeDml();
        System.assertEquals('Test3', [SELECT Name FROM Trig_Test_Object__c WHERE Id = :sObj.Id].Name);
        AntiRecursion.clearRecursionHistory();
        Defer.enqueueUpdate(new Map<Id, SObject> {sObj.Id => sObj});
        Defer.executeDml();
        System.assertEquals('Test2', [SELECT Name FROM Trig_Test_Object__c WHERE Id = :sObj.Id].Name);
    }
}