module Browser; module DOM; class Event < Native

class Mutation < Event
  def change
    %w[_ modification addition removal][`#@native.attrChange`]
  end

  def name
    `#@native.attrName`
  end

  def new
    `#@native.newValue`
  end

  def old
    `#@native.prevValue`
  end

  def node
    `#@native.relatedNode`
  end
end

end; end; end
