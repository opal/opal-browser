module Browser
  Size     = Struct.new(:width, :height)
  Position = Struct.new(:x, :y)
end

module Native
  module Wrapper
    # {Native::Wrapper::Singleton} is a special case of {Native::Wrapper}.
    #
    # What this module does is it makes sure that your Ruby objects
    # are mapped 1:1 to your Javascript objects. So that for instance
    # your `$document.at_css('body')` is always the same Ruby object.
    #
    # You can only use it if your final `.new` is of the signature
    # `.new(native)` and your native (probably DOM) object persists and
    # doesn't mind arbitrary properties.
    #
    # The rule of thumb is: if it does overload `#initialize`'s signature
    # and not `.new`'s - it won't work. Use Native::Wrapper in this case.
    module Singleton
      module ClassMethods
        def new(native)
          raise ArgumentError if !native?(native)

          if defined? `#{native}.__opal_singleton__`
            `#{native}.__opal_singleton__`
          else
            `#{native}.__opal_singleton__ = #{super(native)}`
          end
        end
      end

      def self.included(klass)
        klass.include Native::Wrapper
        klass.extend ClassMethods
      end
    end
  end
end

class Object
  # Encode as URI.
  #
  # @return [String] the {Object#to_s} encoded for usage as URI
  def encode_uri
    to_s.encode_uri
  end

  # Encode as URI component.
  #
  # @return [String] the {Object#to_s} encoded for usage as URI component
  def encode_uri_component
    to_s.encode_uri_component
  end
end

class String
  # Encode as URI component.
  #
  # @return [String] the string encoded for usage as URI component
  def encode_uri_component
    `encodeURIComponent(self)`
  end

  # Encode as URI.
  #
  # @return [String] the string encoded as URI
  def encode_uri
    `encodeURI(self)`
  end

  # Decode as URI component.
  #
  # @return [String] the string decoded as URI component
  def decode_uri_component
    `decodeURIComponent(self)`
  end

  # Decode as URI.
  #
  # @return [String] the string decoded as URI
  def decode_uri
    `decodeURI(self)`
  end
end

class Hash
  # Decode an URL encoded form to a {Hash}.
  #
  # @param string [String] the URL encoded form
  #
  # @return [Hash]
  def self.decode_uri(string)
    self[string.split(?&).map {|part|
      name, value = part.split(?=)

      [name.decode_uri_component, value.decode_uri_component]
    }]
  end

  # Encode the Hash to an URL form.
  #
  # @return [String] the URL encoded form
  def encode_uri
    map {|name, value|
      "#{name.to_s.encode_uri_component}=#{value.to_s.encode_uri_component}"
    }.join(?&)
  end
end
