module Browser; module DOM

class Event < Native
  Normalization = {
    load:  'DOMContentLoaded',
    hover: 'mouseover'
  }

  def self.normalize (name)
    Normalization[name] || name
  end

  def self.new(value)
    %x{
      if (value instanceof MouseEvent) {
        return #{Mouse.new(value)};
      }
      else if (value instanceof KeyboardEvent) {
        return #{Keyboard.new(value)};
      }
      else if (value instanceof MutationEvent) {
        return #{Mutation.new(value)};
      }
      else {
        return #{super(value)};
      }
    }
  end

  def name
    `#@native.eventName`
  end

  def data
    `#@native.data`
  end

  def stopped?; !!@stopped; end

  def stop!
    @stopped = true
  end
end

end; end

require 'browser/dom/event/mouse'
require 'browser/dom/event/keyboard'
require 'browser/dom/event/mutation'
