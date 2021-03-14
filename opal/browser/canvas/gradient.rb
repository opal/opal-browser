module Browser; class Canvas

class Gradient
  include Native::Wrapper

  attr_reader :context

  def initialize(context, *args, &block)
    @context = context

    _this = @context.to_n

    *args, stops = args if args.length.odd?

    super case args.length
          when 4 then `_this.createLinearGradient.apply(_this, args)`
          when 6 then `_this.createRadialGradient.apply(_this, args)`
          else raise ArgumentError,
                     'Gradients must be created with 4 or 6 parameters'
          end
    add_stops(stops)
    instance_eval(&block) if block_given?
  end

  def add(position, color)
    `#{to_n}.addColorStop(position, color)`
    self
  end

  alias add_stop add
  alias add_color_stop add

  def add_stops(stops)
    stops&.each { |position, color| add_stop(position, color) }
    self
  end
end

end; end
