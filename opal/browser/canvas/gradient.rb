#--
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.
#++

module Browser; class Canvas

class Gradient
  include Native

  attr_reader :context

  def initialize(context, *args, &block)
    @context = context

    super(case args.length
      when 4 then `#{@context.to_n}.createLinearGradient.apply(self, args)`
      when 6 then `#{@context.to_n}.createRadialGradient.apply(self, args)`
      else raise ArgumentError, "don't know where to dispatch"
    end)

    instance_eval(&block)
  end

  def add(position, color)
    `#{@context.to_n}.addColorStop(position, color)`

    self
  end
end

end; end
