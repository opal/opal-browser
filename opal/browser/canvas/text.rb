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

class Text
  attr_reader :context

  def initialize(context)
    @context = context
  end

  def measure(text)
    `#@native.measureText(text)`
  end

  def fill(text, x = nil, y = nil, max_width = undefined)
    x ||= 0
    y ||= 0

    `#@native.fillText(text, x, y, max_width)`

    @context
  end

  def stroke(text, x = nil, y = nil, max_width = undefined)
    x ||= 0
    y ||= 0

    `#@native.strokeText(text, x, y, max_width)`

    @context
  end
end

end; end
