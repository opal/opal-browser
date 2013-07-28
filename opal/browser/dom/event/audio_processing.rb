module Browser; module DOM; class Event < Native

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

  def self.create(name, &block)
    new(`new AudioProcessingEvent(#{name}, #{Definition.new(&block)})`)
  end

  alias_native :time, :playbackTime
  alias_native :input, :inputBuffer
  alias_native :output, :outputBuffer
end

end; end; end
