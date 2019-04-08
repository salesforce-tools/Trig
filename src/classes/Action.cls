/**
 * @description
 */
global interface Action {

    /**
     * Return a unique name for this action, to be used in activations/deactivations.  This should be
     * unique across all Actions in an org, and should probably use a common convention, e.g.
     * namespace.sobjecttype.actionName.
     *
     * @return
     */
    String getUniqueName();

    /**
     * Runs the action - performing any DML as necessary and deferring as much DML as possible.
     *
     * @param context The context of the current trigger
     * @param queriedData The results of the handler's getGlobalQueriedData call
     * @return The set of Ids (if applicable) that should be logged as having been through this method.
     */
    Set<Id> run (Context context, Map<String, Object> prefetchedData);
}