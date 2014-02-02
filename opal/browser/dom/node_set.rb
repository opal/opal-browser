module Browser; module DOM

# Allows manipulation of a set of {Node}s.
class NodeSet
  # Create a new {NodeSet} from the given nodes.
  #
  # Note that the nodes are flattened and converted with DOM automatically,
  # this means you can pass {NodeSet}s and {Native::Array}s as well.
  def self.[](*nodes)
    new(nodes.flatten.map { |x| DOM(Native.convert(x)) }.uniq)
  end

  def initialize(literal)
    @literal = literal
  end

  # Any other method will be called on every node in the set.
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
      NodeSet.new(result)
    else
      result
    end
  end

  # Create another {NodeSet} with all the nodes that match the given
  # expression.
  #
  # @param expression [String] a CSS selector
  #
  # @return [NodeSet] the new {NodeSet} with the matching nodes
  def filter(expression)
    @literal.select { |node| node =~ expression }
  end

  # @!attribute [r] children
  # @return [NodeSet] recursively collected children of the nodes in the set
  def children
    map(&:children).flatten
  end

  # Search for multiple selectors
  def search(*what)
    map { |n| n.search(*what) }.flatten.uniq
  end
end

end; end
