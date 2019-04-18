/**
 * @description Provides methods to perform DML at the end of an execution context (still synchronously)
 */
global without sharing class Defer {

    public static Map<Id, SObject> toUpdate = new Map<Id, SObject> ();

    /**
     * Given SObject(s), set them up to be updated at the end of the execution context. This should only be used
     * for SObjects that don't have anything depending on the order in which they are updated, but need to be updated
     * all the same.  Unlike in regular update calls, you can mix SObject Types in this call - Trig separates out the
     * SObjects by type for the eventual update call. If the given SObject (by ID) is already set to be updated, the
     * populated fields in the given SObject will override the populated fields in the already-enqueued SObject, if
     * there are any conflicts.  For this reason, it is best to only populate the fields that will be updated (plus ID).
     * An example would be creating a new SObject like `new Account(Name='Changed name', Id=myAccount.Id);
     *
     * @param sObjects The SObjects to update.
     */
    global static void enqueueUpdate(List<SObject> sObjects) {
        for (SObject sobj : sObjects) {
            if (sobj == null) {
                throw new DeferredDmlException('Null sObject found in Trig.defer.update command');
            } else if (sobj.Id == null) {
                throw new DeferredDmlException('Id cannot be null for update');
            } else {
                if (!toUpdate.containsKey(sobj.Id)) {
                    toUpdate.put(sobj.Id, sobj.clone(true, true, true, true));
                } else {
                    SObject existingRecord = toUpdate.get(sobj.Id);
                    for (String fieldName : sobj.getPopulatedFieldsAsMap().keySet()) {
                        existingRecord.put(fieldName, sobj.get(fieldName));
                    }
                    toUpdate.put(sobj.Id, existingRecord);
                }
            }
        }
    }

    /**
     * Given SObject(s), set them up to be updated at the end of the execution context. This should only be used
     * for SObjects that don't have anything depending on the order in which they are updated, but need to be updated
     * all the same.  Unlike in regular update calls, you can mix SObject Types in this call - Trig separates out the
     * SObjects by type for the eventual update call. If the given SObject (by ID) is already set to be updated, the
     * populated fields in the given SObject will override the populated fields in the already-enqueued SObject, if
     * there are any conflicts.  For this reason, it is best to only populate the fields that will be updated (plus ID).
     * An example would be creating a new SObject like `new Account(Name='Changed name', Id=myAccount.Id);
     *
     * @param sObj The SObject to update
     */
    global static void enqueueUpdate(SObject sObj) {
        enqueueUpdate(new List<SObject> {sObj});
    }

    /**
     * Given SObject(s), set them up to be updated at the end of the execution context. This should only be used
     * for SObjects that don't have anything depending on the order in which they are updated, but need to be updated
     * all the same.  Unlike in regular update calls, you can mix SObject Types in this call - Trig separates out the
     * SObjects by type for the eventual update call. If the given SObject (by ID) is already set to be updated, the
     * populated fields in the given SObject will override the populated fields in the already-enqueued SObject, if
     * there are any conflicts.  For this reason, it is best to only populate the fields that will be updated (plus ID).
     * An example would be creating a new SObject like `new Account(Name='Changed name', Id=myAccount.Id);
     *
     * @param sObjectMap The SObjects to update
     */
    global static void enqueueUpdate(Map<Id, SObject> sObjectMap) {
        enqueueUpdate(sObjectMap.values());
    }

    /**
     * Separates out the list by SObjectType, then updates them in sequence.
     */
    public static void executeDml() {
        Map<SObjectType, List<SObject>> toUpdateMap = new Map<SObjectType, List<SObject>> ();
        for (Id sObjId : toUpdate.keySet()) {
            SObjectType t = sObjId.getSobjectType();
            if (!toUpdateMap.containsKey(t)) {
                toUpdateMap.put(t, new List<SObject> ());
            }
            toUpdateMap.get(t).add(toUpdate.get(sObjId));
        }
        for (List<SObject> sObjectList : toUpdateMap.values()) {
            for (SObject sobj : sObjectList) {
                toUpdate.remove(sobj.Id);
            }
            update sObjectList;
        }
    }

    global class DeferredDmlException extends Exception {}
}