# Trig
## The lightweight unit-of-work-based Salesforce trigger framework

### Background
Salesforce triggers offer immense functionality and efficiency for the Salesforce platform.
You can query and manipulate data, send emails, and dispatch asynchronous processes.
However, by themselves, you can't keep your code DRY, it's hard to test, and, once an org is large enough, code organization is a mess.

I've looked into various trigger frameworks before.  Trig is by far not the only one in this space.
Do I think it's the best? Sure, but I'm biased, and it won't work for everybody.
As a quick primer on where I'm at with this, I have looked at [Hari Krishnan's trigger framework](https://krishhari.wordpress.com/2013/07/22/an-architecture-framework-to-handle-triggers-in-the-force-com-platform/),
[Chris Aldridge's trigger framework](http://chrisaldridge.com/triggers/lightweight-apex-trigger-framework/), and others.
In my opinion, it's best to have a trigger framework that:
* Organizes code into logical units rather than grouping them based on the object they happen to be on
* Is easy to test (activate or deactivate various units of work at will)
* Handles "recursion" well (I don't like calling it that but haven't found a better term for it) where you're calling a method twice for the same data
* Hides its own internal complexity as well as possible, making client code as simple as possible

This is a tall order, to be sure.  Hari Krishnan's framework is nice because it hides some complexity by convention over configuration, but makes some of the client code (in my opinion) more complex and trigger-focused than it ought to be.
Chris Aldridge's framework is great to start out with, but leaves something to be desired once you want to organize your code into logical units, and turn those on and off individually.

### Introduction
Enter Trig.
It's a managed package on AppExchange, so the framework code is hidden from plain sight (and namespaced), though the code is freely available here if you are interested in the details (PRs welcome).
It supports the notions of an "Action" which is my way of saying "unit of work".
An Action is very simple: it's any class that implements the interface `Trig.Action` and has 2 methods: One to set some anti-recursion behavior, and one that takes in all the trigger context variables and defines whatever it is you need to do.
Add the Action in a handler (which just lists Actions), and you're done.
That's the goal, anyway.

This guide will take you through creating your first trigger and action with Trig, how to add more actions, add tests, and more advanced functionality.