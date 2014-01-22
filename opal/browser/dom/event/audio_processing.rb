module Browser; module DOM; class Event

class AudioProcessing < Event
  def self.supported?
    not $$[:AudioProcessingEvent].nil?
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

  def self.construct(name, desc)
    `new AudioProcessingEvent(#{name}, #{desc})`
  end

  alias_native :time, :playbackTime
  alias_native :input, :inputBuffer
  alias_native :output, :outputBuffer
end

end; end; end
