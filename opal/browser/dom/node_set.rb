module Browser; module DOM

class NodeSet
  attr_reader :document

  def initialize(document, list = [])
    @document = document
    @literal  = []

    list.each {|el|
      if NodeSet === el
        @literal.concat(el.to_a)
      else
        @literal.push DOM(Native.try_convert(el))
      end
    }
  end

  def method_missing(name, *args, &block)
    unless @literal.respond_to? name
      each {|el|
        el.__send__(name, *args, &block)
      }

      return self
    end

    result = @literal.__send__ name, *args, &block

    if `result === #@literal`
      self
    elsif Array === result
      NodeSet.new(@document, result)
    else
      result
    end
  end

  def dup
    NodeSet.new(document, to_ary.dup)
  end

  def filter(expression)
    NodeSet.new(document, @internal.select { |node| node.matches?(expression) })
  end

  def after(node)
    last.after node
  end

  def at(path)
    raise NotImplementedError
  end

  def at_css(*rules)
    raise NotImplementedError
  end

  def at_xpath(*paths)
    raise NotImplementedError
  end

  def before
    first.before
  end

  def children
    result = NodeSet.new(document)

    each { |n| result.concat(n.children) }

    result
  end

  def css(*paths)
    raise NotImplementedError
  end

  def search(*what)
    map { |n| n.search(*what) }.flatten.uniq
  end

  def inspect
    "#<DOM::NodeSet: #{@internal.inspect[1 .. -2]}"
  end
end

end; end
