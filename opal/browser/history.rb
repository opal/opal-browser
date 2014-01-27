require 'browser/location'

module Browser

# {History} allows manipulation of the session history.
#
# @see https://developer.mozilla.org/en-US/docs/Web/API/History
class History
  # Check if HTML5 history is supported.
  def self.supported?
    Browser.supports? 'History'
  end

  include Native

  # @!attribute [r] length
  # @return [Integer] how many items are in the history
  alias_native :length

  # Go back in the history.
  #
  # @param number [Integer] how many items to go back
  def back(number = 1)
    `#@native.go(-number)`
  end

  # Go forward in the history.
  #
  # @param number [Integer] how many items to go forward
  def forward(number = 1)
    `#@native.go(number)`
  end

  # Push an item in the history.
  #
  # @param item [String] the item to push in the history
  # @param data [Object] additional state to push
  def push(item, data = nil)
    data = `null` if data.nil?

    `#@native.pushState(data, null, item)`
  end

  # Replace the current history item with another.
  #
  # @param item [String] the item to replace with
  # @param data [Object] additional state to replace
  def replace(item, data = nil)
    data = `null` if data.nil?

    `#@native.replaceState(data, null, item)`
  end

  # @!attribute [r] current
  # @return [String] the current item
  def current
    $window.location.path
  end

  # @!attribute [r] state
  # @return [Object] the current state
  if Browser.supports? 'History.state'
    def state
      %x{
        var state = #@native.state;

        if (state == null) {
          return nil;
        }
        else {
          return state;
        }
      }
    end
  else
    def state
      raise NotImplementedError, 'history state unsupported'
    end
  end
end

class Window
  # @!attribute [r] history
  # @return [History] the history for this window
  def history
    History.new(`#@native.history`) if `#@native.history`
  end
end

end
