module Browser; module DOM

class CharacterData < Node
  # Append data to the node.
  #
  # @param string [String] the data to add
  #
  # @return [self]
  def append(string)
    `#@native.appendData(string)`

    self
  end

  # @!attribute [r] data
  # @return [String] the data of the node
  def data
    `#@native.data`
  end

  # Delete data from the node.
  #
  # @param count [Integer] how much data to delete
  # @param offset [Integer] the offset to start at
  #
  # @return [self]
  def delete(count, offset = 0)
    `#@native.deleteData(offset, count)`

    self
  end

  # Insert data in the node.
  #
  # @param string [String] the data to insert
  # @param offset [Integer] the offset to start at
  #
  # @return [self]
  def insert(string, offset = 0)
    `#@native.insertData(offset, string)`

    self
  end

  # @!attribute [r] length
  # @return [Integer] the length of the node
  alias_native :length

  # Replace data in the node.
  #
  # @param string [String] the data to replace with
  # @param offset [Integer] the offset to start at
  # @param count [Integer] how much data to replace
  #
  # @return [self]
  def replace(string, offset = 0, count = `#@native.length`)
    `#@native.replaceData(offset, count, string)`

    self
  end

  # Get a substring of the data.
  #
  # @param count [Integer] how much data to lice
  # @param offset [Integer] the offset to start at
  #
  # @return [String] the substring
  def substring(count, offset = 0)
    `#@native.substringData(offset, count)`
  end
end

end; end
