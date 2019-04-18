/**
 * @description Misc. utils for various parts of Trig.
 */
public class Utils {

    /**
     * Returns the map of Trig permissions by name.
     *
     * @return Map of Trig permissions by name.
     */
    public static Map<String, Permission__mdt> getSettings() {
        List<Permission__mdt> perms = [SELECT Id, Label, DeveloperName, Enabled__c FROM Permission__mdt];
        Map<String, Permission__mdt> result = new Map<String, Permission__mdt> ();
        for (Permission__mdt perm : perms) {
            result.put(perm.DeveloperName, perm);
        }
        return result;
    }

    /**
     * Gets a super random String of a given length.  Base 64.
     *
     * @param length Number of characters desired.
     *
     * @return The generated String.
     */
    public static String getRandomBase64String(Integer length) {
        String menu = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz+/';
        String output = '';
        for (Integer i = 0; i < length; i++) {
            Integer index = Math.mod(Math.abs(Crypto.getRandomInteger()), 64);
            output += menu.substring(index, index+1);
        }
        return output;
    }

    /**
     * Gets a super random String of a given length. 0-9, A-Z, a-z only (base 62)
     *
     * @param length Number of characters desired.
     *
     * @return The generated String.
     */
    public static String getRandomAlphaNumericString(Integer length) {
        String menu = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
        String output = '';
        for (Integer i = 0; i < length; i++) {
            Integer index = Math.mod(Math.abs(Crypto.getRandomInteger()), 62);
            output += menu.substring(index, index+1);
        }
        return output;
    }
}