module Browser; module CSS

class Declaration
  include Native::Base
  include Enumerable

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
    Definition.new(&block).each {|style|
      `#@native.setProperty(#{style.name}, #{style.value}, #{style.important?})`
    }

    self
  end

  def delete(name)
    `#@native.removeProperty(#{name})`
  end

  def [](name)
    %x{
      var result = #@native.getPropertyValue(#{name});

      if (result == null || result === "") {
        return nil;
      }

      return result;
    }
  end

  def []=(name, value)
    `#@native.setProperty(#{name}, #{value.to_s}, false)`
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
