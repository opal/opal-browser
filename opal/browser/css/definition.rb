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

  def border(*args); _border(false, *args); end
  def border!(*args); _border(true, *args); end

  def _border(important, options)
    if Hash === options
      options.each {|name, value|
        case name
        when :radius
          if String === value
            style('-moz-border-radius', value, important)
            style('-webkit-border-radius', value, important)
            style('border-radius', value, important)
          else
            value.map {|horizontal, value|
              value.map {|vertical, value|
                style("-moz-border-radius-#{horizontal}#{vertical}", value, important)
                style("-webkit-border-#{horizontal}-#{vertical}-radius", value, important)
                style("border-#{horizontal}-#{vertical}-radius", value, important)
              }
            }
          end

        else
          style("border-#{name}", value, important)
        end
      }
    else
      style(:border, options, important)
    end
  end

  def box(*args); _box(false, *args); end
  def box!(*args); _box(true, *args); end

  def _box(important, options)
    if Hash === options
      options.each {|name, value|
        case name
        when :shadow
          if Array === value
            value = value.join ', '
          end

          style('-moz-box-shadow', value, important)
          style('-webkit-box-shadow', value, important)
          style('box-shadow', value, important)

        else
          style("box-#{name}", value, important)
        end
      }
    else
      style(:box, options, important)
    end
  end

  def method_missing(name, argument, &block)
    important = name.end_with? ?!
    name      = name[0 .. -2] if important

    if Hash === argument
      argument.each {|sub, value|
        style("#{name}-#{sub}", value, important)
      }
    else
      style(name, argument, important)
    end

    self
  end

private
  def style(name, value, important = false)
    @style << Style.new(name, value, important)
  end
end

end; end
