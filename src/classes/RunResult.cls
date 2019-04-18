/**
 * Created by derekwiers on 2019-04-15.
 */

global without sharing class RunResult {

    public Set<Id> completedIds = new Set<Id> ();
    public Boolean markAsComplete = false;

    global RunResult(Set<Id> completedIds) {
        this.completedIds = completedIds;
    }

    global RunResult(Boolean markAsComplete) {
        this.markAsComplete = markAsComplete;
    }
}