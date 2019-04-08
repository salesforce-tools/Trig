/**
 * @description Represents the Trigger Context variables for a trigger operation.
 */
global without sharing class Context {

    global List<SObject> newList {global get; private set;}
    global List<SObject> oldList {global get; private set;}
    global Map<Id, SObject> newMap {global get; private set;}
    global Map<Id, SObject> oldMap {global get; private set;}
    global TriggerOperation operation {global get; private set;}
    global Integer size {global get; private set;}

    public Context(
            List<SObject> newList,
            List<SObject> oldList,
            Map<Id, SObject> newMap,
            Map<Id, SObject> oldMap,
            TriggerOperation operation,
            Integer size
    ) {
        this.newList = newList;
        this.oldList = oldList;
        this.newMap = newMap;
        this.oldMap = oldMap;
        this.operation = operation;
        this.size = size;
    }

    public static Context fromTrigger() {
        if (!Trigger.isExecuting) {
            throw new TriggerNotExecutingException('Could not create context from trigger variables because a trigger is not executing.');
        }
        return new Context(
                Trigger.new,
                Trigger.old,
                Trigger.newMap,
                Trigger.oldMap,
                Trigger.operationType,
                Trigger.size
        );
    }

    /**
     * Creates a Context signifying a Before Insert trigger, typically used for testing.
     *
     * @param newList List of new SObjects.
     *
     * @return Context signifying a Before Insert trigger with the new SObjects.
     */
    global static Context beforeInsert(List<SObject> newList) {
        if (newList == null) {
            throw new NullTriggerContextException('Cannot create Context from null SObject list');
        }
        return new Context(
                newList, null, null, null, TriggerOperation.BEFORE_INSERT, newList.size()
        );
    }

    /**
     * Creates a Context signifying an After Insert trigger, typically used for testing.
     *
     * @param newMap A map equivalent to Trigger.newMap in an after insert trigger.
     *
     * @return Context signifying an After Insert trigger with the new SObjects.
     */
    global static Context afterInsert(Map<Id, SObject> newMap) {
        if (newMap == null) {
            throw new NullTriggerContextException('Cannot create Context from null SObject map');
        }
        return new Context(
                newMap.values(), null, newMap, null, TriggerOperation.AFTER_INSERT, newMap.size()
        );
    }

    /**
     * Creates a Context signifying a Before Update trigger, typically used for testing.
     *
     * @param oldMap A map equivalent to Trigger.oldMap in a before update trigger.
     * @param newMap A map equivalent to Trigger.newMap in a before update trigger.
     *
     * @return Context signifying a Before Update trigger with the new and old SObjects.
     */
    global static Context beforeUpdate(Map<Id, SObject> oldMap, Map<Id, SObject> newMap) {
        if (newMap == null || oldMap == null) {
            throw new NullTriggerContextException('Cannot create Context from null SObject Map');
        }
        return new Context(
                newMap.values(), oldMap.values(), newMap, oldMap, TriggerOperation.BEFORE_UPDATE, newMap.size()
        );
    }

    /**
     * Creates a Context signifying an After Update trigger, typically used for testing.
     *
     * @param oldMap A map equivalent to Trigger.oldMap in an after update trigger.
     * @param newMap A map equivalent to Trigger.newMap in an after update trigger.
     *
     * @return Context signifying an After Update trigger with the new and old SObjects.
     */
    global static Context afterUpdate(Map<Id, SObject> oldMap, Map<Id, SObject> newMap) {
        if (newMap == null || oldMap == null) {
            throw new NullTriggerContextException('Cannot create Context from null SObject Map');
        }
        return new Context(
                newMap.values(), oldMap.values(), newMap, oldMap, TriggerOperation.AFTER_UPDATE, newMap.size()
        );
    }

    /**
     * Creates a Context signifying a Before Delete trigger, typically used for testing.
     *
     * @param oldMap A map equivalent to Trigger.oldMap in a before delete trigger.
     *
     * @return Context signifying a Before Delete trigger with the old SObjects.
     */
    global static Context beforeDelete(Map<Id, SObject> oldMap) {
        if (oldMap == null) {
            throw new NullTriggerContextException('Cannot create Context from null SObject map');
        }
        return new Context(
                null, oldMap.values(), null, oldMap, TriggerOperation.BEFORE_DELETE, oldMap.size()
        );
    }

    /**
     * Creates a Context signifying an After Delete trigger, typically used for testing.
     *
     * @param oldMap A map equivalent to Trigger.oldMap in an after delete trigger.
     *
     * @return Context signifying an After Delete trigger with the old SObjects.
     */
    global static Context afterDelete(Map<Id, SObject> oldMap) {
        if (oldMap == null) {
            throw new NullTriggerContextException('Cannot create Context from null SObject map');
        }
        return new Context(
                null, oldMap.values(), null, oldMap, TriggerOperation.BEFORE_DELETE, oldMap.size()
        );
    }

    /**
     * Creates a Context signifying an After Undelete trigger, typically used for testing.
     *
     * @param newMap A map equivalent to Trigger.newMap in an after undelete trigger.
     *
     * @return Context signifying an After Undelete trigger with the new SObjects.
     */
    global static Context afterUndelete(Map<Id, SObject> newMap) {
        if (newMap == null) {
            throw new NullTriggerContextException('Cannot create Context from null SObject map');
        }
        return new Context(
                newMap.values(), null, newMap, null, TriggerOperation.AFTER_UNDELETE, newMap.size()
        );
    }

    /**
     * True if the context is before or after insert.
     */
    global Boolean isInsert {
        get {
            return new Set<TriggerOperation> {TriggerOperation.BEFORE_INSERT, TriggerOperation.AFTER_INSERT}.contains(operation);
        }
        private set;
    }

    /**
     * True if context is before or after update.
     */
    global Boolean isUpdate {
        get {
            return new Set<TriggerOperation> {TriggerOperation.AFTER_UPDATE, TriggerOperation.BEFORE_UPDATE}.contains(operation);
        }
        private set;
    }

    /**
     * True if context is before or after delete.
     */
    global Boolean isDelete {
        get {
            return new Set<TriggerOperation> {TriggerOperation.BEFORE_DELETE, TriggerOperation.AFTER_DELETE}.contains(operation);
        }
        private set;
    }

    /**
     * True if context is after undelete.
     */
    global Boolean isUndelete {
        get {
            return operation == TriggerOperation.AFTER_UNDELETE;
        }
        private set;
    }

    /**
     * True if the context refers to a trigger operating before committing to the database.
     */
    global Boolean isBefore {
        get {
            return operation.name().contains('BEFORE');
        }
        private set;
    }

    /**
     * True if the context refers to a trigger operating after committing to the database.
     */
    global Boolean isAfter {
        get {
            return operation.name().contains('AFTER');
        }
        private set;
    }

    /**
     * True if the Context refers to any operation except Before Insert, where there are not yet Ids assigned to records.
     */
    global Boolean hasIds {
        get {
            return operation != TriggerOperation.BEFORE_INSERT;
        }
        private set;
    }

    /**
     * True if oldList or oldMap is valid for the current context.
     */
    global Boolean hasOld {
        get {
            return !isInsert && !isUndelete;
        }
        private set;
    }

    /**
     * True if newList or newMap is valid for the current context.
     */
    global Boolean hasNew {
        get {
            return operation != TriggerOperation.AFTER_DELETE;
        }
        private set;
    }

    /**
     * SObjectType of the items in the current context.
     */
    global SObjectType objectType {
        get {
            if (newList != null && !newList.isEmpty()) {
                return newList[0].getSObjectType();
            } else if (oldList != null && !oldList.isEmpty()) {
                return oldList[0].getSObjectType();
            } else {
                return null;
            }
        }
        private set;
    }

    public Context withRemovedIds(Set<Id> idsToRemove) {
        Map<Id, SObject> adjustedNewMap = null;
        Map<Id, SObject> adjustedOldMap = null;
        if (newMap != null) {
            adjustedNewMap = new Map<Id, SObject> ();
            for (Id newId : newMap.keySet()) {
                if (!idsToRemove.contains(newId)) {
                    adjustedNewMap.put(newId, newMap.get(newId));
                }
            }
            if (adjustedNewMap.isEmpty()) {
                return null;
            }
        }
        if (oldMap != null) {
            adjustedOldMap = new Map<Id, SObject> ();
            for (Id oldId : oldMap.keySet()) {
                if (!idsToRemove.contains(oldId)) {
                    adjustedOldMap.put(oldId, oldMap.get(oldId));
                }
            }
            if (adjustedOldMap.isEmpty()) {
                return null;
            }
        }
        return new Context(
                adjustedNewMap == null ? null : adjustedNewMap.values(),
                adjustedOldMap == null ? null : adjustedOldMap.values(),
                adjustedNewMap,
                adjustedOldMap,
                operation,
                size
        );
    }

    global String toSummaryString() {
        return 'Trig.Context:' + operation.name() + ' on ' + String.valueOf(objectType);
    }

    /**
     * Fired if a context is being created from Trigger context variables, but there is no trigger currently executing.
     */
    global class TriggerNotExecutingException extends Exception {}

    /**
     * Fired if a context is being created, but one or more of the SObject inputs is null.
     */
    global class NullTriggerContextException extends Exception {}
}