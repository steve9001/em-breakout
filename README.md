# EM-Breakout

Breakout is a light framework for routing messages among web browsers and workers using WebSockets.

EM-Breakout uses [EM-WebSocket](https://github.com/igrigorik/em-websocket) to implement a standalone server process that accepts connections from both browsers and workers.
Whenever a browser sends a message, it will be put on a queue to be read by the next available worker. 
A simple API lets workers send messages to browsers, disconnect a browser, and be notified when a browser connects or disconnects.

The [breakout](https://github.com/steve9001/breakout) gem provides a module to help create workers along with some example workers and JavaScripts.

## Getting started

Clone the repository and change to the directory. Use [bundler](http://gembundler.com) to install the dependencies, and run cucumber. If that is successful, you can change into the examples directory and run the server script (possibly with 'bundle exec').

Your em-breakout server is now ready to accept connections. Visit the [breakout](https://github.com/steve9001/breakout) page and pick up from there!

## Copyright

Copyright (c) 2011 Steve Masterman. See LICENSE for details.
