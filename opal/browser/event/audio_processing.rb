# backtick_javascript: true

module Browser; class Event

class AudioProcessing < Event
  handles 'audioprocess'
  
  def self.supported?
    Browser.supports? 'Event.AudioProcessing'
  end

  class Definition < Definition
    alias_native :time=, :playbackTime=
    alias_native :input=, :inputBuffer=
    alias_native :output=, :outputBuffer=
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
