/**
 * Created by derekwiers on 2019-03-19.
 */
public without sharing class TrigTestObjectAction implements Action {

    public static Map<String, Integer> timesRunMap = new Map<String, Integer>();
    public static final String UNIQUE_NAME = 'Trig.TrigTestObject.TrigTestObjectAction';

    public ActionBehavior getBehavior() {
        return new ActionBehavior(this, UNIQUE_NAME).setById().setCallLimit(3);
    }

    public RunResult run(Context context, PrefetchedData data) {
        incrementMap(context.operation.name());
        if (context.hasIds) {
            return new RunResult(context.hasNew ? context.newMap.keySet() : context.oldMap.keySet());
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