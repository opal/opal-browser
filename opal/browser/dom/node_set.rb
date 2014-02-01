module Browser; module DOM

# Allows manipulation of a set of {Node}s.
class NodeSet
  def self.[](*nodes)
    new(nodes.flatten.map { |x| DOM(Native.convert(x)) })
  end

  def initialize(array)
    @array = array
  end

  def respond_to_missing?(name)
    @array.respond_to?(name)
  end

  def method_missing(name, *args, &block)
    unless @array.respond_to? name
      each {|el|
        el.__send__(name, *args, &block)
      }

      return self
    end

    result = @array.__send__ name, *args, &block

    if `result === #@array`
      self
    elsif Array === result
      NodeSet.new(result)
    else
      result
    end
  end

  def dup
    NodeSet.new(@array.dup)
  end

  def filter(expression)
    NodeSet.new(@array.select { |node| node =~ expression })
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
    result = NodeSet.new([])

    each { |n| result.concat(n.children) }

    result
  end

  def css(*paths)
    raise NotImplementedError
  end

  def search(*what)
    map { |n| n.search(*what) }.flatten.uniq
  end

  def to_a
    @array.dup
  end

  def to_ary
    self
  end

  def inspect
    "#<DOM::NodeSet: #{@array.inspect[1 .. -2]}"
  end
end

end; end
