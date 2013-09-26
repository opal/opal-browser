module Browser; module CSS

class Definition
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
        @style << Style.new("#{name}-#{sub}", value, important)
      }
    else
      @style << Style.new(name, argument, important)
    end

    self
  end
end

end; end

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
