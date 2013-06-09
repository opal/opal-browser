require 'browser/location'
require 'browser/navigator'
require 'browser/cookies'
require 'browser/dom'

require 'browser/window/interval'
require 'browser/window/timeout'

module Browser

class Window < Native
  def alert(text)
    `#@native.alert(text)`
  end

  def location
    Location.new(`#@native.location`) if `#@native.location`
  end

  def navigator
    Navigator.new(`#@native.navigator`) if `#@native.navigator`
  end

  def document
    DOM(`#@native.document`)
  end

  def every(time, &block)
    Interval.new(@native, time, &block)
  end

  def once(time, &block)
    Timeout.new(@native, time, &block)
  end

  alias once_after once

  alias after once
end

end

$window   = Browser::Window.new(`window`)
$document = $window.document

module Kernel
  def Window (what)
    Browser::Window.new(what)
  end

  def alert (text)
    $window.alert(text)
  end

  def log (what)
    `#{$window.to_n}.console.log(what)`
  end
end
