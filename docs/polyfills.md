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
