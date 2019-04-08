# Trig
## The Abstract Trigger Framework

### Introduction
Salesforce Trigger Frameworks are growing more popular, and it is well they should.
Logic-less triggers, abstraction, anti-recursion, and DRY are all great concepts.

One problem I've found with the currently available set of trigger frameworks is that
they keep you thinking about the framework instead of the processes that you are trying
to write.

### Goals
Similarly to any other Trigger Framework, my goals are:

* ##### Logic-less triggers
There is to be only 1 line of code in each trigger - enough
to call the framework and nothing more.
* ##### 1 Trigger per Object
Triggers will be listening on all 7 possible Trigger Operations
* ##### Avoiding God Classes
God classes would naturally arise in many trigger frameworks when
a particular object has a complex set of operations on its triggers.  Trig aims to avoid this by
splitting logically different processes into different files, helping to support Separation
of Concerns
* ##### Easier Testing
Unit Tests can be easily created that only tests target logic, turning
all other triggers and actions off.  Likewise, all logic can be turned on and the code can be
tested as it would be in production.  Furthermore, the Context object in Trig abstracts the
common Trigger context variables away so that you can mock them easily for testing.
* ##### Avoiding Trigger Recursion
A particular process will never be called twice on the same
record if the process marked the record has having been processed.  This gives a good balance
of being in control of multiple recursions while also being very simple to facilitate and mentally
understand.
* ##### Shared Data between Processes
One pitfall of entirely isolating disparate processes is that
SOQL query limits can tend to go through the roof.  Trig circumvents that by providing a way to
"prefetch" common data ahead of time and access it in multiple processes by key later.
* ##### Deferred DML
It's not uncommon that 2 or more processes would have some overlap in the
records they need to update.  A great way to prevent making 2 update calls is Deferred DML, where
you can simply specify the field(s) to be updated, and the Trig will gather them to be updated once at
the end of the transaction.

### Example Code
Let's try a simple example: When you update an Account Shipping address, all Contacts on that account must
update to that address as well.

Account.trigger:
```
trigger Account on Account (before insert, after insert, before update, after update, before delete, after delete, after undelete) {
    Trig.Dispatcher.run(new AccountHandler());
}
```

AccountHandler.cls:
```
public without sharing class AccountHandler extends Trig.Handler {

    public override SObjectType handledSObjectType() {
        return Account.SObjectType;
    }

    /**
    * Defines the list of Actions that occurs upon After Update.  Simply instantiates the list
    * and returns it.
    *
    * @return The list of Actions to run.
    */
    public override List<Trig.Action> afterUpdate() {
        return new List<Trig.Action> {
            new ContactAddressUpdaterAction()
        };
    }
    
    /**
    * This is run before any of the Lifecycle methods are run, in order to run shared queries etc.
    * In this case, we are using it to query Contacts, as that is a common occurrence in Account
    * triggers.  We can add on to this query as necessary, as we add more functionality that needs
    * to use the same records.
    *
    * @param context The Trigger Context information
    *
    * @return A key-value pair of whatever data is needed across Actions.
    */
    public override Map<String, Object> prefetchData (Trig.Context context) {
        Map<String, Object> prefetchedData = new Map<String, Object> ();
        if (context.hasNew && context.hasIds) {
            prefetchedData.put('Contacts', [
                SELECT
                    Id,
                    Name,
                    MailingStreet,
                    MailingCity,
                    MailingState,
                    MailingCountry
                FROM Contact
                WHERE AccountId IN :context.newMap.keySet()]);
        }
        return prefetchedData;
    }
}
```

ContactAddressUpdaterAction.cls:
```
public without sharing class ContactAddressUpdaterAction implements Trig.Action {

    public String getUniqueName() {
        return 'Account.ContactAddressUpdater';
    }

    /**
    * Called by the framework.  The actual logic of the process we want to run.  Uses
    * Deferred DML because contacts are a likely target of DML on Account triggers.
    *
    * @param context Trigger Context variable
    * @param prefetchedData Any data returned by the Handler's prefetch method
    *
    * @return Set of Account Ids that we don't want to see again through this process.
    */
    public Set<Id> run(Trig.Context context, Map<String, Object> prefetchedData) {
        List<Contact> contacts = (List<Contact>) prefetchedData.get('Contacts');
        for (Contact c : contacts) {
            Account acc = (Account)context.newMap.get(c.AccountId);

            // using deferred DML; only set fields that we need to change
            Contact contactToUpdate = new Contact(Id=c.Id);
            Boolean updated = false;

            if (acc.ShippingStreet != c.MailingStreet) {
                contactToUpdate.ShippingStreet = acc.ShippingStreet;
                updated = true;
            }
            if (acc.ShippingCity != c.ShippingCity) {
                contactToUpdate.ShippingCity = acc.ShippingCity;
                updated = true;
            }
            if (acc.ShippingState != c.ShippingState) {
                contactToUpdate.ShippingState = acc.ShippingState;
                updated = true;
            }
            if (acc.ShippingCountry != c.ShippingCountry) {
                contactToUpdate.ShippingCountry = acc.ShippingCountry;
                updated = true;
            }

            if (updated) {
                Trig.DML.deferUpdate(contactToUpdate);
            }
        }
        // return all of the Account Ids, since we've processed them all.
        return context.newMap.keySet();
    }
}
```
The key takeaway here is that once the trigger is written, it does not change; once the handler is written, it only
gets minimally updated to reference new Actions and prefetch more data; so the only thing you need focus on when you
need new functionality is the new Action itself, which is more or less self-contained.
What's more is that Actions are turned off by default in unit tests - turn only certain one(s) on to perform
a unit test in near-isolation; then easily switch them all on to perform a test in context with the rest of
your code.