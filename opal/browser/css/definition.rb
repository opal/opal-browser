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

  def gradient(*args)
    Gradient.new(*args)
  end

  def background(*args); _background(false, *args); end
  def background!(*args); _background(true, *args); end

  def _background(important, *args)
    if Gradient === args.first
      if args.length > 1
        raise NotImplementedError, "multiple gradients not implemented yet"
      end

      args.first.each {|s|
        style s.name || 'background-image', s.value, important
      }
    else
      options = args.first

      if String === options
        style :background, options, important
      else
        argument.each {|sub, value|
          style "background-#{sub}", value, important
        }
      end
    end
  end

  def border(options)
    if Hash === options
      options.each {|name, value|
        case name
        when :radius
          if String === value
            style '-moz-border-radius', value
            style '-webkit-border-radius', value
            style 'border-radius', value
          else
            value.each {|horizontal, value|
              value.each {|vertical, value|
                style "-moz-border-radius-#{horizontal}#{vertical}", value
                style "-webkit-border-#{horizontal}-#{vertical}-radius", value
                style "border-#{horizontal}-#{vertical}-radius", value
              }
            }
          end

        when :color
          if String === value
            style 'border-color', value
          else
            value.each {|name, value|
              style "border-#{name}-color", value
            }
          end

        else
          style "border-#{name}", Array(value).join(' ')
        end
      }
    else
      style :border, Array(options).join(' ')
    end
  end

  def box(options)
    if Hash === options
      options.each {|name, value|
        case name
        when :shadow
          if Array === value
            value = value.join ', '
          end

          style '-moz-box-shadow', value
          style '-webkit-box-shadow', value
          style 'box-shadow', value

        else
          style "box-#{name}", value
        end
      }
    else
      style :box, options
    end
  end

  def opacity(value)
    style 'opacity', value
    style '-moz-opacity', value

    style '-ms-filter', %Q{"progid:DXImageTransform.Microsoft.Alpha(Opacity=#{(value * 100).to_i})"}
    style 'filter', "alpha(opacity=#{(value * 100).to_i})"
  end

  def method_missing(name, *args, &block)
    important = name.end_with? ?!
    name      = name[0 .. -2] if important

    @important = true if important

    if important && respond_to?(name)
      __send__ name, *args, &block
      @important = false

      return
    end

    if args.length == 1
      argument = args.first

      if Hash === argument
        argument.each {|sub, value|
          style "#{name}-#{sub}", Array(value).join(' ')
        }
      else
        style name, Array(argument).join(' ')
      end
    else
      style name, args.join(' ')
    end

    @important = false

    self
  end

private
  def style(name, value = nil, important = @important)
    if Style === name
      @style << name
    else
      @style << Style.new(name, value, important)
    end
  end

  class Gradient
    # TODO: all of it, seriously
    def initialize(*args)
      options = Hash === args.last ? args.pop : {}

      @to   = options[:to]
      @from = options[:from]

      if @to && !@from
        @from = other(@to)
      elsif @from && !@to
        @to = other(@from)
      end

      @start = args.shift
      @end   = args.shift
    end

    def each(&block)
      block.call style("-moz-linear-gradient(#@to, #@start 0%, #@end 100%)")

      if horizontal?
        block.call style("-webkit-gradient(linear, #@from top, #@to top, color-stop(0%, #@start), color-stop(100%, #@end))")
      else
        block.call style("-webkit-gradient(linear, left #@from, left #@to, color-stop(0%, #@start), color-stop(100%, #@end))")
      end

      block.call style("-webkit-linear-gradient(#@to, #@start 0%, #@end 100%)")
      block.call style("-o-linear-gradient(#@to, #@start 0%, #@end 100%)")
      block.call style("-ms-linear-gradient(#@to, #@start 0%, #@end 100%)")
      block.call style("linear-gradient(to #@to, #@start 0%, #@end 100%)")
    end

    def horizontal?
      @to == :left || @to == :right
    end

    def vertical?
      @to == :top || @to == :bottom
    end

  private
    def other(side)
      case side
      when :left   then :right
      when :right  then :left
      when :top    then :bottom
      when :bottom then :top
      end
    end

    # FIXME: use default args
    def style(*args)
      if args.length == 1
        Style.new(nil, args.first)
      else
        Style.new(*args)
      end
    end
  end
end

end; end
