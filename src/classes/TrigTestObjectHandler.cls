/**
 * Created by derekwiers on 2019-03-19.
 */

public with sharing class TrigTestObjectHandler extends Handler {

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
}