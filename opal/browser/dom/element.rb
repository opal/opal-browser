module Browser; module DOM

class Element < Node
  def self.create(*args)
    $document.create_element(*args)
  end

  include Event::Target

  target {|value|
    # TODO: oneline rescue

    begin
      DOM(value)
    rescue
      nil
    end
  }

  alias_native :id

  def add_class(name)
    `#@native.className = #{class_names.push(name).uniq.join ' '}`

    self
  end

  def remove_class(name)
    names = class_names
    names.delete(name)

    `#@native.className = #{names.join ' '}`
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

  def each(options = {}, &block)
    return enum_for :each, options unless block

    attributes(options).each(&block)
  end

  def remove_attribute(name)
    `#@native.removeAttribute(name)`
  end

  Size     = Struct.new(:width, :height)
  Position = Struct.new(:x, :y, :parent)

  def size
    Size.new(`#@native.clientWidth`, `#@native.clientHeight`)
  end

  def position
    offset        = self.offset
    parent        = offset.parent
    parent_offset = Position.new(0, 0)

    if style[:position] == :fixed
      unless parent =~ :html
        parent_offset = parent.offset
      end

      parent_offset.y += parent.style['border-top-width'] || 0
      parent_offset.x += parent.style['border-left-width'] || 0
    end

    Position.new(offset.x - parent_offset.x - style['margin-left'] || 0,
                 offset.y - parent_offset.y - style['margin-top'] || 0,
                 parent)
  end

  def offset
    doc  = document
    root = doc.root.to_n
    win  = doc.window.to_n

    %x{
      var box = #@native.getBoundingClientRect(),
          y   = box.top + (#{win}.pageYOffset || #{root}.scrollTop) - (#{root}.clientTop || 0),
          x   = box.left + (#{win}.pageXOffset || #{root}.scrollLeft) - (#{root}.clientLeft || 0);
    }

    Position.new(`x`, `y`, DOM(`#@native.offsetParent || #{root}`))
  end

  def scroll(to = nil)
    if to
      if x = to[:x]
        `#@native.scrollLeft = #{x}`
      end

      if y = to[:y]
        `#@native.scrollTop = #{y}`
      end
    else
      Position.new(`#@native.scrollLeft`, `#@native.scrollTop`)
    end
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

  def css(path)
    NodeSet.new(document, Native::Array.new(`#@native.querySelectorAll(path)`))
  end

  def xpath(path)
    result = []

    begin
      %x{
        var tmp = (#@native.ownerDocument || #@native).evaluate(
          path, #@native, null, XPathResult.ORDERED_NODE_SNAPSHOT_TYPE, null);

        result = #{Native::Array.new(`tmp`, get: :snapshotItem, length: :snapshotLength)};
      }
    rescue; end

    NodeSet.new(document, result)
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

  def style!
    CSS::Declaration.new(`#{window.to_n}.getComputedStyle(#@native, null)`)
  end

  def matches?(selector)
    `#@native.matches(#{selector})`
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
