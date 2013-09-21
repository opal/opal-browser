module Browser; module CSS

class Declaration
  include Native::Base
  include Enumerable

  class DSL
    include Native::Base

    def initialize(declaration, &block)
      @declaration = declaration

      if block.arity == 0
        instance_exec(&block)
      else
        block.call(self)
      end
    end

    def method_missing(name, arg)
      if arg.is_a? Hash
        arg.each {|sub, value|
          if name.end_with? ?!
            `#@native.setProperty(#{name[0 .. -2]} + "-" + #{sub}, #{value.to_s}, true)`
          else
            `#@native.setProperty(#{name} + "-" + #{sub}, #{value.to_s}, false)`
          end
        }
      else
        if name.end_with? ?!
          `#@native.setProperty(#{name[0 .. -2]}, #{arg.to_s}, true)`
        else
          `#@native.setProperty(#{name}, #{arg.to_s}, false)`
        end
      end
    end
  end

  def rule
    Rule.new(`#@native.parentRule`) if defined?(`#@native.parentRule`)
  end

  def assign(data)
    data.each {|name, value|
      self[name] = value
    }

    self
  end

  def replace(string)
    `#@native.cssText = #{string}`

    self
  end

  def apply(&block)
    DSL.new(@native, &block)

    self
  end

  def [](name)
    `#@native.getPropertyValue(#{name})`
  end

  def []=(name, value)
    `#@native.setProperty(#{name}, #{value}, false)`
  end

  def important?(name)
    `#@native.getPropertyPriority(#{name}) == "important"`
  end

  def each(&block)
    return enum_for :each unless block_given?

    %x{
      for (var i = 0, length = #@native.length; i < length; i++) {
        var name  = #@native.item(i);

        #{yield `name`, self[`name`]}
      }
    }

    self
  end

  alias_native :length, :length
  alias_native :to_s, :cssText
end

end; end
