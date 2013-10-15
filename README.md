Hollywood
=========
A nice place for your Ruby actors to live
-----------------------------------------

Hollywood is light system for concurrency on top of the wonderful [Celluloid](http://celluloid.io/) project. 
Its goal is to be a quick & simple way to make use of the actor pattern in Ruby.

Installation
------------
* Install the gem or add `gem "hollywood"` to your Gemfile

Usage
-----
Hollywood is made up of 3 main components: MessageWrappers, Pulses and Marshallers.

### Message Wrappers
These wrap any Ruby object which has an "update" method and turns it into an actor. They listen on one or more queues for :update messages, run the update method and announce on the outgoing queues when they are done.

### Pulses
These are very basic actors which 'pulse' update messages on a given interval. Useful (if slightly inaccurate) clocks for getting things going!

### Marshallers
These deal with the construction and wiring up of the other elements. They also recreate any actors which explode due to exceptions.

ToDo
----
1. Allow sending data in messages instead of relying on store/retreive
2. Extract the dependency on the Logging gem (It's very good but a concurrency library shouldn't have opinions on logging libraries used)
3. Add an example implementation to the documentation
4. Add an more in-depth example implementation to the documentation
