# backtick_javascript: true

module Browser; module DOM; class Element < Node

class Attributes
  attr_reader :namespace

  def initialize(element, options)
    @element   = element
    @native    = element.to_n
    @namespace = options[:namespace]
  end

  if Browser.supports?('Element.className') || Browser.supports?('Element.htmlFor')
    def [](name, options = {})
      if name == :class && Browser.supports?('Element.className')
        name = :className
      elsif name == :for && Browser.supports?('Element.htmlFor')
        name = :htmlFor
      end

      if namespace = options[:namespace] || @namespace
        `#@native.getAttributeNS(#{namespace.to_s}, #{name.to_s}) || nil`
      else
        `#@native.getAttribute(#{name.to_s}) || nil`
      end
    end

    def []=(name, value, options = {})
      if name == :class && Browser.supports?('Element.className')
        name = :className
      elsif name == :for && Browser.supports?('Element.htmlFor')
        name = :htmlFor
      end

      if namespace = options[:namespace] || @namespace
        if value
          `#@native.setAttributeNS(#{namespace.to_s}, #{name.to_s}, #{value})`
        else
          `#@native.removeAttributeNS(#{namespace.to_s}, #{name.to_s})`
        end
      else
        if value
          `#@native.setAttribute(#{name.to_s}, #{value.to_s})`
        else
          `#@native.removeAttribute(#{name.to_s})`
        end
      end
    end
  else
    def [](name, options = {})
      if namespace = options[:namespace] || @namespace
        `#@native.getAttributeNS(#{namespace.to_s}, #{name.to_s}) || nil`
      else
        `#@native.getAttribute(#{name.to_s}) || nil`
      end
    end

    def []=(name, value, options = {})
      if namespace = options[:namespace] || @namespace
        if value
          `#@native.setAttributeNS(#{namespace.to_s}, #{name.to_s}, #{value})`
        else
          `#@native.removeAttributeNS(#{namespace.to_s}, #{name.to_s})`
        end
      else
        if value
          `#@native.setAttribute(#{name.to_s}, #{value.to_s})`
        else
          `#@native.removeAttribute(#{name.to_s})`
        end
      end
    end
  end

  # Deletes an attribute with a given name
  # @return [String] an attribute value before deletion
  def delete(name)
    attr = self[name]
    self[name] = nil
    attr
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

  alias set []=
end

end; end; end
