module Browser; class Event

class AudioProcessing < Event
  def self.supported?
    Browser.supports? 'Event.AudioProcessing'
  end

  class Definition < Definition
    def time=(value)
      `#@native.playbackTime = #{value}`
    end

    def input=(value)
      `#@native.inputBuffer = #{value}`
    end

    def output=(value)
      `#@native.outputBuffer = #{value}`
    end
  end

  if Browser.supports? 'Event.constructor'
    def self.construct(name, desc)
      `new AudioProcessingEvent(#{name}, #{desc})`
    end
  end if supported?

  alias_native :time, :playbackTime
  alias_native :input, :inputBuffer
  alias_native :output, :outputBuffer
end

end; end
