module Browser; module DOM

class Node < Native
  ELEMENT_NODE                = 1
  ATTRIBUTE_NODE              = 2
  TEXT_NODE                   = 3
  CDATA_SECTION_NODE          = 4
  ENTITY_REFERENCE_NOCE       = 5
  ENTITY_NODE                 = 6
  PROCESSING_INSTRUCTION_NODE = 7
  COMMENT_NODE                = 8
  DOCUMENT_NODE               = 9
  DOCUMENT_TYPE_NODE          = 10
  DOCUMENT_FRAGMENT_NODE      = 11
  NOTATION_NODE               = 12

  def self.new(value = undefined)
    if value && self == Node
      @classes ||= [nil, Element, Attribute, Text, CDATA, nil, nil, nil, Comment, Document]

      if klass = @classes[`value.nodeType`]
        klass.new(value)
      else
        raise ArgumentError, 'cannot instantiate a non derived Node object'
      end
    elsif self == Node
      raise ArgumentError, 'cannot instantiate a non derived Node object'
    else
      super
    end
  end

  def initialize(*)
    super

    %x{
      if (!#@native.callbacks) {
        #@native.callbacks = #{Hash.new {|h, k|
          h[k] = Hash.new { |h, k| h[k] = [] }
        }}
      }
    }
  end

  def ==(other)
    `#@native === #{Native.try_convert(other)}`
  end

  def /(*paths)
    paths.map { |path| xpath(path) }.flatten.uniq
  end

  def <<(node)
    add_child(node)
  end

  def <=>(other)
    raise NotImplementedError
  end

  def >(selector)
    css "> #{selector}"
  end

  def [](name)
    `#@native.getAttribute(#{name.to_s}) || nil`
  end

  def []=(name, value)
    `#@native.setAttribute(#{name.to_s}, #{value.to_s})`
  end

  def add_child(node)
    if NodeSet === node
      node.each {|node|
        add_child(node)
      }
    else
      `#@native.appendChild(#{Native.try_convert(node)})`
    end
  end

  def add_next_sibling(node)
    `#@native.parentNode.insertBefore(node, #@native.nextSibling)`
  end

  def add_previous_sibling(node)
    `#@native.parentNode.insertBefore(node, #@native)`
  end

  alias after add_next_sibling

  def at(path)
    xpath(path).first
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

  def attr(name)
    attributes[name]
  end

  alias attribute attr

  def attribute_nodes
    Array(`#@native.attributes`)
  end

  def attributes
    Hash[attribute_nodes.map { |node| [node.name, node] }]
  end

  def ancestors(expression = nil)
    return NodeSet.new(document) unless respond_to?(:parent) && parent

    parents = [parent]

    while parents.last.respond_to?(:parent)
      break unless parent = parents.last.parent

      parents << parent
    end

    return NodeSet.new(document, parents) unless expression

    root = parents.last

    NodeSet.new(document, parents.select {|parent|
      root.search(selector).include?(parent)
    })
  end

  alias before add_previous_sibling

  def blank?
    raise NotImplementedError
  end

  def callbacks
    `#@native.callbacks`
  end

  def cdata?
    node_type == CDATA_SECTION_NODE
  end

  def child
    children.first
  end

  def children
    NodeSet.new(document, Array(`#@native.childNodes`))
  end

  def children=(node)
    raise NotImplementedError
  end

  def comment?
    node_type == COMMENT_NODE
  end

  def content
    `#@native.nodeValue`
  end

  def content=(value)
    `#@native.nodeValue = value`
  end

  def css(path)
    NodeSet.new(document, Array(`#@native.querySelectorAll(path)`).map { |e| DOM(e) })
  end

  def document
    DOM(`#@native.ownerDocument`)
  end

  def each
    attributes.each { |name, value| yield value }
  end

  def elem?
    node_type == ELEMENT_NODE
  end

  alias element? elem?

  def element_children
    NodeSet.new(document, children.select { |n| n.element? })
  end

  alias elements element_children

  def first_element_child
    element_children.first
  end

  def fragment?
    node_type == DOCUMENT_FRAGMENT_NODE
  end

  alias get []

  alias get_attribute attr

  def hash
    # TODO: implement this properly
  end

  def inner_html(*args)
    `#@native.innerHTML`
  end

  def inner_html=(value)
    `#@native.innerHTML = value`
  end

  alias inner_text inner_html

  def key?(name)
    !!self[name]
  end

  def keys
    attributes.keys
  end

  def last_element_child
    element_children.last
  end

  def matches?(expression)
    ancestors.last.search(expression).include?(self)
  end

  def name
    `#@native.nodeName || nil`
  end

  def name=(value)
    `#@native.nodeName = #{value.to_s}`
  end

  def next
    DOM(`#@native.nextSibling`)
  end

  def next_element
    %x{
      var current = this.nextSibling;

      while (current && current.nodeType != Node.ELEMENT_NODE) {
        current = current.nextSibling;
      }

      return current ? #{DOM(`current`)} : nil;
    }
  end

  alias next_sibling next

  alias node_name name

  alias node_name= name=

  def node_type
    `#@native.nodeType`
  end

  def parent
    DOM(`#@native.parentNode`) if `#@native.parentNode`
  end

  def parent= (node)
    `#@native.parentNode = #{Native.try_convert(node)}`
  end

  def parse (text, options = {})
    raise NotImplementedError
  end

  def path
    raise NotImplementedError
  end

  def previous
    DOM(`#@native.previousSibling`)
  end

  alias previous= add_previous_sibling

  def previous_element
    %x{
      var current = this.previousSibling;

      while (current && current.nodeType != Node.ELEMENT_NODE) {
        current = current.previousSibling;
      }

      return current ? #{DOM(`current`)} : nil;
    }
  end

  alias previous_sibling previous

  def remove_attribute(name)
    `#@native.removeAttribute(name)`
  end

  # TODO: implement for NodeSet
  def replace(node)
    `#@native.parentNode.replaceChild(#@native, #{Native.try_convert(node)})`

    node
  end

  def search(*selectors)
    NodeSet.new document, selectors.map {|selector|
      xpath(selector).to_a.concat(css(selector).to_a)
    }.flatten.uniq
  end

  alias set_attribute []=

  alias text inner_text

  def text?
    node_type == TEXT_NODE
  end

  def traverse(&block)
    raise NotImplementedError
  end

  alias type node_type

  def values
    attribute_nodes.map { |n| n.value }
  end

  def xpath(path)
    result = []

    %x{
      try {
        var tmp = (#@native.ownerDocument || #@native).evaluate(
          path, #@native, null, XPathResult.ORDERED_NODE_SNAPSHOT_TYPE, null);

        result = #{Array(`tmp`, :snapshotItem, :snapshotLength)};
      } catch (e) { }
    }

    NodeSet.new(document, result)
  end

  # event related stuff

  def on(what, namespace = nil, &block)
    raise ArgumentError, 'no block has been passed' unless block

    what     = Event.normalize(what)
    callback = `function (event) {
      event = #{Event.new(`event`)};

      #{block.call(`event`, Kernel.DOM(`this`))}

      return !#{`event`.stopped?};
    }`

    callbacks[what][namespace].push callback

    `#@native.addEventListener(what, callback)`

    self
  end

  def off(what, namespace = nil)
    what = Event.normalize(what)

    if namespace
      if Proc === namespace
        callbacks[what].each {|event, namespaces|
          namespaces.each {|name, callbacks|
            callbacks.reject! {|callback|
              if namespace == callback
                `#@native.removeEventListener(what, callback)`; true
              end
            }
          }
        }
      else
        callbacks[what][namespace].clear
      end
    else
      if Proc === what
        callbacks[what].each {|event, namespaces|
          namespaces.each {|name, callbacks|
            callbacks.reject! {|callback|
              if what == callback
                `#@native.removeEventListener(what, callback)`; true
              end
            }
          }
        }
      else
        callbacks[what].clear

        callbacks.each {|event, namespaces|
          namespaces.each {|name, callbacks|
            if what == name
              callbacks.each {|callback|
                `#@native.removeEventListener(what, callback)`
              }

              callbacks.clear
            end
          }
        }
      end
    end
  end

  def trigger(what, data, bubble = false)
    %x{
      var event = document.createEvent('HTMLEvents');

      event.initEvent('dataavailable', bubble, true);
      event.eventName = what;
      event.data      = data;

      return self.dispatchEvent(event);
    }
  end
end

end; end
