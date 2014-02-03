module Browser; module HTTP

# Represents a single HTTP header.
Header = Struct.new(:name, :value)

# Represents HTTP headers.
class Headers
  # Parse HTTP headers from a string.
  #
  # @param string [String] the whole HTTP headers response
  # @return [Headers] the parsed headers
  def self.parse(string)
    self[string.lines.map { |l| l.chomp.split(/\s*:\s*/) }]
  end

  # Create {Headers} from a hash.
  #
  # @param hash [Hash]
  def self.[](hash)
    result = new

    hash.each {|name, value|
      result[name] = value
    }

    result
  end

  include Enumerable

  # Create an empty {Headers}.
  def initialize
    @hash = Hash.new
  end

  # Clear the {Headers}.
  def clear
    @hash.clear
  end

  # Enumerate over the headers.
  #
  # @yieldparam name [String] the name of the header
  # @yieldparam value [String] the value of the header
  #
  # @return [self]
  def each(&block)
    return enum_for :each unless block

    @hash.each {|_, header|
      block.call [header.name, header.value]
    }

    self
  end

  # Get the value of a header.
  #
  # @param name [String] the name of the header
  #
  # @return [String] the value of the header
  def [](name)
    @hash[name.downcase]
  end

  # Set a value for the header.
  #
  # @param name [String] the name of the header
  # @param value [String] the value of the header
  def []=(name, value)
    header = Header.new(name, value)

    @hash[name.downcase] = header
  end

  # Push a header.
  #
  # @param header [Header] the header to push
  #
  # @return [self]
  def <<(header)
    @hash[header.name.downcase] = header

    self
  end

  alias push <<

  # Merge in place other headers.
  #
  # @param other [Headers, Hash, #each] the headers to merge
  #
  # @return [self]
  def merge!(other)
    other.each {|name, value|
      self[name] = value
    }

    self
  end

  # @!attribute [r] length
  # @return [Integer] the number of headers
  def length
    @hash.length
  end
end

end; end
