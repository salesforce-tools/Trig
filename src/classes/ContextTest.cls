/**
 * Created by derekwiers on 2019-04-12.
 */

@IsTest
private class ContextTest {

    private static final List<SObject> NULL_LIST = null;
    private static final Map<Id, SObject> NULL_MAP = null;

    private static SObject getSObj(Boolean hasId) {
        if (hasId) {
            return new Trig_Test_Object__c(
                Name='Test'+Utils.getRandomBase64String(6),
                Id=Trig_Test_Object__c.SObjectType.getDescribe().keyPrefix+'0000000'+Utils.getRandomAlphaNumericString(5));
        } else {
            return new Trig_Test_Object__c(Name='Test'+Utils.getRandomBase64String(6));
        }
    }

    private static testMethod void beforeInsertTest() {
        // null test
        try {
            Context.beforeInsert(NULL_LIST);
            System.assert(false); // we should never get here
        } catch (Context.NullTriggerContextException e) {
            System.assert(true); // we caught it
        }

        Context c = Context.beforeInsert(new List<SObject> ());
        System.assertEquals(TriggerOperation.BEFORE_INSERT, c.operation);
        System.assertEquals(new List<SObject> (), c.newList);
        System.assertEquals(null, c.newMap);
        System.assertEquals(null, c.oldList);
        System.assertEquals(null, c.oldMap);
        System.assertEquals(false, c.hasIds);
        System.assertEquals(true, c.hasNew);
        System.assertEquals(false, c.hasOld);
        System.assertEquals(true, c.isInsert);
        System.assertEquals(false, c.isUpdate);
        System.assertEquals(false, c.isDelete);
        System.assertEquals(false, c.isUndelete);
        System.assertEquals(true, c.isBefore);
        System.assertEquals(false, c.isAfter);
        System.assertEquals(null, c.objectType);
        System.assertEquals(0, c.size);
    }

    private static testMethod void beforeInsertTestSingle() {
        SObject sobj = getSObj(false);
        Context c = Context.beforeInsert(sobj);
        System.assertEquals(TriggerOperation.BEFORE_INSERT, c.operation);
        System.assertEquals(new List<SObject> {sobj}, c.newList);
        System.assertEquals(null, c.newMap);
        System.assertEquals(null, c.oldList);
        System.assertEquals(null, c.oldMap);
        System.assertEquals(false, c.hasIds);
        System.assertEquals(true, c.hasNew);
        System.assertEquals(false, c.hasOld);
        System.assertEquals(true, c.isInsert);
        System.assertEquals(false, c.isUpdate);
        System.assertEquals(false, c.isDelete);
        System.assertEquals(false, c.isUndelete);
        System.assertEquals(true, c.isBefore);
        System.assertEquals(false, c.isAfter);
        System.assertEquals(Trig_Test_Object__c.SObjectType, c.objectType);
        System.assertEquals(1, c.size);
    }

    private static testMethod void afterInsertTest() {
        // null test
        try {
            Context.afterInsert(NULL_MAP);
            System.assert(false); // we should never get here
        } catch (Context.NullTriggerContextException e) {
            System.assert(true); // we caught it
        }

        Context c = Context.afterInsert(new Map<Id, SObject> ());
        System.assertEquals(TriggerOperation.AFTER_INSERT, c.operation);
        System.assertEquals(new List<SObject> (), c.newList);
        System.assertEquals(new Map<Id, SObject> (), c.newMap);
        System.assertEquals(null, c.oldList);
        System.assertEquals(null, c.oldMap);
        System.assertEquals(true, c.hasIds);
        System.assertEquals(true, c.hasNew);
        System.assertEquals(false, c.hasOld);
        System.assertEquals(true, c.isInsert);
        System.assertEquals(false, c.isUpdate);
        System.assertEquals(false, c.isDelete);
        System.assertEquals(false, c.isUndelete);
        System.assertEquals(false, c.isBefore);
        System.assertEquals(true, c.isAfter);
        System.assertEquals(null, c.objectType);
        System.assertEquals(0, c.size);
    }

