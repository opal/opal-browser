# backtick_javascript: true
require 'browser/window/view'
require 'browser/window/size'

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

  include Browser::NativeCachedWrapper
  include Event::Target

  target {|value|
    $window if `#{value} == window`
  }

  # Alert the passed string.
  def alert(value)
    `#@native.alert(value)`

    value
  end

  # Display a prompt dialog with the passed string as text.
  def prompt(value, default=nil)
    `#@native.prompt(value, #{default || ""}) || nil`
  end

  # Display a confirmation dialog with the passed string as text.
  def confirm(value)
    `#@native.confirm(value) || false`
  end

  # @!attribute [r] parent
  # @return [Window] parent of the current window or subframe
  def parent
    @parent ||= Browser::Window.new(`#@native.parent`)
  end

  # @!attribute [r] top
  # @return [Window] reference to the topmost window in the window hierarchy
  def top
    @top ||= Browser::Window.new(`#@native.top`)
  end

  # @!attribute [r] opener
  # @return [Window] reference to the window that opened the window using `open`
  def opener
    @opener ||= Browser::Window.new(`#@native.opener`)
  end

  # Get the {View} for the window.
  #
  # @return [View]
  def view
    @view ||= View.new(self)
  end

  # Get the {Size} for this window.
  #
  # @return [Size]
  def size
    @size ||= Size.new(self)
  end

  # Get the {DOM::Element::Scroll} for this window.
  #
  # @return [DOM::Element::Scroll]
  def scroll
    @scroll ||= DOM::Element::Scroll.new(self)
  end

  if Browser.supports? 'Window.send'
    def send(message, options = {})
      `#@native.postMessage(#{message}, #{options[:to] || '*'})`
    end
  else
    # Send a message to the window.
    #
    # @param message [String] the message
    # @param options [Hash] optional `to: target`
    def send(message, options = {})
      raise NotImplementedError, 'message sending unsupported'
    end
  end

  def close
    `#{@native}.close()`
  end
end

end

$window = Browser::Window.new(`window`)

module Kernel
  # (see Browser::Window#alert)
  def alert(value)
    $window.alert(value)
  end

  # (see Browser::Window#prompt)
  def prompt(value, default=nil)
    $window.prompt(value, default)
  end

  # (see Browser::Window#confirm)
  def confirm(value)
    $window.confirm(value)
  end
end
