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

class Proc
  # Defer the function to be called as soon as possible.
  def defer(*args)
    %x{
      var func = #{self};

      setTimeout(function() {
        #{`func`.call(*args)};
      });
    }
  end
end
