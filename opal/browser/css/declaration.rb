module Browser; module CSS

class Declaration
  include Native
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
  end

  def apply(&block)
    Paggio::CSS::Definition.new(&block).each {|style|
      if style.important
        `#@native.setProperty(#{style.name}, #{style.value}, "important")`
      else
        `#@native.setProperty(#{style.name}, #{style.value}, "")`
      end
    }
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
    `#@native.setProperty(#{name}, #{value.to_s}, "")`
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

  def method_missing(name, value = nil)
    if name.end_with? ?=
      self[name[0 .. -2]] = value
    else
      self[name]
    end
  end
end

end; end
