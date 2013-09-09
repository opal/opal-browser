module Browser; module DOM

class Builder < BasicObject
  class Element < BasicObject
    def initialize(builder, element)
      @builder = builder
      @element = element
    end

    def method_missing(name, &block)
      if name.end_with? ?!
        @element[:id] = name[0 .. -2]
      else
        @element.add_class name
      end

      @builder.extend!(@element, &block) if block

      self
    end
  end

  def initialize(document, element = nil, &block)
    @document = document
    @element  = element
    @roots    = NodeSet.new

    if block.arity == 0
      instance_exec(&block)
    else
      block.call(self)
    end
  end

  def root!
    @roots.first
  end

  def roots!
    @roots
  end

  def element!
    @current
  end

  alias el! element!

  def namespace!(name, &block)
    @namespace = name

    extend!(&block)
  end

  def extend!(element = nil, &block)
    old, @current = @current, element if element

    if block.arity == 0
      instance_exec(&block)
    else
      block.call(self)
    end

    @current = old if element

    self
  end

  def <<(what)
    if what.is_a?(String)
      @current << create_text!(what)
    else
      @current << what
    end
  end

  def method_missing(name, *args, &block)
    if args.first.is_a?(String)
      content = args.shift
    end

    attributes = args.shift || {}

    if block
      parent  = @current
      element = create_element!(name, attributes)

      if content
        element << create_text!(content)
      end

      @current = element
      result = if block.arity == 0
        instance_eval(&block)
      else
        block.call(self)
      end
      @current = parent

      if String === result
        element.inner_html = result
      end

      (parent || @roots) << element
    else
      element  = create_element!(name, attributes)
      element << create_text!(content) if content

      (@current || @roots) << element
    end

    Element.new(self, element)
  end

private
  def create_element!(name, attributes)
    @document.create_element(name, namespace: @namespace).tap {|el|
      el.attributes.merge!(attributes)
    }
  end

  def create_text!(content)
    @document.create_text(content)
  end
end

end; end
