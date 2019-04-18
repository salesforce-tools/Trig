/**
 * @description
 */
global interface Action {

    /**
     * Determine the nature of when the run() method will be called by setting an ActionBehavior.  This sets things like
     * a unique name for the action, as well as anti-recursion options.
     *
     * @return A new ActionBehavior that describes the behavior
     */
    ActionBehavior getBehavior();

    /**
     * Run the action.
     *
     * @param context The Trigger Context related to the current trigger.  Use this instead of Trigger.new/old/etc data.
     * @param data A simple key/value store of any data returned in the prefetch() method on the handler; useful for
     *  data that is common between multiple Actions such as queries or specific sets of Ids, etc.
     *
     * @return A RunResult object that describes the result of the action.  See RunResult documentation for more info.
     *  This can also be null if no anti-recursion benefits are needed.
     */
    RunResult run(Context context, PrefetchedData data);
}