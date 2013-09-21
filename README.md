Browser support for Opal
========================
This library aims to be a full-blown wrapper for all the browser API including
HTML5.

Features
========
This is a list of the currently wrapped features and some details on them.

DOM
---
DOM support is complete as far as I know, it has a very Nokogiri feel to it
with obvious differences where relevant (for instance, event handling).

It also supports a markaby inspired builder DSL which generates DOM nodes
directly instead of creating a string.

CSSOM
-----
CSSOM support is still incomplete but the useful parts are implemented, this
includes a DSL for generating a CSS style and the same DSL is also used to
change style declarations (which can either belong to a `DOM::Element` or a
`CSS::Rule::Style`).

AJAX & SJAX
-----------
The `XMLHttpRequest` API has been wrapped completely, it also optionally
supports binary results as typed-arrays.

It easily allows for synchronous and asynchronous requests.

WebSocket
---------
Websockets have been fully wrapped and they are easily configurable with
blocks.

EventSource
-----------
Event sources have been implemented and are easily configurable with blocks.

History
-------
The HTML5 History API has been fully wrapped.

Storage
-------
The HTML5 Storage API has been wrapped and it exports a single Storage class
that uses the most appropriate and available API to store data locally.

Cross-browser compatibility
===========================
Right now all features are implemented with the stable or working-drafts API
which aren't implemented everywhere.

The current approach is to have a file for each method in the `compatibility`
directory where alternatives based on functional-presence are implemented.

You can see an example for the matches selector API [here][1].

[1]: https://github.com/opal/opal-browser/blob/master/opal/browser/compatibility/dom/element/matches.rb