    private static testMethod void afterInsertTestSingle() {
        SObject sobj = getSObj(true);
        Context c = Context.afterInsert(sobj);
        System.assertEquals(TriggerOperation.AFTER_INSERT, c.operation);
        System.assertEquals(new List<SObject> {sobj}, c.newList);
        System.assertEquals(new Map<Id, SObject> {sobj.Id => sobj}, c.newMap);
        System.assertEquals(null, c.oldList);
        System.assertEquals(null, c.oldMap);
        System.assertEquals(true, c.hasIds);
        System.assertEquals(true, c.hasNew);
        System.assertEquals(false, c.hasOld);
        System.assertEquals(true, c.isInsert);
        System.assertEquals(false, c.isUpdate);
        System.assertEquals(false, c.isDelete);
        System.assertEquals(false, c.isUndelete);
        System.assertEquals(false, c.isBefore);
        System.assertEquals(true, c.isAfter);
        System.assertEquals(Trig_Test_Object__c.SObjectType, c.objectType);
        System.assertEquals(1, c.size);
    }

    private static testMethod void beforeUpdateTest() {
        // null test
        try {
            Context.beforeUpdate(NULL_MAP, NULL_MAP);
            System.assert(false); // we should never get here
        } catch (Context.NullTriggerContextException e) {
            System.assert(true); // we caught it
        }

        Context c = Context.beforeUpdate(new Map<Id, SObject> (), new Map<Id, SObject> ());
        System.assertEquals(TriggerOperation.BEFORE_UPDATE, c.operation);
        System.assertEquals(new List<SObject> (), c.newList);
        System.assertEquals(new Map<Id, SObject> (), c.newMap);
        System.assertEquals(new List<SObject> (), c.oldList);
        System.assertEquals(new Map<Id, SObject> (), c.oldMap);
        System.assertEquals(true, c.hasIds);
        System.assertEquals(true, c.hasNew);
        System.assertEquals(true, c.hasOld);
        System.assertEquals(false, c.isInsert);
        System.assertEquals(true, c.isUpdate);
        System.assertEquals(false, c.isDelete);
        System.assertEquals(false, c.isUndelete);
        System.assertEquals(true, c.isBefore);
        System.assertEquals(false, c.isAfter);
        System.assertEquals(null, c.objectType);
        System.assertEquals(0, c.size);
    }

    private static testMethod void beforeUpdateTestSingle() {
        SObject sobj = getSObj(true);
        Context c = Context.beforeUpdate(sobj, sobj);
        System.assertEquals(TriggerOperation.BEFORE_UPDATE, c.operation);
        System.assertEquals(new List<SObject> {sobj}, c.newList);
        System.assertEquals(new Map<Id, SObject> {sobj.Id => sobj}, c.newMap);
        System.assertEquals(new List<SObject> {sobj}, c.oldList);
        System.assertEquals(new Map<Id, SObject> {sobj.Id => sobj}, c.oldMap);
        System.assertEquals(true, c.hasIds);
        System.assertEquals(true, c.hasNew);
        System.assertEquals(true, c.hasOld);
        System.assertEquals(false, c.isInsert);
        System.assertEquals(true, c.isUpdate);
        System.assertEquals(false, c.isDelete);
        System.assertEquals(false, c.isUndelete);
        System.assertEquals(true, c.isBefore);
        System.assertEquals(false, c.isAfter);
        System.assertEquals(Trig_Test_Object__c.SObjectType, c.objectType);
        System.assertEquals(1, c.size);
    }

    private static testMethod void afterUpdateTest() {
        // null test
        try {
            Context.afterUpdate(NULL_MAP, NULL_MAP);
            System.assert(false); // we should never get here
        } catch (Context.NullTriggerContextException e) {
            System.assert(true); // we caught it
        }

        Context c = Context.afterUpdate(new Map<Id, SObject> (), new Map<Id, SObject> ());
        System.assertEquals(TriggerOperation.AFTER_UPDATE, c.operation);
        System.assertEquals(new List<SObject> (), c.newList);
        System.assertEquals(new Map<Id, SObject> (), c.newMap);
        System.assertEquals(new List<SObject> (), c.oldList);
        System.assertEquals(new Map<Id, SObject> (), c.oldMap);
        System.assertEquals(true, c.hasIds);
        System.assertEquals(true, c.hasNew);
        System.assertEquals(true, c.hasOld);
        System.assertEquals(false, c.isInsert);
        System.assertEquals(true, c.isUpdate);
        System.assertEquals(false, c.isDelete);
        System.assertEquals(false, c.isUndelete);
        System.assertEquals(false, c.isBefore);
        System.assertEquals(true, c.isAfter);
        System.assertEquals(null, c.objectType);
        System.assertEquals(0, c.size);
    }

