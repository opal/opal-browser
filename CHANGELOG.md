## 0.3.2
* Cookie: refactor the module
  * Note in documentation it's available as `$document.cookies` and it's the preferred way to access it
  * Always encode a cookie with JSON, unless a new parameter `raw:` is provided

## 0.3.1
* Element#inner_dom: Reduce flickering - first build tree, then insert it
* NodeSet#to_a to be aliased to #to_ary