/**
 * Created by derekwiers on 2019-04-12.
 */

global inherited sharing class AntiRecursion {

    public static Map<String, Set<Id>> idHistoryMap = new Map<String, Set<Id>> ();

    public static Map<String, Integer> callCount = new Map<String, Integer> ();

    public static Boolean shouldRun(String actionName, Integer callLimit) {
        return !(callCount.containsKey(actionName) && callCount.get(actionName) >= callLimit);
    }

    public static void recordActionRun(String actionName) {
        if (!callCount.containsKey(actionName)) {
            callCount.put(actionName, 1);
        } else {
            callCount.put(actionName, callCount.get(actionName) + 1);
        }

    }

    public static void recordActionRun(String actionName, Set<Id> idsProcessed) {
        if (idsProcessed != null) {
            if (!idHistoryMap.containsKey(actionName)) {
                idHistoryMap.put(actionName, new Set<Id> ());
            }
            idHistoryMap.get(actionName).addAll(idsProcessed);
        }
    }

    global static void clearRecursionHistory() {
        idHistoryMap.clear();
        callCount.clear();
    }

    public static Context getNonRepeatingContext(Context context, String actionName) {
        if (!context.hasIds) {
            return context;
        } else if (!AntiRecursion.idHistoryMap.containsKey(actionName)) {
            idHistoryMap.put(actionName, new Set<Id>());
        }
        return context.withRemovedIds(AntiRecursion.idHistoryMap.get(actionName));
    }

}