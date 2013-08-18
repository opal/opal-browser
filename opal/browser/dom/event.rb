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
  include Native::Base

  def self.names
    return @names if @names

    @names = Hash.new { |_, k| k }
    @names.merge!({
      load:  'DOMContentLoaded',
      hover: 'mouse:over'
    })
  end

  def self.name(name)
    names[name].gsub(?:, '')
  end

  def self.classes
    @classes ||= {
      Animation         => $$[:AnimationEvent],
      AudioProcessing   => $$[:AudioProcessingEvent],
      BeforeUnload      => $$[:BeforeUnloadEvent],
      Composition       => $$[:CompositionEvent],
      Clipboard         => $$[:ClipboardEvent],
      DeviceLight       => $$[:DeviceLightEvent],
      DeviceMotion      => $$[:DeviceMotionEvent],
      DeviceOrientation => $$[:DeviceOrientationEvent],
      DeviceProximity   => $$[:DeviceProximityEvent],
      Drag              => $$[:DragEvent],
      Gamepad           => $$[:GamepadEvent],
      HashChange        => $$[:HashChangeEvent],
      Progress          => $$[:ProgressEvent],
      PageTransition    => $$[:PageTransitionEvent],
      PopState          => $$[:PopStateEvent],
      Storage           => $$[:StorageEvent],
      Touch             => $$[:TouchEvent],
      Sensor            => $$[:SensorEvent],
      Mouse             => $$[:MouseEvent],
      Keyboard          => $$[:KeyboardEvent],
      Focus             => $$[:FocusEvent],
      Wheel             => $$[:WheelEvent],
      Event             => $$[:Event],
      Custom            => $$[:CustomEvent]
    }
  end

  def self.class_for(name)
    type = case name(name)
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

    if type != Event && type.supported?
      type
    else
      Event
    end
  end

  def self.create(name, *args, &block)
    name  = name(name)
    klass = class_for(name)

    event = if klass == self
      new(`new window.Event(#{name}, #{Definition.new(&block)})`)
    else
      klass.create(name, &block)
    end

    event.arguments = args

    event
  end

  def self.new(value, *args)
    klass, _ = classes.find {|_, constructor|
      constructor && `#{value} instanceof #{constructor.to_n}`
    }

    if !klass || klass == self
      super(value, *args)
    else
      klass.new(value, *args)
    end
  end

  attr_reader :target, :callback

  def initialize(native, callback = nil)
    super(native)

    @target    = Target.convert(`#@native.target`)
    @callback, = callback # TODO: change this when super is fixed
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
  alias_native :data, :data
  alias_native :phase, :eventPhase
  alias_native :at, :timeStamp

  def stopped?; !!@stopped; end

  def stop!
    `#@native.stopPropagation()` if defined?(`#@native.stopPropagation`)

    @stopped = true
  end
end

end; end
