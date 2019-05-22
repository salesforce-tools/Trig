/**
 * @description
 */
global abstract inherited sharing class Handler {

    global abstract SObjectType handledSObjectType ();

    global virtual List<Action> beforeInsert () {
        return new List<Action> ();
    }

    global virtual List<Action> beforeUpdate () {
        return new List<Action> ();
    }

    global virtual List<Action> beforeDelete () {
        return new List<Action> ();
    }

    global virtual List<Action> afterInsert () {
        return new List<Action> ();
    }

    global virtual List<Action> afterUpdate () {
        return new List<Action> ();
    }

    global virtual List<Action> afterDelete () {
        return new List<Action> ();
    }

    global virtual List<Action> afterUndelete () {
        return new List<Action> ();
    }

    global virtual Map<String, Object> prefetchData (Context context) {
        return new Map<String, Object> ();
    }
}