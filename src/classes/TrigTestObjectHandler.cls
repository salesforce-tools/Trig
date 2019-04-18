/**
 * Created by derekwiers on 2019-03-19.
 */
public without sharing class TrigTestObjectHandler extends Handler {

    public static Boolean prefetchCalled = false;

    public override SObjectType handledSObjectType() {
        return Trig_Test_Object__c.SObjectType;
    }

    public override List<Action> beforeInsert() {
        return new List<Action> {
                new TrigTestObjectAction()
        };
    }

    public override List<Action> afterInsert() {
        return new List<Action> {
                new TrigTestObjectAction()
        };
    }

    public override List<Action> beforeUpdate() {
        return new List<Action> {
                new TrigTestObjectAction()
        };
    }

    public override List<Action> afterUpdate() {
        return new List<Action> {
                new TrigTestObjectAction()
        };
    }

    public override List<Action> beforeDelete() {
        return new List<Action> {
                new TrigTestObjectAction()
        };
    }

    public override List<Action> afterDelete() {
        return new List<Action> {
                new TrigTestObjectAction()
        };
    }

    public override List<Action> afterUndelete() {
        return new List<Action> {
                new TrigTestObjectAction()
        };
    }

    public override Map<String, Object> prefetchData(Context context) {
        prefetchCalled = true;
        return new Map<String, Object> {
            'Key' => 'Value',
            'QueryData' => [SELECT Id FROM User LIMIT 1]
        };
    }
}