    private static testMethod void afterUpdateTestSingle() {
        SObject sobj = getSObj(true);
        Context c = Context.afterUpdate(sobj, sobj);
        System.assertEquals(TriggerOperation.AFTER_UPDATE, c.operation);
        System.assertEquals(new List<SObject> {sobj}, c.newList);
        System.assertEquals(new Map<Id, SObject> {sobj.Id => sobj}, c.newMap);
        System.assertEquals(new List<SObject> {sobj}, c.oldList);
        System.assertEquals(new Map<Id, SObject> {sobj.Id => sobj}, c.oldMap);
        System.assertEquals(true, c.hasIds);
        System.assertEquals(true, c.hasNew);
        System.assertEquals(true, c.hasOld);
        System.assertEquals(false, c.isInsert);
        System.assertEquals(true, c.isUpdate);
        System.assertEquals(false, c.isDelete);
        System.assertEquals(false, c.isUndelete);
        System.assertEquals(false, c.isBefore);
        System.assertEquals(true, c.isAfter);
        System.assertEquals(Trig_Test_Object__c.SObjectType, c.objectType);
        System.assertEquals(1, c.size);
    }

    private static testMethod void beforeDeleteTest() {
        // null test
        try {
            Context.beforeDelete(NULL_MAP);
            System.assert(false); // we should never get here
        } catch (Context.NullTriggerContextException e) {
            System.assert(true); // we caught it
        }

        Context c = Context.beforeDelete(new Map<Id, SObject> ());
        System.assertEquals(TriggerOperation.BEFORE_DELETE, c.operation);
        System.assertEquals(null, c.newList);
        System.assertEquals(null, c.newMap);
        System.assertEquals(new List<SObject> (), c.oldList);
        System.assertEquals(new Map<Id, SObject> (), c.oldMap);
        System.assertEquals(true, c.hasIds);
        System.assertEquals(true, c.hasNew);
        System.assertEquals(true, c.hasOld);
        System.assertEquals(false, c.isInsert);
        System.assertEquals(false, c.isUpdate);
        System.assertEquals(true, c.isDelete);
        System.assertEquals(false, c.isUndelete);
        System.assertEquals(true, c.isBefore);
        System.assertEquals(false, c.isAfter);
        System.assertEquals(null, c.objectType);
        System.assertEquals(0, c.size);
    }

    private static testMethod void beforeDeleteTestSingle() {
        SObject sobj = getSObj(true);
        Context c = Context.beforeDelete(sobj);
        System.assertEquals(TriggerOperation.BEFORE_DELETE, c.operation);
        System.assertEquals(null, c.newList);
        System.assertEquals(null, c.newMap);
        System.assertEquals(new List<SObject> {sobj}, c.oldList);
        System.assertEquals(new Map<Id, SObject> {sobj.Id => sobj}, c.oldMap);
        System.assertEquals(true, c.hasIds);
        System.assertEquals(true, c.hasNew);
        System.assertEquals(true, c.hasOld);
        System.assertEquals(false, c.isInsert);
        System.assertEquals(false, c.isUpdate);
        System.assertEquals(true, c.isDelete);
        System.assertEquals(false, c.isUndelete);
        System.assertEquals(true, c.isBefore);
        System.assertEquals(false, c.isAfter);
        System.assertEquals(Trig_Test_Object__c.SObjectType, c.objectType);
        System.assertEquals(1, c.size);
    }

    private static testMethod void afterDeleteTest() {
        // null test
        try {
            Context.afterDelete(NULL_MAP);
            System.assert(false); // we should never get here
        } catch (Context.NullTriggerContextException e) {
            System.assert(true); // we caught it
        }

        Context c = Context.afterDelete(new Map<Id, SObject> ());
        System.assertEquals(TriggerOperation.AFTER_DELETE, c.operation);
        System.assertEquals(null, c.newList);
        System.assertEquals(null, c.newMap);
        System.assertEquals(new List<SObject> (), c.oldList);
        System.assertEquals(new Map<Id, SObject> (), c.oldMap);
        System.assertEquals(true, c.hasIds);
        System.assertEquals(false, c.hasNew);
        System.assertEquals(true, c.hasOld);
        System.assertEquals(false, c.isInsert);
        System.assertEquals(false, c.isUpdate);
        System.assertEquals(true, c.isDelete);
        System.assertEquals(false, c.isUndelete);
        System.assertEquals(false, c.isBefore);
        System.assertEquals(true, c.isAfter);
        System.assertEquals(null, c.objectType);
        System.assertEquals(0, c.size);
    }

