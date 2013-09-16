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

  def method_missing(id, *args)
    if id.ends_with? '!'
      `#@native.setProperty(#{id[0 .. -2]}, #{args.first}, true)`

      self
    elsif id.ends_with? '='
      `#@native.setProperty(#{id[0 .. -2]}, #{args.first}, false)`

      self
    else
      `#@native.getPropertyValue(#{id})`
    end
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
