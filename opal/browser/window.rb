require 'browser/location'
require 'browser/navigator'
require 'browser/history'
require 'browser/cookies'
require 'browser/dom'
require 'browser/css'

require 'browser/window/interval'
require 'browser/window/timeout'

module Browser

class Window
  include Native::Base
  include DOM::Event::Target

  target {|value|
    $window if `#{value} == window`
  }

  def alert(text)
    `#@native.alert(text)`
  end

  def location
    Location.new(`#@native.location`) if `#@native.location`
  end

  def navigator
    Navigator.new(`#@native.navigator`) if `#@native.navigator`
  end

  def history
    History.new(`#@native.history`) if `#@native.history`
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
  def alert(*args)
    $window.alert(*args)
  end

  def once(*args, &block)
    $window.once(*args, &block)
  end

  alias once_after once
  alias after once

  def every(*args, &block)
    $window.every(*args, &block)
  end

  def log(what)
    `#{$window.to_n}.console.log(#{what})`

    what
  end
end
