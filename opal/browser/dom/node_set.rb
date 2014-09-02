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

  # Get the first node matching the given CSS selectors.
  #
  # @param rules [Array<String>] the CSS selectors to match with
  #
  # @return [Node?]
  def at_css(*rules)
    each {|node|
      if node = node.at_css(*rules)
        return node
      end
    }

    nil
  end

  # Get the first node matching the given XPath.
  #
  # @param paths [Array<String>] the XPath to match with
  #
  # @return [Node?]
  def at_xpath(*paths)
    each {|node|
      if node = node.at_xpath(*paths)
        return node
      end
    }

    nil
  end

  # Query for children matching the given CSS selector.
  #
  # @param selector [String] the CSS selector
  #
  # @return [NodeSet]
  def css(path)
    NodeSet[@literal.map {|node|
      node.css(path)
    }]
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

  # Search for multiple selectors
  def search(*what)
    NodeSet[@literal.map { |node| node.search(*what) }]
  end

  # Query for children matching the given XPath.
  #
  # @param path [String] the XPath
  #
  # @return [NodeSet]
  def xpath(path)
    NodeSet[@literal.map {|node|
      node.xpath(path)
    }]
  end

  def to_ary
    @literal
  end
end

end; end
