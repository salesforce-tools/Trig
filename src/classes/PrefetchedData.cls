/**
 * Created by derekwiers on 2019-04-15.
 */

global inherited sharing class PrefetchedData {
    global Map<String, Object> data = new Map<String, Object> ();

    global PrefetchedData(Map<String, Object> data) {
        this.data = data;
    }
}