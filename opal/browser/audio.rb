require 'browser/audio/node'

module Browser; module Audio

class Context
  include Native

  alias_native :destination
  alias_native :listener
  alias_native :state

  alias_native :sample_rate, :sampleRate
  alias_native :current_time, :currentTime

  def self.supported?
    ['AudioContext',
     'AudioContext (Safari)'].any? {|feature|
       Browser.supports? feature
     }
  end

  if Browser.supports? 'AudioContext'
    def initialize
      super `new AudioContext()`
    end
  elsif Browser.supports? 'AudioContext (Safari)'
    def initialize
      super `new webkitAudioContext()`
    end
  else
    def initialize
      raise NotImplementedError, 'AudioContext unsupported'
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

  alias_native :suspend
  alias_native :resume
  alias_native :close
end

end; end
