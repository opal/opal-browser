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

    result
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

    if arg.is_a? Hash
      arg.each {|sub, value|
        if name.end_with? ?!
          io << "\t#{name[0 .. -2]}-#{sub}: "
          io << value.to_s
          io << " !important;\n"
        else
          io << "\t#{name}-#{sub}: "
          io << value.to_s
          io << ";\n"
        end
      }
    else
      if name.end_with? ?!
        io << "\t#{name[0 .. -2]}: "
        io << arg.to_s
        io << " !important;\n"
      else
        io << "\t#{name}: "
        io << arg.to_s
        io << ";\n"
      end
    end
  end

  def to_s
    @output.reverse.map(&:string).join("\n\n")
  end
end

end; end
