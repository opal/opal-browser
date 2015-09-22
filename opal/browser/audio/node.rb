module Browser; module Audio; module Node;

module Pluggable
  def connect(other_node)
    `#@native.connect(#{Native.convert(other_node)})`
  end

  def disconnect(other_node, options = {})
    other_node = Native.try_convert(other_node)
    output     = options[:output] || 0
    input      = options[:input]  || 0

    if options
      `#@native.disconnect(#{other_node}, #{output}, #{input}) || nil`
    elsif other_node
      `#@native.disconnect(#{other_node})`
    else
      `#@native.disconnect()`
    end
  end
end

class Gain
  include Native
  include Pluggable

  alias_native :value, :gain

  def initialize(audio_context)
    super `#{audio_context.to_n}.createGain()`
  end
end

class Oscillator
  TYPES = %i(sine square sawtooth triangle custom)

  include Native
  include Pluggable

  alias_native :start
  alias_native :stop

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

  def frequency=(frequency)
    `#@native.frequency.value = frequency`
  end

  def frequency
    `#@native.frequency.value`
  end

  def detune=(detune)
    `#@native.detune.value = detune`
  end

  def detune
    `#@native.detune.value`
  end
end

class Delay
  include Native
  include Pluggable

  def initialize(audio_context, max_time)
    super `#{audio_context.to_n}.createDelay(max_time || 1)`
  end

  def time=(time)
    `#@native.time.value = time`
  end

  def time
    `#@native.time.value`
  end
end

class DynamicsCompressor
  include Native
  include Pluggable

  alias_native :reduction

  def treshold=(treshold)
    `#@native.treshold.value = treshold`
  end

  def treshold
    `#@native.treshold.value`
  end

  def knee=(knee)
    `#@native.knee.value = knee`
  end

  def knee
    `#@native.knee.value`
  end

  def ratio=(ratio)
    `#@native.ratio.value = ratio`
  end

  def ratio
    `#@native.ratio.value`
  end

  def attack=(attack)
    `#@native.attack.value = attack`
  end

  def attack
    `#@native.attack.value`
  end

  def release=(release)
    `#@native.release.value = release`
  end

  def release
    `#@native.release.value`
  end
end

class BiquadFilter
  include Native
  include Pluggable

  def initialize(audio_context)
    super `#{audio_context.to_n}.createBiquadFilter()`
  end

  def detune=(detune)
    `#@native.detune.value = #{@detune = detune}`
  end

  def q=(q)
    `#@native.q.value = q`
  end

  def q
    `#@native.q.value`
  end

  def gain=(gain)
    `#@native.gain.value = gain`
  end

  def gain
    `#@native.gain.value`
  end
end

class StereoPanner
  include Native
  include Pluggable

  def initialize(audio_context)
    super `#{audio_context.to_n}.createStereoPanner()`
  end

  def pan=(pan)
    `#@native.pan.value = pan`
  end

  def pan
    `#@native.pan.value`
  end
end

end; end; end