    private static testMethod void afterDeleteTestSingle() {
        SObject sobj = getSObj(true);
        Context c = Context.afterDelete(sobj);
        System.assertEquals(TriggerOperation.AFTER_DELETE, c.operation);
        System.assertEquals(null, c.newList);
        System.assertEquals(null, c.newMap);
        System.assertEquals(new List<SObject> {sobj}, c.oldList);
        System.assertEquals(new Map<Id, SObject> {sobj.id => sobj}, c.oldMap);
        System.assertEquals(true, c.hasIds);
        System.assertEquals(false, c.hasNew);
        System.assertEquals(true, c.hasOld);
        System.assertEquals(false, c.isInsert);
        System.assertEquals(false, c.isUpdate);
        System.assertEquals(true, c.isDelete);
        System.assertEquals(false, c.isUndelete);
        System.assertEquals(false, c.isBefore);
        System.assertEquals(true, c.isAfter);
        System.assertEquals(Trig_Test_Object__c.SObjectType, c.objectType);
        System.assertEquals(1, c.size);
    }

    private static testMethod void afterUndeleteTest() {
        // null test
        try {
            Context.afterUndelete(NULL_MAP);
            System.assert(false); // we should never get here
        } catch (Context.NullTriggerContextException e) {
            System.assert(true); // we caught it
        }

        Context c = Context.afterUndelete(new Map<Id, SObject> ());
        System.assertEquals(TriggerOperation.AFTER_UNDELETE, c.operation);
        System.assertEquals(new List<SObject> (), c.newList);
        System.assertEquals(new Map<Id, SObject> (), c.newMap);
        System.assertEquals(null, c.oldList);
        System.assertEquals(null, c.oldMap);
        System.assertEquals(true, c.hasIds);
        System.assertEquals(true, c.hasNew);
        System.assertEquals(false, c.hasOld);
        System.assertEquals(false, c.isInsert);
        System.assertEquals(false, c.isUpdate);
        System.assertEquals(false, c.isDelete);
        System.assertEquals(true, c.isUndelete);
        System.assertEquals(false, c.isBefore);
        System.assertEquals(true, c.isAfter);
        System.assertEquals(null, c.objectType);
        System.assertEquals(0, c.size);
    }

    private static testMethod void afterUndeleteTestSingle() {
        SObject sobj = getSObj(true);
        Context c = Context.afterUndelete(sobj);
        System.assertEquals(TriggerOperation.AFTER_UNDELETE, c.operation);
        System.assertEquals(new List<SObject> {sobj}, c.newList);
        System.assertEquals(new Map<Id, SObject> {sobj.Id => sobj}, c.newMap);
        System.assertEquals(null, c.oldList);
        System.assertEquals(null, c.oldMap);
        System.assertEquals(true, c.hasIds);
        System.assertEquals(true, c.hasNew);
        System.assertEquals(false, c.hasOld);
        System.assertEquals(false, c.isInsert);
        System.assertEquals(false, c.isUpdate);
        System.assertEquals(false, c.isDelete);
        System.assertEquals(true, c.isUndelete);
        System.assertEquals(false, c.isBefore);
        System.assertEquals(true, c.isAfter);
        System.assertEquals(Trig_Test_Object__c.SObjectType, c.objectType);
        System.assertEquals(1, c.size);
    }

    private static testMethod void objectTypeTest() {
        Account a = new Account();
        Opportunity opp = new Opportunity();
        Context c = Context.beforeInsert(a);
        System.assertEquals(Account.SObjectType, c.objectType);
        c = Context.afterDelete(opp);
        System.assertEquals(Opportunity.SObjectType, c.objectType);
        SObject nullSObject = null;
        c = Context.beforeInsert(nullSObject);
        System.assertEquals(null, c.objectType);

    }
}