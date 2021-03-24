module Browser; module DOM

# Abstract class for all Nodes that can have children.
#
# @see https://developer.mozilla.org/en-US/docs/Web/API/ParentNode
class ParentNode

  # @!attribute [r] children
  # @return [NodeSet] the children of the node
  def children
    NodeSet[Native::Array.new(`#@native.children`)]
  end

  alias elements children

  # @!attribute [r] first_element_child
  # @return [Element?] the first element child
  def first_element_child
    DOM(`#@native.firstElementChild`)
  end

  # @!attribute [r] last_element_child
  # @return [Element?] the last element child
  def last_element_child
    DOM(`#@native.lastElementChild`)
  end

  # @!attribute [r] child_element_count
  # @return [Element?] the last element child
  def child_element_count
    `#@native.childElementCount`
  end

end

end; end
