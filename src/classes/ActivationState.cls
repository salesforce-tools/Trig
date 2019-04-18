/**
 * General interface for internal classes ActiveState and InactiveState to control the activation of handlers and actions.
 */

global interface ActivationState {
    /**
     * Determine if the given handler and action unique name are active.
     *
     * @param handler The Handler to test.
     * @param actionName The Unique Action Name to test.
     *
     * @return True if the given data denotes an active Action; false if not.
     */
    Boolean isActive(Handler handler, String actionName);
}