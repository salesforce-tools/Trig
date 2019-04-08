/**
 * @description
 */
public class Utils {

    public static Map<String, Permission__mdt> getSettings() {
        List<Permission__mdt> perms = [SELECT Id, Label, DeveloperName, Enabled__c FROM Permission__mdt];
        Map<String, Permission__mdt> result = new Map<String, Permission__mdt> ();
        for (Permission__mdt perm : perms) {
            result.put(perm.DeveloperName, perm);
        }
        return result;
    }
}