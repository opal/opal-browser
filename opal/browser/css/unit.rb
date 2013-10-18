module Browser; module CSS

class Unit
  COMPATIBLE = %i[in pt mm cm px pc]

  attr_reader :type

  def initialize(number, type)
    @number = number
    @type   = type
  end

  def coerce(other)
    return self, other
  end

  def ==(other)
    @number == convert(other, @type)
  end

  def ===(other)
    @type == other.type && @number == other.to_f
  end

  alias eql? ==

  def hash
    [@number, @type].hash
  end

  %i[em ex ch rem vh vw vmin vmax px mm cm in pt pc].each {|name|
    define_method name do
      Unit.new(convert(self, name), name)
    end
  }

  def +(other)
    return Unit.new(@number + other, @type) unless Unit === other

    if @type == other.type
      Unit.new(@number + other.to_f, @type)
    elsif compatible?(self) and compatible?(other)
      Unit.new(@number + convert(other, @type), @type)
    else
      raise ArgumentError, "#{other.type} isn't compatible with #{@type}"
    end
  end

  def -(other)
    return Unit.new(@number - other, @type) unless Unit === other

    if @type == other.type
      Unit.new(@number - other.to_f, @type)
    elsif compatible?(self) and compatible?(other)
      Unit.new(@number - convert(other, @type), @type)
    else
      raise ArgumentError, "#{other.type} isn't compatible with #{@type}"
    end
  end

  def *(other)
    return Unit.new(@number * other, @type) unless Unit === other

    if @type == other.type
      Unit.new(@number * other.to_f, @type)
    elsif compatible?(self) and compatible?(other)
      Unit.new(@number * convert(other, @type), @type)
    else
      raise ArgumentError, "#{other.type} isn't compatible with #{@type}"
    end
  end

  def /(other)
    return Unit.new(@number / other, @type) unless Unit === other

    if @type == other.type
      Unit.new(@number / other.to_f, @type)
    elsif compatible?(self) and compatible?(other)
      Unit.new(@number / convert(other, @type), @type)
    else
      raise ArgumentError, "#{other.type} isn't compatible with #{@type}"
    end
  end

  def -@
    Unit.new(@number * -1, @type)
  end

  def +@
    Unit.new(@number, @type)
  end

  def to_i
    @number.to_i
  end

  def to_f
    @number.to_f
  end

  def to_u
    self
  end

  def to_s
    "#{@number}#{@type}"
  end

  alias to_str to_s
  alias inspect to_s

private
  def compatible?(unit)
    COMPATIBLE.include?(unit.type)
  end

  def convert(unit, type)
    value = unit.to_f

    return value if unit.type == type

    px = case unit.type
    when :in then value * 96
    when :pt then value * 4.0 / 3.0
    when :pc then value / 12 * 4.0 / 3.0
    when :mm then value * 3.77953
    when :cm then value * 10 * 3.77953
    when :px then value
    end

    case type
    when :in then px / 96.0
    when :pt then px / 4.0 / 3.0
    when :pc then px * 12 / 4.0 / 3.0
    when :mm then px / 3.77953
    when :cm then px / 10 / 3.77953
    when :px then px
    end
  end
end

end; end

class Numeric
  Unit = Browser::CSS::Unit

  %i[em ex ch rem vh vw vmin vmax px mm cm in pt pc].each {|name|
    define_method name do
      Unit.new(self, name)
    end
  }

  alias old_percent %

  def %(other = nil)
    if other
      old_percent(other)
    else
      Unit.new(self, :%)
    end
  end

  def to_u
    self
  end
end

class String
  def to_u
    if matches = self.match(/^([\d+.]+)(.+)?$/)
      value = matches[1].to_f

      if unit = matches[2]
        value.__send__(unit.downcase)
      else
        value
      end
    else
      0
    end
  end
end

class NilClass
  def to_u
    0
  end
end
