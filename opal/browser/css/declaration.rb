module Browser; module CSS

class Declaration
  include Native::Base
  include Enumerable

  def self.definitions
    @definitions ||= {}
  end

  def self.define(name, &block)
    definitions[name] = block
  end

  def self.for(name, *arguments)
    if definition = definitions[name]
      definition.call(*arguments)
    else
      argument, = *arguments

      if String === argument
        [[name, argument]]
      else
        argument.map {|sub, value|
          ["#{name}-#{sub}", value.to_s]
        }
      end
    end
  end

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

    def method_missing(name, *args)
      if name.end_with? ?!
        Declaration.for(name[0 .. -2], *args).each {|sub, value|
          `#@native.setProperty(#{sub}, #{value}, true)`
        }
      else
        Declaration.for(name, *args).each {|sub, value|
          `#@native.setProperty(#{sub}, #{value}, false)`
        }
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

  alias_native :length
  alias_native :to_s, :cssText
end

end; end
