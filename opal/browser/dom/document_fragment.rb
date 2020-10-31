module Browser; module DOM

# TODO: DocumentFragment is not a subclass of Element, but
#       a subclass of Node. It implements a ParentNode.
#
# @see https://github.com/opal/opal-browser/pull/46
class DocumentFragment < Element
  def self.new(node)
    if self == DocumentFragment
      if defined? `#{node}.mode`
        ShadowRoot.new(node)
      else
        super
      end
    else
      super
    end
  end

  def self.create
    $document.create_document_fragment
  end
end

end; end
