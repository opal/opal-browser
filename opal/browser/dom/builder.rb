module Browser; module DOM

class Builder < BasicObject
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

    if block.arity == 0
      instance_exec(&block)
    else
      block.call(self)
    end
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
      parent, @current = @current, create_element!(name, attributes)

      if content
        @current << create_text!(content)
      end

      result = if block.arity == 0
        instance_eval(&block)
      else
        block.call(self)
      end

      if String === result
        @current << create_text!(result)
      end

      (parent || @roots) << @current

      @current = parent
    else
      (@current || @roots) << create_element!(name, attributes).tap {|el|
        el << create_text!(content) if content
      }
    end
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
