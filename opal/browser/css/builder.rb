require 'stringio'

module Browser; module CSS

class Builder
  Rule = Struct.new(:selector, :definition)

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
    @selector = []
    @current  = []
    @rules    = []

    if block.arity == 0
      instance_exec(&block)
    else
      block.call(self)
    end
  end

  def rule(*names, &block)
    if names.any? { |n| n.include? ',' }
      raise ArgumentError, 'selectors cannot contain commas'
    end

    names.each {|name|
      @selector << name
      @current  << Rule.new(Builder.selector(@selector), Definition.new)

      block.call(self)

      @selector.pop
      @rules << @current.pop
    }
  end

  def method_missing(name, *args, &block)
    @current.last.definition.__send__(name, *args, &block)
  end

  def to_s
    io = StringIO.new

    @rules.reverse.each {|rule|
      next if rule.definition.empty?

      io << "#{rule.selector} {\n"
      rule.definition.each {|style|
        if style.important?
          io << "\t#{style.name}: #{style.value} !important;\n"
        else
          io << "\t#{style.name}: #{style.value};\n"
        end
      }
      io << "}\n\n"
    }

    io.string
  end
end

end; end
