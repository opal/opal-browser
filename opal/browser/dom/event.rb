module Browser; module DOM

class Event < Native
  def self.normalizations
    @normalizations ||= Hash.new(
      load:  'DOMContentLoaded',
      hover: 'mouse:over'
    ) { |_, k| k }
  end

  def self.normalize(name)
    normalizations[name].sub(':', '')
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
    `#@native.stopPropagation()` if `#@native.stopPropagation`

    @stopped = true
  end
end

end; end

require 'browser/dom/event/mouse'
require 'browser/dom/event/keyboard'
require 'browser/dom/event/mutation'
