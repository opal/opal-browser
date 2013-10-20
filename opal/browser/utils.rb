module Browser
  Size     = Struct.new(:width, :height)
  Position = Struct.new(:x, :y)
end

class String
  # Encode as URI component.
  #
  # @return [String] the string encoded for usage as URI component
  def encode_uri_component
    `encodeURIComponent(#{self})`
  end

  # Encode as URI.
  #
  # @return [String] the string encoded as URI
  def encode_uri
    `encodeURI(#{self})`
  end

  # Decode as URI component.
  #
  # @return [String] the string decoded as URI component
  def decode_uri_component
    `decodeURIComponent(#{self})`
  end

  # Decode as URI.
  #
  # @return [String] the string decoded as URI
  def decode_uri
    `decodeURI(#{self})`
  end
end

class Hash
  def self.decode_uri(string)
    self[string.split(?&).map {|part|
      name, value = part.split(?=)

      [name.decode_uri_component, value.decode_uri_component]
    }]
  end

  def encode_uri
    map {|name, value|
      "#{name.to_s.encode_uri_component}=#{value.to_s.encode_uri_component}"
    }.join(?&)
  end
end
