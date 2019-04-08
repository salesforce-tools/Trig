/**
 * Created by derekwiers on 2019-03-19.
 */

trigger TrigTestObject on Trig_Test_Object__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    Trig.Dispatcher.run(new TrigTestObjectHandler());
}