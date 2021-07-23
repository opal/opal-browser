require 'opal'
require 'native'
require 'promise'
require 'browser/setup/full'

$document.head << CSS {
  rule("body") {
    margin 0
    padding 0
    overflow :hidden
  }
}

c = Browser::Canvas.new($window.view.width, $window.view.height)
$document.body << c

$window.on :resize do |e|
  c.height = $window.view.height
  c.width = $window.view.width
end

# A port of https://developer.mozilla.org/en-US/docs/Web/API/Element/mousemove_event

is_drawing = false
x, y = 0, 0
y = 0

c.on :mousedown do |e|
  x, y = e.offset.x, e.offset.y
  is_drawing = true
end

c.on :mousemove do |e|
  if is_drawing
    draw_line(c, x, y, e.offset.x, e.offset.y)
    x, y = e.offset.x, e.offset.y
  end
end

$window.on :mouseup do |e|
  if is_drawing
    draw_line(c, x, y, e.offset.x, e.offset.y)
    x, y = e.offset.x, e.offset.y
    is_drawing = false
  end
end

def draw_line(c, x1, y1, x2, y2)
  c.path do
    c.style.stroke = :black
    c.style.line.width = 1
    c.line(x1, y1, x2, y2)
    c.stroke
  end
end