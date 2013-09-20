require 'stringio'

module Browser; module CSS

class Builder
  def initialize(&block)
    @io = StringIO.new

    if block.arity == 0
      instance_exec(&block)
    else
      block.call(self)
    end
  end

  def rule(name, &block)
    @io << "#{name} {\n"

    if block.arity == 0
      instance_exec(&block)
    else
      block.call(self)
    end

    @io << "}\n\n"
  end

  def method_missing(name, arg)
    if arg.is_a? Hash
      arg.each {|sub, value|
        if name.end_with? ?!
          @io << "\t#{name[0 .. -2]}-#{sub}: "
          @io << value.to_str
          @io << " !important;\n"
        else
          @io << "\t#{name}-#{sub}: "
          @io << value.to_str
          @io << ";\n"
        end
      }
    else
      if name.end_with? ?!
        @io << "\t#{name[0 .. -2]}: "
        @io << arg.to_str
        @io << " !important;\n"
      else
        @io << "\t#{name}: "
        @io << arg.to_str
        @io << ";\n"
      end
    end
  end

  def to_s
    @io.string
  end
end

end; end
