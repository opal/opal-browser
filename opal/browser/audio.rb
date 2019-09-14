require 'browser/audio/node'

module Browser; module Audio

class Context
  include Native::Wrapper

  alias_native :destination
  alias_native :listener
  alias_native :state

  alias_native :sample_rate, :sampleRate
  alias_native :current_time, :currentTime

  def self.supported?
    Browser.support?('Audio') || Browser.support?('Audio (Chrome)')
  end

  if Browser.supports? 'Audio'
    def initialize
      super `new AudioContext()`
    end
  elsif Browser.supports? 'Audio (Chrome)'
    def initialize
      super `new webkitAudioContext()`
    end
  else
    def initialize
      raise NotImplementedError, 'Audio unsupported'
    end
  end

  def gain
    Node::Gain.new(self)
  end

  def oscillator
    Node::Oscillator.new(self)
  end

  def delay(max_time)
    Node::Delay.new(self, max_time)
  end

  def dynamics_compressor
    Node::DynamicsCompressor.new(self)
  end

  def biquad_filter
    Node::BiquadFilter.new(self)
  end

  def stereo_panner
    Node::StereoPanner.new(self)
  end

  def periodic_wave(real, imaginary)
    `#{@native}.createPeriodicWave(new Float32Array(#{real}), new Float32Array(#{imaginary}));`
  end

  alias_native :suspend
  alias_native :resume
  alias_native :close
end

end; end
