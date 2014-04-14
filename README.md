Clingfilm
=========
A nice place for your Ruby actors to live
-----------------------------------------

Clingfilm is a light system for adding concurrency to Ruby projects, built with the wonderful [Celluloid](http://celluloid.io/) project.
Its goal is to be a quick & simple way to make use of the actor concurrency pattern in Ruby.

Installation
------------
* Install the gem or add `gem "clingfilm"` to your Gemfile

Usage
-----
Clingfilm is made up of 3 main components: `MessageWrappers`, `Pulses` and `Marshallers`.

### Message Wrappers
Message wrappers wrap any Ruby object which has an `update` method and turns it into an actor.
They are subcribed to one or many incomming queues and can be subscribed to multiple outgoing queues.

The wrapper listens for messages on the incoming queues. Arriving messages trigger the  `update` method on the wrapped object.

Data returned by `update` is placed on any configured outgoing queues. If the result of `update` is `nil` then nothing is announced on any queues.

### Pulses
Pulses are very basic actors which 'pulse' `:update` messages on a given interval. Useful (if slightly inaccurate) clocks for getting things going!

### Marshallers
Marshallers deal with the construction and wiring up of the other elements. They also recreate any actors which die (or heroically explode!) due to uncaught exceptions.

Logging
-------
Clingfilm publishes log messages about the sending and receiving of messages between actors at the debug level.
The logging is done using Celluloid's logging mechanism, which is null unless set; for example, in Rails:
```
Celluloid.logger = Rails.logger
```
More details can be read in the [Celluloid logging docs](https://github.com/celluloid/celluloid/wiki/Logging).

ToDo
----
1. Add an example implementation to the documentation
