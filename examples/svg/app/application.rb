require 'opal'
require 'native'
require 'promise'
require 'browser/setup/full'

elem = $document.at_css("ellipse")

$document.on :mousemove do |e|
  elem[:cx] = e.page.x
  elem[:cy] = e.page.y
end