require 'stringio'

module Browser; module CSS

class Builder
  # TODO: fix usage of commas
  def self.selector(list)
    result = ''

    list.each {|part|
      if part.start_with?('&')
        result += part[1 .. -1]
      else
        result += " " + part
      end
    }

    if result[0] == " "
      result[1 .. -1]
    else
      result
    end
  end

  def initialize(&block)
    @output   = []
    @selector = []
    @io       = []

    if block.arity == 0
      instance_exec(&block)
    else
      block.call(self)
    end
  end

  def rule(name, &block)
    io = StringIO.new

    @selector.push(name)
    @io.push(io)

    io << "#{Builder.selector(@selector)} {\n"
    if block.arity == 0
      instance_exec(&block)
    else
      block.call(self)
    end
    io << "}"

    @selector.pop
    @output << @io.pop
  end

  def method_missing(name, arg)
    io = @io.last

    if name.end_with? ?!
      Declaration.for(name[0 .. -2], arg).each {|sub, value|
        io << "\t#{sub}: #{value} !important;\n"
      }
    else
      Declaration.for(name, arg).each {|sub, value|
        io << "\t#{sub}: #{value};\n"
      }
    end
  end

  def to_s
    @output.reverse.map(&:string).join("\n\n")
  end
end

end; end
