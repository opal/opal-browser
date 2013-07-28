module Browser; module DOM; class Event < Native

class Definition < Native
  def self.new(&block)
    data = super(`{}`)
    block.call(data) if block

    data.to_n
  end

  def bubbles!
    `#@native.bubbles = true`
  end

  def cancelable!
    `#@native.cancelable = true`
  end
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

    what     = Event.name(what)
    callback = `function (event) {
      event = #{::Browser::DOM::Event.new(`event`)};

      #{block.call(`event`, *`event`.arguments)};

      return !#{`event`.stopped?};
    }`

    callbacks[what][namespace].push callback

    `#@native.addEventListener(what, callback)`

    self
  end

  def off(what, namespace = nil)
    what = Event.name(what)

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

  def trigger(event, *args, &block)
    if event.is_a? String
      event = Event.create(event, *args, &block)
    end

    `#@native.dispatchEvent(#{event.to_n})`
  end
end

end; end; end
