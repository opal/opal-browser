require 'browser/dom/element/position'
require 'browser/dom/element/offset'
require 'browser/dom/element/scroll'

require 'browser/dom/element/input'
require 'browser/dom/element/image'

module Browser; module DOM

class Element < Node
  def self.create(*args)
    $document.create_element(*args)
  end

  def self.new(node)
    if self == Element
      name = `node.nodeName`.capitalize

      if Element.const_defined?(name)
        Element.const_get(name).new(node)
      else
        super
      end
    else
      super
    end
  end

  include Event::Target

  target {|value|
    DOM(value) rescue nil
  }

  alias_native :id

  def add_class(*names)
    classes = class_names + names

    unless classes.empty?
      `#@native.className = #{classes.uniq.join ' '}`
    end

    self
  end

  def remove_class(*names)
    classes = class_names - names

    if classes.empty?
      `#@native.removeAttribute('class')`
    else
      `#@native.className = #{classes.join ' '}`
    end

    self
  end

  alias_native :class_name, :className

  def class_names
    `#@native.className`.split(/\s+/).reject(&:empty?)
  end

  alias attribute attr

  def attribute_nodes
    Native::Array.new(`#@native.attributes`, get: :item) { |e| DOM(e) }
  end

  def attributes(options = {})
    Attributes.new(self, options)
  end

  def get(name, options = {})
    if namespace = options[:namespace]
      `#@native.getAttributeNS(#{namespace.to_s}, #{name.to_s}) || nil`
    else
      `#@native.getAttribute(#{name.to_s}) || nil`
    end
  end

  def set(name, value, options = {})
    if namespace = options[:namespace]
      `#@native.setAttributeNS(#{namespace.to_s}, #{name.to_s}, #{value})`
    else
      `#@native.setAttribute(#{name.to_s}, #{value.to_s})`
    end
  end

  alias [] get
  alias []= set

  alias attr get
  alias attribute get

  alias get_attribute get
  alias set_attribute set

  def key?(name)
    !!self[name]
  end

  def keys
    attributes_nodesmap(&:name)
  end

  def values
    attribute_nodes.map(&:value)
  end

  def remove_attribute(name)
    `#@native.removeAttribute(name)`
  end

  def size(*inc)
    Size.new(`#@native.offsetWidth`, `#@native.offsetHeight`)
  end

  def position
    Position.new(self)
  end

  def offset(*values)
    off = Offset.new(self)

    unless values.empty?
      off.set(*values)
    end

    off
  end

  def offset=(value)
    offset.set(*value)
  end

  def scroll
    Scroll.new(self)
  end

  def inner_dom(&block)
    # FIXME: when block passing is fixed
    doc = document
    clear; Builder.new(doc, self, &block)

    self
  end

  def inner_dom=(node)
    clear; self << node
  end

  def /(*paths)
    paths.map { |path| xpath(path) }.flatten.uniq
  end

  def at(path)
    xpath(path).first || css(path).first
  end

  def at_css(*rules)
    rules.each {|rule|
      found = css(rule).first

      return found if found
    }

    nil
  end

  def at_xpath(*paths)
    paths.each {|path|
      found = xpath(path).first

      return found if found
    }

    nil
  end

  def search(*selectors)
    NodeSet.new document, selectors.map {|selector|
      xpath(selector).to_a.concat(css(selector).to_a)
    }.flatten.uniq
  end

  # @abstract
  def css(selector)
    raise NotImplementedError, 'query by CSS selector unsupported'
  end

  # @abstract
  def xpath(path)
    raise NotImplementedError, 'query by XPath unsupported'
  end

  def style(data = nil, &block)
    style = CSS::Declaration.new(`#@native.style`)

    return style unless data || block

    if data.is_a?(String)
      style.replace(data)
    elsif data.is_a?(Enumerable)
      style.assign(data)
    end

    if block
      style.apply(&block)
    end

    self
  end

  # @abstract
  def style!
    raise NotImplementedError, 'computed style unsupported'
  end

  def data(what)
    if Hash === what
      unless defined?(`#@native.$data`)
        `#@native.$data = {}`
      end

      what.each {|name, value|
        `#@native.$data[name] = value`
      }
    else
      return self["data-#{what}"] if self["data-#{what}"]

      return unless defined?(`#@native.$data`)

      %x{
        var value = #@native.$data[what];

        if (value === undefined) {
          return nil;
        }
        else {
          return value;
        }
      }
    end
  end

  # @abstract
  def matches?(selector)
    raise NotImplementedError, 'selector matching unsupported'
  end

  def window
    document.window
  end

  def inspect
    "#<DOM::Element: #{name}>"
  end

  class Attributes
    include Enumerable

    attr_reader :namespace

    def initialize(element, options)
      @element   = element
      @namespace = options[:namespace]
    end

    def each(&block)
      return enum_for :each unless block_given?

      @element.attribute_nodes.each {|attr|
        yield attr.name, attr.value
      }

      self
    end

    def [](name)
      @element.get_attribute(name, namespace: @namespace)
    end

    def []=(name, value)
      @element.set_attribute(name, value, namespace: @namespace)
    end

    def merge!(hash)
      hash.each {|name, value|
        self[name] = value
      }

      self
    end
  end
end

end; end
