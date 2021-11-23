# Requires are moved to the bottom of this file.

module Browser; module DOM

class Element < Node
  def self.create(*args, &block)
    if Document === args.first
      document = args.shift
    else
      document = $document
    end

    if self == Element
      document.create_element(*args, &block)
    elsif @tag_name
      document.create_element(@tag_name, *args, &block)
    elsif @selector
      # That's crude, but should cover the most basic cases.
      # Just in case, you can override it safely. To reiterate:
      # .create is not to be used inside libraries, those are
      # expected to use the Document#create_element API.
      kwargs = {}
      kwargs = args.pop if Hash === args.last
      custom_attrs, custom_id, custom_classes = nil, nil, nil
      tag_name = (@selector.scan(/^[\w-]+/).first || "div").upcase
      classes = @selector.scan(/\.([\w-]+)/).flatten
      classes |= custom_classes if custom_classes = kwargs.delete(:classes)
      id = @selector.scan(/#([\w-]+)/).flatten.first
      id = custom_id if custom_id = kwargs.delete(:id)
      attrs = @selector.scan(/\[([\w-]+)=((["'])(.*?)\3|[\w_-]*)\]/).map { |a,b,_,d| [a,d||b] }.to_h
      attrs = attrs.merge(custom_attrs) if custom_attrs = kwargs.delete(:attrs)
      document.create_element(tag_name, *args, classes: classes, id: id, attrs: attrs, **kwargs, &block)
    else
      raise NotImplementedError
    end
  end

  def self.subclasses
    @subclasses ||= []
  end

  # Define a selector for subclass dispatch
  #
  # Example:
  # ```
  # class CustomElement < Browser::DOM::Element
  #   def_selector "div.hello-world"
  # end
  # ```
  def self.def_selector(selector)
    Element.subclasses << self

    @selector = selector

    # A special case to speedup dispatch
    @tag_name = selector.upcase unless selector =~ /[^\w-]/
  end

  def self.selector
    @selector
  end

  def self.tag_name
    @tag_name
  end

  def self.new(*args, &block)
    if args.length == 1 && !block_given? && Opal.native?(args[0])
      # Use `.new` as a wrapping method.
      node = args[0]
    else
      # Use `.new` as an alias for `.create`.
      return create(*args, &block)
    end

    if self == Element
      subclass = Element.subclasses.select do |subclass|
        Element.native_is?(node, subclass)
      end.last

      if subclass
        subclass.new(node)
      else
        super(node)
      end
    else
      super(node)
    end
  end

  include Event::Target

  target {|value|
    begin
      DOM(value)
    rescue StandardError, JS::Error
      nil
    end
  }

  def self.native_is? (native, klass)
    if tag_name = klass.tag_name
      is = `(#{native}.getAttribute("is") || "")`
      `#{tag_name} === #{is}.toUpperCase() || #{tag_name} === #{native}.nodeName`
    else
      Element.native_matches?(native, klass.selector)
    end
  end

  if Browser.supports? 'Element.matches'
    def self.native_matches? (native, selector)
      `#{native}.matches(#{selector})`
    end
  elsif Browser.supports? 'Element.matches (Opera)'
    def self.native_matches? (native, selector)
      `#{native}.oMatchesSelector(#{selector})`
    end
  elsif Browser.supports? 'Element.matches (Internet Explorer)'
    def self.native_matches? (native, selector)
      `#{native}.msMatchesSelector(#{selector})`
    end
  elsif Browser.supports? 'Element.matches (Firefox)'
    def self.native_matches? (native, selector)
      `#{native}.mozMatchesSelector(#{selector})`
    end
  elsif Browser.supports? 'Element.matches (Chrome)'
    def self.native_matches? (native, selector)
      `#{native}.webkitMatchesSelector(#{selector})`
    end
  elsif Browser.loaded? 'Sizzle'
    def self.native_matches? (native, selector)
      `Sizzle.matchesSelector(#{native}, #{selector})`
    end
  else
    def self.native_matches? (native, selector)
      raise NotImplementedError, 'selector matching unsupported'
    end
  end

  # Check whether the element matches the given selector.
  #
  # @param selector [String] the CSS selector
  def =~(selector)
    Element.native_matches?(@native, selector)
  end

  # Allow for case expressions
  alias === =~

  # Query for children with the given XPpaths.
  #
  # @param paths [Array<String>] the XPaths to look for
  #
  # @return [NodeSet]
  def /(*paths)
    NodeSet[paths.map { |path| xpath(path) }]
  end

  # Get the attribute with the given name.
  #
  # @param name [String] the attribute name
  # @param options [Hash] options for the attribute
  #
  # @option options [String] :namespace the namespace for the attribute
  #
  # @return [String?]
  def [](name, options = {})
    attributes.get(name, options)
  end

  # Set the attribute with the given name and value.
  #
  # @param name [String] the attribute name
  # @param value [Object] the attribute value
  # @param options [Hash] the options for the attribute
  #
  # @option options [String] :namespace the namespace for the attribute
  def []=(name, value, options = {})
    attributes.set(name, value, options)
  end

  # Add class names to the element.
  #
  # @param names [Array<String>] class names to add
  #
  # @return [self]
  def add_class(*names)
    classes = class_names + names

    unless classes.empty?
      `#@native.className = #{classes.uniq.join ' '}`
    end

    self
  end

  # Get the first node that matches the given CSS selector or XPath.
  #
  # @param path_or_selector [String] an XPath or CSS selector
  #
  # @return [Node?]
  def at(path_or_selector)
    xpath(path_or_selector).first || css(path_or_selector).first
  end

  # Get the first node matching the given CSS selectors.
  #
  # @param rules [Array<String>] the CSS selectors to match with
  #
  # @return [Node?]
  def at_css(*rules)
    result = nil

    rules.each {|rule|
      if result = css(rule).first
        break
      end
    }

    result
  end

  # Get the first node matching the given XPath.
  #
  # @param paths [Array<String>] the XPath to match with
  #
  # @return [Node?]
  def at_xpath(*paths)
    result = nil

    paths.each {|path|
      if result = xpath(path).first
        break
      end
    }

    result
  end

  alias attr []

  alias attribute []

  # @!attribute [r] attributes
  # @return [Attributes] the attributes for the element
  def attributes(options = {})
    Attributes.new(self, options)
  end

  # @!attribute [r] attribute_nodes
  # @return [NodeSet] the attribute nodes for the element
  def attribute_nodes
    NodeSet[Native::Array.new(`#@native.attributes`, get: :item)]
  end

  # @!attribute [r] class_name
  # @return [String] all the element class names
  alias_native :class_name, :className

  # @!attribute [r] class_names
  # @return [Array<String>] all the element class names
  def class_names
    `#@native.className`.split(/\s+/).reject(&:empty?)
  end

  if Browser.supports? 'Query.css'
    def css(path)
      NodeSet[Native::Array.new(`#@native.querySelectorAll(path)`)]
    rescue StandardError, JS::Error
      NodeSet[]
    end
  elsif Browser.loaded? 'Sizzle'
    def css(path)
      NodeSet[`Sizzle(path, #@native)`]
    rescue StandardError, JS::Error
      NodeSet[]
    end
  else
    # Query for children matching the given CSS selector.
    #
    # @param selector [String] the CSS selector
    #
    # @return [NodeSet]
    def css(selector)
      raise NotImplementedError, 'query by CSS selector unsupported'
    end
  end

  # Click the element. it fires the element's click event.
  def click
    `#@native.click()`
    self
  end

  # @overload data()
  #
  #   Return the data for the element.
  #
  #   @return [Data]
  #
  # @overload data(hash)
  #
  #   Set data on the element.
  #
  #   @param hash [Hash] the data to set
  #
  #   @return [self]
  def data(value = nil)
    data = Data.new(self)

    return data unless value

    if Hash === value
      data.assign(value)
    else
      raise ArgumentError, 'unknown data type'
    end

    self
  end

  alias get_attribute []

  alias get []

  # @!attribute height
  # @return [Integer] the height of the element
  def height
    size.height
  end

  def height=(value)
    size.height = value
  end

  # @!attribute id
  # @return [String?] the ID of the element
  def id
    %x{
      var id = #@native.id;

      if (id === "") {
        return nil;
      }
      else {
        return id;
      }
    }
  end

  def id=(value)
    `#@native.id = #{value.to_s}`
  end

  # Set the inner DOM of the element using the {Builder}.
  def inner_dom(builder=nil, &block)
    self.inner_dom = Builder.new(document, builder, &block).to_a
    self
  end

  # Set the inner DOM with the given node.
  #
  # (see #append_child)
  def inner_dom=(node)
    clear

    self << node
  end

  # @!attribute inner_html
  # @return [String] the inner HTML of the element
  def inner_html
    `#@native.innerHTML`
  end

  def inner_html=(value)
    `#@native.innerHTML = #{value}`
  end

  def inspect
    inspect = name.downcase

    if id
      inspect += '.' + id + '!'
    end

    unless class_names.empty?
      inspect += '.' + class_names.join('.')
    end

    "#<#{self.class.name.gsub("Browser::","")}: #{inspect}>"
  end

  # @!attribute offset
  # @return [Offset] the offset of the element
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

  # @!attribute outer_html
  # @return [String] the outer HTML of the element
  def outer_html
    `#@native.outerHTML`
  end

  # @!attribute [r] position
  # @return [Position] the position of the element
  def position
    @position ||= Position.new(self)
  end

  # @!attribute [r] scroll
  # @return [Scroll] the scrolling for the element
  def scroll
    @scroll ||= Scroll.new(self)
  end

  # Search for all the children matching the given XPaths or CSS selectors.
  #
  # @param selectors [Array<String>] mixed list of XPaths and CSS selectors
  #
  # @return [NodeSet]
  def search(*selectors)
    NodeSet.new selectors.map {|selector|
      xpath(selector).to_a.concat(css(selector).to_a)
    }.flatten.uniq
  end

  alias set []=

  alias set_attribute []=

  # Creates or accesses the shadow root of this element
  #
  # @param open [Boolean] set to false if you want to create a closed
  #                       shadow root
  #
  # @return [ShadowRoot]
  def shadow (open = true)
    if root = `#@native.shadowRoot`
      DOM(root)
    else
      DOM(`#@native.attachShadow({mode: #{open ? "open" : "closed"}})`)
    end
  end

  # Checks for a presence of a shadow root of this element
  #
  # @return [Boolean]
  def shadow?
    `!!#@native.shadowRoot`
  end

  # @overload style()
  #
  #   Return the style for the element.
  #
  #   @return [CSS::Declaration]
  #
  # @overload style(data)
  #
  #   Set the CSS style as string or set of values.
  #
  #   @param data [String, Hash] the new style
  #
  #   @return [self]
  #
  # @overload style(&block)
  #
  #   Set the CSS style from a CSS builder DSL.
  #
  #   @return [self]
  def style(data = nil, &block)
    style = CSS::Declaration.new(`#@native.style`)

    return style unless data || block

    if String === data
      style.replace(data)
    elsif Hash === data
      style.assign(data)
    elsif block
      style.apply(&block)
    else
      raise ArgumentError, 'unknown data type'
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
    # @!attribute [r] style!
    # @return [CSS::Declaration] get the computed style for the element
    def style!
      raise NotImplementedError, 'computed style unsupported'
    end
  end

  # Remove an attribute from the element.
  #
  # @param name [String] the attribute name
  def remove_attribute(name)
    `#@native.removeAttribute(name)`
  end

  # Remove class names from the element.
  #
  # @param names [Array<String>] class names to remove
  #
  # @return [self]
  def remove_class(*names)
    classes = class_names - names

    if classes.empty?
      `#@native.removeAttribute('class')`
    else
      `#@native.className = #{classes.join ' '}`
    end

    self
  end

  # @!attribute [r] size
  # @return [Size] the size of the element
  def size(*inc)
    Size.new(self, *inc)
  end

  # Toggle class names of the element.
  #
  # @param names [Array<String>] class names to toggle
  #
  # @return [self]
  def toggle_class(*names)
    to_remove, to_add = names.partition { |name| class_names.include? name }

    add_class(*to_add)
    remove_class(*to_remove)
  end

  # @!attribute width
  # @return [Integer] the width of the element
  def width
    size.width
  end

  def width=(value)
    size.width = value
  end

  # @!attribute [r] window
  # @return [Window] the window for the element
  def window
    document.window
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
    rescue StandardError, JS::Error
      NodeSet[]
    end
  else
    # Query for children matching the given XPath.
    #
    # @param path [String] the XPath
    #
    # @return [NodeSet]
    def xpath(path)
      raise NotImplementedError, 'query by XPath unsupported'
    end
  end
end

end; end

require 'browser/dom/element/attributes'
require 'browser/dom/element/data'
require 'browser/dom/element/position'
require 'browser/dom/element/offset'
require 'browser/dom/element/scroll'
require 'browser/dom/element/size'

require 'browser/dom/element/button'
require 'browser/dom/element/image'
require 'browser/dom/element/form'
require 'browser/dom/element/input'
require 'browser/dom/element/select'
require 'browser/dom/element/template'
require 'browser/dom/element/textarea'
require 'browser/dom/element/iframe'
require 'browser/dom/element/media'
