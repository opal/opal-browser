require 'browser/interval'
require 'browser/timeout'

require 'browser/window/view'
require 'browser/window/size'
require 'browser/window/scroll'
require 'browser/window/compatibility'

module Browser

# Wrapper class for the `window` object, an instance of it gets
# set to `$window`.
class Window
  def self.open(url, options)
    name     = options.delete(:name)
    features = options.map {|key, value|
      value = case value
              when true  then :yes
              when false then :no
              else            value
              end

      "#{key}=#{value}"
    }.join(?,)

    %x{
      var win = window.open(#{url}, #{name}, #{features});

      if (win == null) {
        return nil;
      }

      return #{new(`win`)};
    }
  end

  include Native

  # Alert the passed string.
  def alert(value)
    `#@native.alert(value)`

    value
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

  # Send a message to the window.
  #
  # @param message [String] the message
  # @param options [Hash] optional `to: target`
  def send!(message, options = {})
    `#@native.postMessage(#{message}, #{options[:to] || '*'})`
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

$window = Browser::Window.new(`window`)

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
