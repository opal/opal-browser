# backtick_javascript: true
module Browser; module Audio

  class ParamSchedule
    include Native::Wrapper

    alias_native :cancel, :cancelScheduledValues

    def initialize(audio_param, time = nil)
      @time = time
      @audio_param = audio_param
      super Native.convert(audio_param)
    end

    def at(time)
      new(@audio_param, time)
    end

    def value(value, time = nil)
      @value = value
      `#@native.setValueAtTime(#{@value}, #{@time || time})`
      self
    end

    def linear_ramp_to(value = nil, time = nil)
      `#@native.linearRampToValueAtTime(#{@value || value}, #{@time || time})`
      self
    end

    def exponential_ramp_to(value = nil, time = nil)
      `#@native.exponentialRampToValueAtTime(#{@value || value}, #{@time || time})`
      self
    end

    def target(target, time_hash)
      `#@native.setTargetAtTime(target, #{time_hash[:start_time]}, #{time_hash[:time_constant]})`
    end

    def curve(values, time_hash)
      `#@native.setValueCurveAtTime(values, #{time_hash[:start_time]}, #{time_hash[:time_constant]})`
    end
  end

end; end
