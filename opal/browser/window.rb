require 'browser/location'
require 'browser/navigator'
require 'browser/history'
require 'browser/interval'
require 'browser/timeout'
require 'browser/console'
require 'browser/screen'
require 'browser/cookies'

require 'browser/dom'
require 'browser/css'

require 'browser/window/view'
require 'browser/window/size'
require 'browser/window/scroll'
require 'browser/window/compatibility'

module Browser

# Wrapper class for the `window` object, an instance of it gets
# set to `$window`.
class Window
  include Native::Base
  include DOM::Event::Target

  target {|value|
    $window if `#{value} == window`
  }

  # Alert the passed string.
  def alert(value)
    `#@native.alert(value)`

    value
  end

  # Get the {Location} object for this window.
  #
  # @return [Location]
  def location
    Location.new(`#@native.location`) if `#@native.location`
  end

  # Get the {Navigator} object for this window.
  #
  # @return [Navigator]
  def navigator
    Navigator.new(`#@native.navigator`) if `#@native.navigator`
  end

  # Get the {History} object for this window.
  #
  # @return [History]
  def history
    History.new(`#@native.history`) if `#@native.history`
  end

  # Get the {DOM::Document} for this window.
  #
  # @return [DOM::Document]
  def document
    DOM(`#@native.document`)
  end

  # Get the {Console} for this window.
  #
  # @return [Console]
  def console
    Console.new(`#@native.console`)
  end

  # Get the {Screen} for this window.
  #
  # @return [Screen]
  def screen
    Screen.new(`#@native.screen`)
  end

  # Get the {View} for the window.
  #
  # @return [View]
  def view
    View.new(self)
  end

  # Get the {Size} for this window.
  #
  # @return [Size]
  def size
    Size.new(self)
  end

  # Get the {Scroll} for this window.
  #
  # @return [Scroll]
  def scroll
    Scroll.new(self)
  end

  # Execute the block every given seconds.
  #
  # @param time [Float] the seconds between every call
  # @return [Interval] the object representing the interval
  def every(time, &block)
    Interval.new(@native, time, &block)
  end

  # Execute a block after the given seconds.
  #
  # @param time [Float] the seconds after it gets called
  # @return [Timeout] the object representing the timeout
  def once(time, &block)
    Timeout.new(@native, time, &block)
  end

  alias once_after once

  alias after once
end

end

$window   = Browser::Window.new(`window`)
$document = $window.document
$console  = $window.console

module Kernel
  # (see Browser::Window#alert)
  def alert(value)
    $window.alert(value)
  end

  # (see Browser::Window#once)
  def once(time, &block)
    $window.once(time, &block)
  end

  alias once_after once
  alias after once

  # (see Browser::Window#every)
  def every(time, &block)
    $window.every(time, &block)
  end
end
