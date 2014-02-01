module Browser; module DOM

# A {MutationObserver} is a performant way to observe changes in the DOM,
# either on the tree, the attributes or data.
#
# @see https://developer.mozilla.org/en/docs/Web/API/MutationObserver
class MutationObserver
  def self.supported?
    Browser.supports? :MutationObserver
  end

  include Native

  # Encapsulates a recorded change.
  class Record
    include Native

    # @!attribute [r] type
    # @return [:attributes, :tree, :cdata] the type of the recorded change
    def type
      case `#@native.type`
      when :attributes    then :attribute
      when :childList     then :tree
      when :characterData then :cdata
      end
    end

    # Returns true if the change happened on attributes.
    def attribute?
      type == :attribute
    end

    # Returns true if the change happened on the tree.
    def tree?
      type == :tree
    end

    # Returns true if the change happened in a CDATA section.
    def cdata?
      type == :cdata
    end

    # @!attribute [r] added
    # @return [NodeSet] the added nodes
    def added
      array = if `#@native.addedNodes != null`
        Native::Array.new(`#@native.addedNodes`)
      else
        []
      end

      NodeSet[array]
    end

    # @!attribute [r] removed
    # @return [NodeSet] the removed nodes
    def removed
      array = if `#@native.removedNodes != null`
        Native::Array.new(`#@native.removedNodes`)
      else
        []
      end

      NodeSet[array]
    end

    # @!attribute [r] target
    # @return [Node] the node the mutation affected
    def target
      DOM(`#@native.target`)
    end

    # @!attribute [r] old
    # @return [String] the old value
    alias_native :old, :oldValue

    # @!attribute [r] name
    # @return [String] the name of the attribute
    alias_native :name, :attributeName

    # @!attribute [r] namespace
    # @return [String] the namespace of the attribute
    alias_native :namespace, :attributeNamespace
  end

  # Create a new MutationObserver with the given block.
  #
  # @yieldparam records [Array<Record>] the recorded changes
  def initialize(&block)
    %x{
      var func = function(records) {
        return #{block.call(`records`.map { |r| Browser::DOM::MutationObserver::Record.new(r) })};
      }
    }

    super(`new window.MutationObserver(func)`)
  end

  # Observe the given target with the given options.
  #
  # The supported options are:
  #
  # + **children** - whether to observe changes on the children
  #   of the target or not
  # + **tree** - whether to observe changes on the whole subtree
  #   or not
  # + **attributes** - whether to observe changes to attributes or not,
  #   if the value is `:old` the old value will be saved
  # + **cdata** - whether to observe changes to CDATA sections or not,
  #   if the value is `:old` the old value will be saved
  # + **filter** - array of attribute names to observe
  #
  # @param target [DOM::Node, native] the node to observe
  # @param options [Hash?] the options
  def observe(target, options = nil)
    unless options
      options = {
        children:   true,
        tree:       true,
        attributes: :old,
        cdata:      :old
      }
    end

    `#@native.observe(#{Native.convert(target)}, #{convert(options)})`

    self
  end

  # Empty the observer queue and return its contents.
  #
  # @return [Array<Record>]
  def take
    `#@native.takeRecords()`.map { |r| Record.new(r) }
  end

  # Disconnect the observer, thus stopping observing any changes.
  def disconnect
    `#@native.disconnect()`
  end

private
  def convert(hash)
    options = Native(`{}`)

    if hash[:children]
      options[:childList] = true
    end

    if hash[:tree]
      options[:subtree] = true
    end

    if attrs = hash[:attributes]
      options[:attributes] = true

      if attrs == :old
        options[:attributeOldValue] = true
      end
    end

    if filter = hash[:filter]
      options[:attributeFilter] = filter
    end

    if cdata = hash[:cdata]
      options[:characterData] = true

      if cdata == :old
        options[:characterDataOldValue] = true
      end
    end

    options.to_n
  end
end

end; end
