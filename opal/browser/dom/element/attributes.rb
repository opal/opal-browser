module Browser; module DOM; class Element < Node

class Attributes
  @@normalize = `{}`

  if Browser.supports? 'Element.className'
    `#@@normalize['class'] = 'className'`
  end

  if Browser.supports? 'Element.htmlFor'
    `#@@normalize['for'] = 'htmlFor'`
  end

  attr_reader :namespace

  def initialize(element, options)
    @element   = element
    @native    = element.to_n
    @namespace = options[:namespace]
  end

  def [](name, options = {})
    name = `#@@normalize[name] || name`

    if namespace = options[:namespace] || @namespace
      `#@native.getAttributeNS(#{namespace.to_s}, #{name.to_s}) || nil`
    else
      `#@native.getAttribute(#{name.to_s}) || nil`
    end
  end

  def []=(name, value, options = {})
    name = `#@@normalize[name] || name`

    if namespace = options[:namespace] || @namespace
      `#@native.setAttributeNS(#{namespace.to_s}, #{name.to_s}, #{value})`
    else
      `#@native.setAttribute(#{name.to_s}, #{value.to_s})`
    end
  end

  include Enumerable

  def each(&block)
    return enum_for :each unless block_given?

    @element.attribute_nodes.each {|attr|
      yield attr.name, attr.value
    }

    self
  end

  alias get []

  def has_key?(name)
    !!self[name]
  end

  def merge!(hash)
    hash.each {|name, value|
      self[name] = value
    }

    self
  end

  alias set []
end

end; end; end
