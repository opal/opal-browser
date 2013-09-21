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
$document.on :load do
  alert "yo dawg, I'm all loaded up in here"
end
```

It also supports a markaby inspired builder DSL which generates DOM nodes
directly instead of creating a string.

```ruby
$document.on :load do
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

Cross-browser compatibility
===========================
Right now all features are implemented with the stable or working-drafts API
which aren't implemented everywhere.

The current approach is to have a file for each method in the `compatibility`
directory where alternatives based on functional-presence are implemented.

You can see an example for the matches selector API [here][1].

[1]: https://github.com/opal/opal-browser/blob/master/opal/browser/compatibility/dom/element/matches.rb
