Opal-Browser - Client side web development in pure Ruby, using Opal
===================================================================

[![Gem Version](https://badge.fury.io/rb/opal-browser.svg)](http://badge.fury.io/rb/opal-browser)
[![Code Climate](http://img.shields.io/codeclimate/github/opal/opal-browser.svg)](https://codeclimate.com/github/opal/opal-browser)


This library aims to be a full-blown wrapper for all the browser API as defined by
HTML5.

It provides a very JQuery-like interface to DOM, but itself it doesn't use nor
require JQuery nor opal-jquery (which is an alternative library for interfacing
the web browser). The main difference though is that Opal-Browser goes far beyond
what JQuery does.

Usage
=====

_Gemfile_

```ruby
source 'https://rubygems.org/'

gem 'paggio', github: 'hmdne/paggio'
gem 'opal-browser'
```

_Server side (config.ru, Rakefile, Rails, Sinatra, Roda, etc. - not needed for static compilation)_

```ruby
require 'opal-browser'
# Your server code here
```

_Browser side_

```ruby
require 'opal'
require 'native'
require 'promise'
require 'browser/setup/full'

# Your Opal code here
$document.body << "Hello world!"
```

_Static Compile Opal + Opal-Browser library_

```bash
bundle exec opal -c -q opal-browser -p native -p promise -p browser/setup/full -e '#' -E > opal-browser.js
```

_Static Compile your application_

```bash
bundle exec opal -Oc -s opal -s native -s promise -s browser/setup/full app/application.rb > application.js
```

_And load it in HTML!_

```html
<!DOCTYPE html>
<html>
<head>
  <title>My Application</title>
</head>
<body>
  <script src='opal-browser.js' onload='Opal.require("native"); Opal.require("promise"); Opal.require("browser/setup/full");'></script>
  <script src='application.js'></script>
</body>
</html>
```

See the examples/integrations/ directory for various ideas on how to quickly start
development using opal-browser.

Features
========
This is a list of many currently wrapped features and some details on them.

DOM
---
DOM support is complete as far as I know, it has a very Nokogiri feel to it
with obvious differences where relevant (for instance, event handling).

```ruby
$document.ready do
  alert "yo dawg, I'm all loaded up in here"
end
```

It also supports a markaby inspired builder DSL (using Paggio) which generates
DOM nodes directly instead of creating a string.

```ruby
$document.ready do
  DOM {
    div.info {
      span.red "I'm all cooked up."
    }
  }.append_to($document.body)
end
```

Events
------

Add an event to a given element:

```ruby
$document.at_css("button").on(:click) do |e|
  e.prevent # Prevent the default action (eg. form submission)
  alert "Button clicked!"
end
```

Or add it to a parent element and use a delegator, so that an event gets fired
when any button children of `$document` is clicked:

```ruby
$document.on(:click, "button") do |e|
  e.prevent
  # e.on is a button that has been clicked
  e.on.inner_text = "Clicked!"
end
```

Run an event once with `#one` instead of `#on`, or disable an event with `#off`.

CSSOM
-----
CSSOM support (using Paggio) is still incomplete but the useful parts are
implemented, this includes a DSL for generating a CSS style and the same DSL
is also used to change style declarations (which can either belong to a
`DOM::Element` or a `CSS::Rule::Style`).

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
require 'browser/http'

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
require 'browser/socket'

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

```ruby
require 'browser/event_source'

Browser::EventSource.new '/events' do |es|
  es.on :message do |e|
    alert e.data
  end

  es.on :custom do |e|
    alert "custom #{e.data}"
  end
end
```

History
-------
The HTML5 History API has been fully wrapped.

Storage
-------
The HTML5 Storage API has been wrapped and it exports a single Storage class
that uses the most appropriate and available API to store data locally.

```ruby
require 'browser/storage'

$storage = $window.storage
$storage[:hello] = "world"
```

Database SQL
------------
WebSQL has been fully wrapped (Chromium-only)

```ruby
require 'browser/database/sql'

db = Browser::Database::SQL.new 'test'
db.transaction {|t|
  t.query('CREATE TABLE test(ID INTEGER PRIMARY KEY ASC, text TEXT)').then {
    t.query('INSERT INTO test (id, text) VALUES(?, ?)', 1, 'huehue')
  }.then {
    t.query('INSERT INTO test (id, text) VALUES(?, ?)', 2, 'jajaja')
  }.then {
    t.query('SELECT * FROM test')
  }.then {|r|
    r.each {|row|
      alert row.inspect
    }
  }
}
```

Browser support
===============

* Edge (Current - 3) to Current
* Firefox (Current - 3) to Current
* Chrome (Current - 3) to Current
* Safari (Current - 3) to Current
* Opera (Current - 3) to Current

Any problem above browsers should be considered and reported as a bug.

(Current - 3) to Current denotes that we support the current major stable version
of the browser and 3 versions preceding it. For example, if the current version
of a browser is 24.x, we support all versions between 21.x to 24.x.

We will accept compatibility patches for even earlier browser versions. Opal-Browser
is written in such a way, that it integrates a robust compatibility check system,
similar to Modernizr, and the history of this library goes even as far as supporting
Internet Explorer 6.

See the [polyfills documentation](docs/polyfills.md) if you wish to polyfill some
behaviors not supported by the ancient web browsers (like `querySelectorAll`).

License
=======

(The MIT License)

Copyright (C) 2013-2018 by meh<br>
Copyright (C) 2019-2021 hmdne and the Opal-Browser contributors

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
