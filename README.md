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

```ruby
$document.on 'dom:load' do
  alert "yo dawg, I'm all loaded up in here"
end
```

It also supports a markaby inspired builder DSL which generates DOM nodes
directly instead of creating a string.

```ruby
$document.on 'dom:load' do
  DOM {
    div.info {
      span.red "I'm all cooked up."
    }
  }.append_to($document.body)
end
```

CSSOM
-----
CSSOM support is still incomplete but the useful parts are implemented, this
includes a DSL for generating a CSS style and the same DSL is also used to
change style declarations (which can either belong to a `DOM::Element` or a
`CSS::Rule::Style`).

```ruby
$document.body.style.apply {
  background color: 'black'
  color 'white'
  font family: 'Verdana'
}
```

AJAX & SJAX
-----------
The `XMLHttpRequest` API has been wrapped completely, it also optionally
supports binary results as typed-arrays.

It easily allows for synchronous and asynchronous requests.

```ruby
Browser::HTTP.get "/something.json" do
  on :success do |res|
    alert res.json.inspect
  end
end
```

WebSocket
---------
Websockets have been fully wrapped and they are easily configurable with
blocks.

```ruby
Browser::Socket.new 'ws://echo.websocket.org' do
  on :open do
    every 1 do
      puts "ping"
    end
  end

  on :message do |e|
    log "Received #{e.data}"
  end
end
```

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

Browser support
===============

* Internet Explorer 6+
* Firefox (Current - 1) or Current
* Chrome (Current - 1) or Current
* Safari 5.1+
* Opera 12.1x or (Current - 1) or Current

Any problem above browsers should be considered and reported as a bug.

(Current - 1) or Current denotes that we support the current stable version of
the browser and the version that preceded it. For example, if the current
version of a browser is 24.x, we support the 24.x and 23.x versions.

12.1x or (Current - 1) or Current denotes that we support Opera 12.1x as well
as last 2 versions of Opera. For example, if the current Opera version is 20.x,
we support Opera 12.1x, 19.x and 20.x but not Opera 15.x through 18.x.

Cross-browser testing sponsored by [BrowserStack](http://browserstack.com).

CSS selectors
-------------
Older browsers do not support CSS selector in queries, this means you'll need
external polyfills for this.

The suggested polyfill is [Sizzle](http://sizzlejs.com/), require it **before**
opal-browser.

JSON parsing
------------
Older browsers don't support JSON parsing natively, this means you'll need
external polyfills for this.

The suggested polyfill is [json2](https://github.com/douglascrockford/JSON-js),
require it **before** opal-browser.

XPath support
-------------
Not all browsers support XPath queries, I'm looking at you Internet Explorer,
this means you'll need external polyfills for this.

The suggested polyfill is
[wgxpath](https://code.google.com/p/wicked-good-xpath/), require it **before**
opal-browser.

Notes
-----
Right now all features are implemented with the stable or working-drafts API
which aren't implemented everywhere.

The current approach is to have a file for each method in the `compatibility`
directory where alternatives based on functional-presence are implemented.

You can see an example for the matches selector API [here][1].

[1]: https://github.com/opal/opal-browser/blob/master/opal/browser/compatibility/dom/element/matches.rb
