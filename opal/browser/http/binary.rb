module Browser; module HTTP

# Represents a binary result from a HTTP response.
class Binary
  # @!attribute [r] type
  # @return [:string, :buffer] the type of binary
  attr_reader :type

  # Create a binary from a value.
  #
  # @param value [String, Buffer] the binary
  def initialize(value)
    if String === value
      @type = :string
      @data = value
    else
      @type = :buffer
      @data = value.to_a
    end
  end

  include Enumerable

  # Iterate over each byte in the binary.
  #
  # @yield [byte] the byte
  #
  # @return [self]
  def each(&block)
    return enum_for :each unless block

    index  = 0
    length = self.length

    while index < length
      block.call(self[index])

      index += 1
    end

    self
  end

  # Access a byte from the binary.
  #
  # @return [Integer] a byte
  def [](index)
    @type == :string ? `#@data.charCodeAt(index) & 0xff` : @data[index]
  end

  # @!attribute [r] length
  # @return [Integer] the length of the binary
  def length
    @data.length
  end
end

end; end
