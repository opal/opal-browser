## 0.3.5
* Add backtick_javascript magic comment to squelch warnings since Opal 1.8

## 0.3.4
* Element#children=
* Support more methods on Media
* Event::Custom to support non-enumerable properties
* DOM::Element::Form: #valid?, #request_submit, #ajax_submit
* Compatibility for Opal-RSpec 1.0

## 0.3.3
* Compatibility fix for Opal 1.4

## 0.3.2
* Cookie: refactor the module
  * Note in documentation it's available as `$document.cookies` and it's the preferred way to access it
  * Always encode a cookie with JSON, unless a new parameter `raw:` is provided

## 0.3.1
* Element#inner_dom: Reduce flickering - first build tree, then insert it
* NodeSet#to_a to be aliased to #to_ary
