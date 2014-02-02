require 'browser/dom/element/position'
require 'browser/dom/element/offset'
require 'browser/dom/element/scroll'
require 'browser/dom/element/size'

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

  if Browser.supports? 'Element.matches'
    def =~(selector)
      `#@native.matches(#{selector})`
    end
  elsif Browser.supports? 'Element.matches (Opera)'
    def =~(selector)
      `#@native.oMatchesSelector(#{selector})`
    end
  elsif Browser.supports? 'Element.matches (Internet Explorer)'
    def =~(selector)
      `#@native.msMatchesSelector(#{selector})`
    end
  elsif Browser.supports? 'Element.matches (Firefox)'
    def =~(selector)
      `#@native.mozMatchesSelector(#{selector})`
    end
  elsif Browser.supports? 'Element.matches (Chrome)'
    def =~(selector)
      `#@native.webkitMatchesSelector(#{selector})`
    end
  elsif Browser.loaded? 'Sizzle'
    def =~(selector)
      `Sizzle.matchesSelector(#@native, #{selector})`
    end
  else
    def =~(selector)
      raise NotImplementedError, 'selector matching unsupported'
    end
  end

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

  if Browser.supports? 'Element.className'
    def get(name, options = {})
      if name == :class
        name = :className
      end

      if namespace = options[:namespace]
        `#@native.getAttributeNS(#{namespace.to_s}, #{name.to_s}) || nil`
      else
        `#@native.getAttribute(#{name.to_s}) || nil`
      end
    end

    def set(name, value, options = {})
      if name == :class
        name = :className
      end

      if namespace = options[:namespace]
        `#@native.setAttributeNS(#{namespace.to_s}, #{name.to_s}, #{value})`
      else
        `#@native.setAttribute(#{name.to_s}, #{value.to_s})`
      end
    end
  else
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
    Size.new(self, *inc)
  end

  def height
    size.height
  end

  def height=(value)
    size.height = value
  end

  def width
    size.width
  end

  def width=(value)
    size.width = value
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

  alias_native :id

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
    NodeSet.new selectors.map {|selector|
      xpath(selector).to_a.concat(css(selector).to_a)
    }.flatten.uniq
  end

  if Browser.supports? 'Query.css'
    def css(path)
      NodeSet[Native::Array.new(`#@native.querySelectorAll(path)`)]
    rescue
      NodeSet[]
    end
  elsif Browser.loaded? 'Sizzle'
    def css(path)
      NodeSet[`Sizzle(path, #@native)`]
    rescue
      NodeSet[]
    end
  else
    def css(selector)
      raise NotImplementedError, 'query by CSS selector unsupported'
    end
  end

  if Browser.supports?('Query.xpath') || Browser.loaded?('wicked-good-xpath')
    if Browser.loaded? 'wicked-good-xpath'
      `wgxpath.install()`
    end

    def xpath(path)
      NodeSet[Native::Array.new(
        `(#@native.ownerDocument || #@native).evaluate(path,
           #@native, null, XPathResult.ORDERED_NODE_SNAPSHOT_TYPE, null)`,
        get:    :snapshotItem,
        length: :snapshotLength)]
    rescue
      NodeSet[]
    end
  else
    def xpath(path)
      raise NotImplementedError, 'query by XPath unsupported'
    end
  end

  def style(data = nil, &block)
    style = CSS::Declaration.new(`#@native.style`)

    return style unless data || block

    if data.is_a?(String)
      style.replace(data)
    elsif data.is_a?(Enumerable)
      style.assign(data)
    elsif block
      style.apply(&block)
    end

    self
  end

  if Browser.supports? 'CSS.computed'
    def style!
      CSS::Declaration.new(`#{window.to_n}.getComputedStyle(#@native, null)`)
    end
  elsif Browser.supports? 'CSS.current'
    def style!
      CSS::Declaration.new(`#@native.currentStyle`)
    end
  else
    def style!
      raise NotImplementedError, 'computed style unsupported'
    end
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
