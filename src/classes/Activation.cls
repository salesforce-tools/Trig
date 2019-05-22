/**
 * Created by derekwiers on 2019-03-19.
 */

global inherited sharing class Activation {

    @TestVisible
    private static ActivationState state = Test.isRunningTest() ?
        (ActivationState) new InactiveState() :
        (ActivationState) new ActiveState();

    /**
     * Internal helper function to determine if the settings are such that a user can deactivate or otherise mess with
     * deactivation outside of tests.
     *
     * @return The Boolean permission.
     */
    public static Boolean canDeactivateOutsideOfTests() {
        return Utils.getSettings().get('Can_Deactivate_Actions').Enabled__c;
    }

    /**
     * Resets activation to the Active for non-test, and Inactive for test contexts.
     */
    global static void reset() {
        state = Test.isRunningTest() ? (ActivationState) new InactiveState() : (ActivationState) new ActiveState();
    }

    /**
     * Turns off all Actions and Handlers.  Only to be done inside testing or if the Can Deactivate Actions permission
     * is enabled.
     */
    global static void deactivate() {
        setActivationState(new InactiveState());
    }

    /**
     * Turns on all Actions and Handlers.  Only to be done inside testing or if the Can Deactivate Actions permission is
     * enabled.
     */
    global static void activate() {
        setActivationState(new ActiveState());
    }

    /**
     * Set a new ActivationState for the current context.
     *
     * @param newState The new Activation state.  Only to be done inside testing or if the Can Deactivate Actions
     *  permission is enabled.
     */
    global static void setActivationState(ActivationState newState) {
        if (Test.isRunningTest() || canDeactivateOutsideOfTests()) {
            state = newState;
        } else {
            throw new CannotDeactivateException('ActivationState is not allowed to be modified in the current context.');
        }
    }

    /**
     * Internal method to determine if the current state dictates that the given action (and handler) is currently
     * active or not.
     *
     * @param handler The handler to check.
     * @param actionName The action unique name to check.
     *
     * @return True if the given data denotes an active action; false if not.
     */
    public static Boolean isActive(Handler handler, String actionName) {
        return state.isActive(handler, actionName);
    }

    /**
     * Thrown if the user tries to deactivate something outside of testing, and the org permissions are not set to
     * allow it.
     */
    global class CannotDeactivateException extends Exception {}
}