# backtick_javascript: true
module Browser; module Audio; module Node

class Base
  include Native::Wrapper

  def initialize(native)
    @native = native
  end

  def method_missing(name, value = nil)
    if name.end_with? '='
      `#@native[#{name.delete '='}].value = value`
    elsif value.nil? || value == true
      `#@native[#{name}].value`
    elsif value == false
      `#@native[#{name}]`
    else
      super
    end
  end

  def respond_to_missing?(method, include_all = false)
    `#@native[#{method.delete('=')}] != null`
  end

  def connect(destination)
    `#@native.connect(#{Native.convert(destination)})`
  end

  def disconnect(destination = nil, options = {})
    destination = Native.try_convert(destination)
    output      = options[:output] || 0
    input       = options[:input]  || 0

    if options.any?
      `#@native.disconnect(#{destination}, #{output}, #{input}) || nil`
    elsif destination
      `#@native.disconnect(#{destination})`
    else
      `#@native.disconnect()`
    end
  end
end

class Gain < Base
  def initialize(audio_context)
    super `#{audio_context.to_n}.createGain()`
  end
end

class Oscillator < Base
  TYPES = %i(sine square sawtooth triangle custom)

  alias_native :start
  alias_native :stop

  alias_native :periodic_wave=, :setPeriodicWave

  def initialize(audio_context)
    super `#{audio_context.to_n}.createOscillator()`
  end

  def type=(type)
    unless TYPES.include?(type)
      raise ArgumentError, "type #{type} doesn't exists"
    end

    `#@native.type =  type`
  end

  def type
    `#@native.type`
  end
end

class Delay < Base
  def initialize(audio_context, max_time = 1)
    super `#{audio_context.to_n}.createDelay(max_time)`
  end
end

class DynamicsCompressor < Base

  alias_native :reduction

  def initialize(audio_context)
    super `#{audio_context.to_n}.createDynamicsCompressor()`
  end
end

class BiquadFilter < Base

  TYPES = %i(lowpass highpass bandpass lowshelf highshelf peaking notch allpass)

  def initialize(audio_context)
    super `#{audio_context.to_n}.createBiquadFilter()`
  end

  def type=(type)
    unless TYPES.include?(type)
      raise ArgumentError, "type #{type} doesn't exists"
    end

    `#@native.type =  type`
  end

  def type
    `#@native.type`
  end
end

class StereoPanner < Base

  alias_native :normalize

  def initialize(audio_context)
    super `#{audio_context.to_n}.createStereoPanner()`
  end
end

end; end; end
