module Browser; module DOM

class Event < Native
  def self.normalizations
    return @normalizations if @normalizations

    @normalizations = Hash.new { |_, k| k }
    @normalizations.merge!({
      load:  'DOMContentLoaded',
      hover: 'mouse:over'
    })
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

  module Target
    def callbacks
      return `#@native.callbacks` if defined?(`#@native.callbacks`)

      `#@native.callbacks = #{Hash.new {|h, k|
        h[k] = Hash.new { |h, k| h[k] = [] }
      }}`
    end

    def on(what, namespace = nil, &block)
      raise ArgumentError, 'no block has been passed' unless block

      what     = Event.normalize(what)
      callback = `function (event) {
        event = #{::Browser::DOM::Event.new(`event`)};

        #{block.call(`event`, `this == window ? #{$window} : #{::Kernel.DOM(`this`)}`)}

        return !#{`event`.stopped?};
      }`

      callbacks[what][namespace].push callback

      `#@native.addEventListener(what, callback)`

      self
    end

    def off(what, namespace = nil)
      what = Event.normalize(what)

      if namespace
        if Proc === namespace
          callbacks[what].each {|event, namespaces|
            namespaces.each {|name, callbacks|
              callbacks.reject! {|callback|
                if namespace == callback
                  `#@native.removeEventListener(what, callback)`; true
                end
              }
            }
          }
        else
          callbacks[what][namespace].clear
        end
      else
        if Proc === what
          callbacks[what].each {|event, namespaces|
            namespaces.each {|name, callbacks|
              callbacks.reject! {|callback|
                if what == callback
                  `#@native.removeEventListener(what, callback)`; true
                end
              }
            }
          }
        else
          callbacks[what].clear

          callbacks.each {|event, namespaces|
            namespaces.each {|name, callbacks|
              if what == name
                callbacks.each {|callback|
                  `#@native.removeEventListener(what, callback)`
                }

                callbacks.clear
              end
            }
          }
        end
      end
    end

    def trigger(what, data, bubble = false)
      %x{
        var event = document.createEvent('HTMLEvents');

        event.initEvent('dataavailable', bubble, true);
        event.eventName = what;
        event.data      = data;

        return #@native.dispatchEvent(event);
      }
    end
  end
end

end; end

require 'browser/dom/event/mouse'
require 'browser/dom/event/keyboard'
require 'browser/dom/event/mutation'
