# backtick_javascript: true
require 'browser/event/base'

module Browser

class Event
  def self.aliases
    @aliases ||= {
      'dom:load' => 'DOMContentLoaded',
      'hover'    => 'mouse:over'
    }
  end

  def self.name_for(name)
    (aliases[name] || name).gsub(?:, '')
  end

  def self.handlers
    @handlers ||= {}
  end

  def self.handles(*events)
    events.each { |event| Event.handlers[event] = self }
  end

  # Those events don't have interesting properties to warrant a custom class
  # or are not currently implemented.
  handles 'abort', 'afterprint', 'beforeprint', 'cached', 'canplay',
          'canplaythrough', 'change', 'chargingchange', 'chargingtimechange',
          'checking', 'close', 'dischargingtimechange', 'DOMContentLoaded',
          'downloading', 'durationchange', 'emptied', 'ended', 'error',
          'fullscreenchange', 'fullscreenerror', 'input', 'invalid',
          'levelchange', 'loadeddata', 'loadedmetadata', 'noupdate', 'obsolete',
          'offline', 'online', 'open', 'orientationchange', 'pause',
          'pointerlockchange', 'pointerlockerror', 'play', 'playing',
          'ratechange', 'readystatechange', 'reset', 'seeked', 'seeking',
          'stalled', 'submit', 'success', 'suspend', 'timeupdate', 'updateready',
          'visibilitychange', 'volumechange', 'waiting'

  def self.class_for(name)
    @handlers[name_for(name)] || Custom
  end

  def self.supported?
    true
  end

  def self.create(name, *args, &block)
    name  = name_for(name)
    klass = class_for(name)

    event = klass.new(klass.construct(name, klass.const_get(:Definition).new(&block)))
    event.arguments = args

    event
  end

  if Browser.supports? 'Event.constructor'
    def self.construct(name, desc)
      `new Event(#{name}, #{desc})`
    end
  elsif Browser.supports? 'Event.create'
    def self.construct(name, desc)
      %x{
        var event = document.createEvent("HTMLEvents");
            event.initEvent(name, desc.bubbles, desc.cancelable);

        #{return Native(`event`).merge!(desc)};
      }
    end
  elsif Browser.supports? 'Event.createObject'
    def self.construct(name, desc)
      Native(`document.createEventObject()`) \
        .merge!(desc) \
        .merge!(`{ type: name }`) \
        .to_n
    end
  else
    def self.construct(name, desc)
      Native(desc).merge!(`{ type: name }`).to_n
    end
  end

  def self.new(value, callback = nil)
    return super unless self == Event

    klass = class_for(callback ? callback.name : `value.type`)

    if klass == Event
      super
    else
      klass.new(value, callback)
    end
  end

  attr_reader :callback
  attr_writer :on

  def initialize(event, callback = nil)
    super(event)

    @callback = callback
  end

  def name
    `#@native.type`
  end

  def on
    @on || Target.convert(`#@native.currentTarget`)
  end

  def target
    Target.convert(`#@native.srcElement || #@native.target`)
  end

  def arguments
    `#@native.arguments || []`
  end

  def arguments=(args)
    `#@native.arguments = #{args}`
  end

  alias_native :bubbles?, :bubbles
  alias_native :cancelable?, :cancelable
  alias_native :data
  alias_native :phase, :eventPhase
  alias_native :at, :timeStamp

  def off
    @callback.off if @callback
  end

  def stopped?
    `!!#@native.stopped`
  end

  def stop
    `#@native.stopPropagation()` if defined?(`#@native.stopPropagation`)
    `#@native.stopped = true`
  end

  def prevent
    `#@native.preventDefault()` if defined?(`#@native.preventDefault`)
    `#@native.prevented = true`
  end

  def prevented?
    `!!#@native.prevented`
  end

  def stop!
    prevent
    stop
  end
end

end

require 'browser/event/ui'
require 'browser/event/mouse'
require 'browser/event/keyboard'
require 'browser/event/custom'
