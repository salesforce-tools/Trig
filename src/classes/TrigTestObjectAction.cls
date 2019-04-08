/**
 * Created by derekwiers on 2019-03-19.
 */
public without sharing class TrigTestObjectAction implements Action {

    public static Map<String, Integer> timesRunMap = new Map<String, Integer>();

    public String getUniqueName() {
        incrementMap('getUniqueName');
        return 'Trig.TrigTestObject.TrigTestObjectAction';
    }

    public Set<Id> run(Context context, Map<String, Object> prefetchedData) {
        incrementMap(context.operation.name());
        if (context.hasIds) {
            return context.hasNew ? context.newMap.keySet() : context.oldMap.keySet();
        } else {
            return null;
        }
    }

    private void incrementMap(String key) {
        if (!timesRunMap.containsKey(key)) {
            timesRunMap.put(key, 0);
        }
        timesRunMap.put(key, timesRunMap.get(key) + 1);
    }

}