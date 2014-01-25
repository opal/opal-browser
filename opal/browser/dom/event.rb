require 'browser/dom/event/base'
require 'browser/dom/event/ui'
require 'browser/dom/event/mouse'
require 'browser/dom/event/keyboard'
require 'browser/dom/event/focus'
require 'browser/dom/event/wheel'
require 'browser/dom/event/composition'
require 'browser/dom/event/animation'
require 'browser/dom/event/audio_processing'
require 'browser/dom/event/before_unload'
require 'browser/dom/event/composition'
require 'browser/dom/event/clipboard'
require 'browser/dom/event/device_light'
require 'browser/dom/event/device_motion'
require 'browser/dom/event/device_orientation'
require 'browser/dom/event/device_proximity'
require 'browser/dom/event/drag'
require 'browser/dom/event/gamepad'
require 'browser/dom/event/hash_change'
require 'browser/dom/event/progress'
require 'browser/dom/event/page_transition'
require 'browser/dom/event/pop_state'
require 'browser/dom/event/storage'
require 'browser/dom/event/touch'
require 'browser/dom/event/sensor'
require 'browser/dom/event/custom'
require 'browser/dom/event/message'
require 'browser/dom/event/close'

module Browser; module DOM

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

  def self.class_for(name)
    type = case name_for(name)
      when 'animationend', 'animationiteration', 'animationstart'
        Animation

      when 'audioprocess'
        AudioProcessing

      when 'beforeunload'
        BeforeUnload

      when 'compositionend', 'compositionstart', 'compositionupdate'
        Composition

      when 'copy', 'cut'
        Clipboard

      when 'devicelight'
        DeviceLight

      when 'devicemotion'
        DeviceMotion

      when 'deviceorientation'
        DeviceOrientation

      when 'deviceproximity'
        DeviceProximity

      when 'drag', 'dragend', 'dragleave', 'dragover', 'dragstart', 'drop'
        Drag

      when 'gamepadconnected', 'gamepaddisconnected'
        Gamepad

      when 'hashchange'
        HashChange

      when 'load', 'loadend', 'loadstart'
        Progress

      when 'pagehide', 'pageshow'
        PageTransition

      when 'popstate'
        PopState

      when 'storage'
        Storage

      when 'touchcancel', 'touchend', 'touchleave', 'touchmove', 'touchstart'
        Touch

      when 'compassneedscalibration', 'userproximity'
        Sensor

      when 'message'
        Message

      when 'close'
        Close

      when 'click', 'contextmenu', 'dblclick', 'mousedown', 'mouseenter',
           'mouseleave', 'mousemove', 'mouseout', 'mouseover', 'mouseup',
           'show'
        Mouse

      when 'keydown', 'keypress', 'keyup'
        Keyboard

      when 'blur', 'focus', 'focusin', 'focusout'
        Focus

      when 'wheel'
        Wheel

      when 'abort', 'afterprint', 'beforeprint', 'cached', 'canplay', 'canplaythrough',
           'change', 'chargingchange', 'chargingtimechange', 'checking', 'close',
           'dischargingtimechange', 'DOMContentLoaded', 'downloading', 'durationchange',
           'emptied', 'ended', 'error', 'fullscreenchange', 'fullscreenerror', 'input',
           'invalid', 'levelchange', 'loadeddata', 'loadedmetadata', 'noupdate', 'obsolete',
           'offline', 'online', 'open', 'orientationchange', 'pause', 'pointerlockchange',
           'pointerlockerror', 'play', 'playing', 'ratechange', 'readystatechange', 'reset',
           'seeked', 'seeking', 'stalled', 'submit', 'success', 'suspend', 'timeupdate',
           'updateready', 'visibilitychange', 'volumechange', 'waiting'
        Event

      else
        Custom
    end

    if type == Custom
      Custom
    elsif type.supported?
      type
    else
      Event
    end
  end

  def self.supported?
    true
  end

  def self.create(name, *args, &block)
    name  = name_for(name)
    klass = class_for(name)

    event           = klass.new(klass.construct(name, klass.const_get(:Definition).new(&block)))
    event.arguments = args

    event
  end

  # @private
  def self.construct(name, desc)
    raise NotImplementedError
  end

  def self.new(value, *args)
    return super unless self == Event

    klass = class_for(`value.type`)

    if klass == Event
      super
    else
      klass.new(value, *args)
    end
  end

  attr_reader :callback
  attr_writer :element

  def initialize(event, element = nil, callback = nil)
    super(event)

    @element  = element
    @callback = callback
  end

  def element
    Target.convert(@element)
  end

  def target
    Target.convert(`#@native.target`)
  end

  def off
    @callback.off if @callback
  end

  def arguments
    `#@native.arguments || []`
  end

  def arguments=(args)
    `#@native.arguments = #{args}`
  end

  alias_native :bubbles?, :bubbles
  alias_native :cancelable?, :cancelable
  alias_native :name, :type
  alias_native :data
  alias_native :phase, :eventPhase
  alias_native :at, :timeStamp

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

end; end
