module Browser; module CSS

class Definition
  class Unit
    attr_reader :type

    def initialize(number, type)
      @number = number
      @type   = type
    end

    def to_i
      @number.to_i
    end

    def to_f
      @number.to_f
    end

    def to_s
      "#{@number}#{@type}"
    end
  end

  Style = Struct.new(:name, :value, :important?)

  def initialize(&block)
    @style = []

    if block.arity == 0
      instance_exec(&block)
    else
      block.call(self)
    end if block
  end

  def each(&block)
    return enum_for :each unless block

    @style.each(&block)

    self
  end

  def method_missing(name, argument, &block)
    important = name.end_with? ?!
    name      = name[0 .. -2] if important

    if Hash === argument
      argument.each {|sub, value|
        @style << Style.new("#{name}-#{sub}", value.to_s, important)
      }
    else
      @style << Style.new(name, argument.to_s, important)
    end

    self
  end
end

end; end

class Numeric
  Unit = Browser::CSS::Definition::Unit

  def em
    Unit.new(self, :em)
  end

  def ex
    Unit.new(self, :ex)
  end

  def ch
    Unit.new(self, :ch)
  end

  def rem
    Unit.new(self, :rem)
  end

  def vh
    Unit.new(self, :vh)
  end

  def vw
    Unit.new(self, :vw)
  end

  def vmin
    Unit.new(self, :vmin)
  end

  def vmax
    Unit.new(self, :vmax)
  end

  def px
    Unit.new(self, :px)
  end

  def mm
    Unit.new(self, :mm)
  end

  def cm
    Unit.new(self, :cm)
  end

  def in
    Unit.new(self, :in)
  end

  def pt
    Unit.new(self, :pt)
  end

  def pc
    Unit.new(self, :pc)
  end
end

=begin
define :border do |args|
  return [['border', args]] if String === args

  args.map {|name, value|
    case name
    when :radius
      if String === value
        [['-moz-border-radius', value],
         ['-webkit-border-radius', value],
         ['border-radius', value]]
      else
        value.map {|horizontal, value|
          value.map {|vertical, value|
            [["-moz-border-radius-#{horizontal}#{vertical}", value],
             ["-webkit-border-#{horizontal}-#{vertical}-radius", value],
             ["border-#{horizontal}-#{vertical}-radius", value]]
          }.flatten(1)
        }.flatten(1)
      end

    else
      [["border-#{name}", value]]
    end
  }.flatten(1)
end

define :box do |args|
  return [['box', args]] if String === args

  args.map {|name, value|
    case name
    when :shadow
      if Array === value
        value = value.join ', '
      end

      if String === value
        [['-moz-box-shadow', value],
         ['-webkit-box-shadow', value],
         ['box-shadow', value]]
      else
      end

    else
      [["box-#{name}", value]]
    end
  }.flatten(1)
end

define :gradient do |type, *args|
  if Hash === args.last
    options = args.pop
  end

  result = []

  if fallback = options[:fallback]
    result << ['background-color', fallback]
  else
    result << ['backround-color', from]
  end

  result
end
=end
