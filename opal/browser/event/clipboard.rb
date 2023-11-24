# backtick_javascript: true

module Browser; class Event

class Clipboard < Event
  handles 'copy', 'cut', 'paste'

  def self.supported?
    Browser.supports? 'Event.Clipboard'
  end

  class Definition < Definition
    alias_native :data=
    alias_native :type=, :dataType=
  end

  if Browser.supports? 'Event.constructor'
    def self.construct(name, desc)
      `new ClipboardEvent(#{name}, #{desc})`
    end
  end if supported?

  alias_native :data
  alias_native :type, :dataType

  # Returns a {DataTransfer} related to this event
  #
  # @see https://developer.mozilla.org/en-US/docs/Web/API/DataTransfer
  def transfer
    DataTransfer.new(`#@native.clipboardData`)
  end
end

end; end
