module Browser; module DOM

# Abstract class for all DOM node types.
#
# @see https://developer.mozilla.org/en-US/docs/Web/API/Node
class Node
  include Native

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

  # Wrap a native DOM node.
  #
  # @param value [native] the native DOM node
  #
  # @return [Node]
  def self.new(value)
    if self == Node
      @classes ||= [nil, Element, Attribute, Text, CDATA, nil, nil, nil, Comment, Document, nil, DocumentFragment]

      if klass = @classes[`value.nodeType`]
        klass.new(value)
      else
        raise ArgumentError, 'cannot instantiate a non derived Node object'
      end
    else
      super
    end
  end

  # Return true of the other element is the same underlying DOM node.
  #
  # @return [Boolean]
  def ==(other)
    `#@native === #{Native.try_convert(other)}`
  end

  # Return true if the node name matches the given name case-insensitively.
  #
  # @param name [String] the name to match with
  #
  # @return [Boolean]
  def =~(name)
    self.name.downcase == name.downcase
  end

  # Append a child to the node.
  #
  # When passing a {String} a text node will be created.
  #
  # When passing an Object that responds to #each, every yielded element
  # will be added following the same logic.
  #
  # @param node [String, Node, #each, #to_n] the node to append
  #
  # @return [self]
  def <<(node)
    if native?(node)
      `#@native.appendChild(node)`
    elsif node.respond_to? :each
      node.each { |n| add_child(n) }
    elsif String === node
      `#@native.appendChild(#@native.ownerDocument.createTextNode(node))`
    else
      `#@native.appendChild(#{Native.convert(node)})`
    end

    self
  end

  alias add_child <<

  # Add the passed node after this one.
  #
  # When passing a {String} a text node will be created.
  #
  # @param node [String, Node, #to_n] the node to add
  def add_next_sibling(node)
    if native?(node)
      `#@native.parentNode.insertBefore(node, #@native.nextSibling)`
    elsif String === node
      `#@native.parentNode.insertBefore(
        #@native.ownerDocument.createTextNode(node), #@native.nextSibling)`
    else
      `#@native.parentNode.insertBefore(#{Native.convert(node)},
        #@native.nextSibling)`
    end
  end

  # Add the passed node before this one.
  #
  # When passing a {String} a text node will be created.
  #
  # @param node [String, Node, #to_n] the node to add
  def add_previous_sibling(node)
    if native?(node)
      `#@native.parentNode.insertBefore(node, #@native)`
    elsif String === node
      `#@native.parentNode.insertBefore(
        #@native.ownerDocument.createTextNode(node), #@native)`
    else
      `#@native.parentNode.insertBefore(#{Native.convert(node)}, #@native)`
    end
  end

  alias after add_next_sibling

  # Append the node to the passed one.
  #
  # @param node [Node] the node to append to
  def append_to(node)
    node.add_child(self)
  end

  # Get an array of ancestors.
  #
  # Passing a selector will select the ancestors matching it.
  #
  # @param expression [String] the selector to use as filter
  #
  # @return [NodeSet]
  def ancestors(expression = nil)
    return NodeSet.new(document) unless parent

    parents = [parent]

    while parent = parents.last.parent
      parents << parent
    end

    if Document === parents.last
      parents.pop
    end

    if expression
      parents.select! {|p|
        p.matches? expression
      }
    end

    NodeSet.new document, parents
  end

  alias before add_previous_sibling

  # Remove the node from its parent.
  def remove
    parent.remove_child(self) if parent
  end

  # Remove all the children of the node.
  def clear
    children.each(&:remove)
  end

  # @!attribute content
  # @return [String] the inner text content of the node
  if Browser.supports? 'Element.textContent'
    def content
      `#@native.textContent`
    end

    def content=(value)
      `#@native.textContent = #{value}`
    end
  elsif Browser.supports? 'Element.innerText'
    def content
      `#@native.innerText`
    end

    def content=(value)
      `#@native.innerText = #{value}`
    end
  else
    def content
      raise NotImplementedError, 'node text content unsupported'
    end

    def content=(value)
      raise NotImplementedError, 'node text content unsupported'
    end
  end

  def blank?
    raise NotImplementedError
  end

  # Return true if the node is a CDATA section.
  def cdata?
    node_type == CDATA_SECTION_NODE
  end

  # @!attribute [r] child
  # @return [Node?] the first child of the node
  def child
    children.first
  end

  # @!attribute children
  # @return [NodeSet] the children of the node
  def children
    NodeSet.new(document, Native::Array.new(`#@native.childNodes`))
  end

  def children=(node)
    raise NotImplementedError
  end

  # Return true if the node is a comment.
  def comment?
    node_type == COMMENT_NODE
  end

  # @!attribute [r] document
  # @return [Document?] the document the node is attached to
  def document
    DOM(`#@native.ownerDocument`) if defined?(`#@native.ownerDocument`)
  end

  # Return true if the node is a document.
  def document?
    node_type == DOCUMENT_NODE
  end

  # Return true if the node is an element.
  def elem?
    node_type == ELEMENT_NODE
  end

  alias element? elem?

  # @!attribute [r] element_children
  # @return [NodeSet] all the children which are elements
  def element_children
    children.select(&:element?)
  end

  alias elements element_children

  # @!attribute [r] first_element_child
  # @return [Element?] the first element child
  def first_element_child
    element_children.first
  end

  # Return true if the node is a document fragment.
  def fragment?
    node_type == DOCUMENT_FRAGMENT_NODE
  end

  # @!attribute inner_html
  # @return [String] the inner HTML of the node
  def inner_html
    `#@native.innerHTML`
  end

  def inner_html=(value)
    `#@native.innerHTML = #{value}`
  end

  alias inner_text content
  alias inner_text= content=

  # @!attribute [r] last_element_child
  # @return [Element?] the last element child
  def last_element_child
    element_children.last
  end

  # Check if the node matches the given CSS selector.
  #
  # @param expression [String] the CSS selector
  def matches?(expression)
    false
  end

  # @!attribute name
  # @return [String] the name of the node
  def name
    `#@native.nodeName || nil`
  end

  def name=(value)
    `#@native.nodeName = #{value.to_s}`
  end

  # @!attribute [r] namespace
  # @return [String] the namespace of the node
  def namespace
    `#@native.namespaceURI || nil`
  end

  # @!attribute next
  # @return [Node?] the next sibling of the node
  def next
    DOM(`#@native.nextSibling`) if `#@native.nextSibling != null`
  end

  alias next= add_next_sibling

  # @!attribute [r] next_element
  # @return [Element?] the next element sibling of the node
  def next_element
    current = self.next

    while current && !current.element?
      current = current.next
    end

    current
  end

  alias next_sibling next

  alias node_name name

  alias node_name= name=

  # @!attribute [r] node_type
  # @return [Symbol] the type of the node
  def node_type
    `#@native.nodeType`
  end

  # @!attribute parent
  # @return [Element?] the parent of the node
  def parent
    DOM(`#@native.parentNode`) if `#@native.parentNode != null`
  end

  def parent=(node)
    `#@native.parentNode = #{Native.try_convert(node)}`
  end

  def parse(text, options = {})
    raise NotImplementedError
  end

  def path
    raise NotImplementedError
  end

  # @!attribute previous
  # @return [Node?] the previous sibling of the node
  def previous
    DOM(`#@native.previousSibling`) if `#@native.previousSibling != null`
  end

  alias previous= add_previous_sibling

  # @!attribute [r] previous_element
  # @return [Element?] the previous element sibling of the node
  def previous_element
    current = self.previous

    while current && !current.element?
      current = current.previous
    end

    current
  end

  alias previous_sibling previous

  # Remove the given node from the children of this node.
  def remove_child(node)
    `#@native.removeChild(#{Native.try_convert(node)})`
  end

  # Replace the node with the given one.
  #
  # @todo implement for NodeSet
  #
  # @param node [Node] the node to replace with
  # @return [Node] the passed node
  def replace(node)
    `#@native.parentNode.replaceChild(#@native, #{Native.try_convert(node)})`

    node
  end

  alias text content
  alias text= content=

  # Return true if the node is a text node.
  def text?
    node_type == TEXT_NODE
  end

  def traverse(&block)
    raise NotImplementedError
  end

  alias type node_type

  # @!attribute value
  # @return [String] the value of the node
  def value
    `#@native.nodeValue || nil`
  end

  def value=(value)
    `#@native.nodeValue = value`
  end

  # @private
  def inspect
    "#<DOM::Node: #{name}>"
  end
end

end; end
