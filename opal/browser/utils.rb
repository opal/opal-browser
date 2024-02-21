# backtick_javascript: true
module Browser
  Promise = defined?(PromiseV2) ? PromiseV2 : ::Promise

  Size     = Struct.new(:width, :height)
  Position = Struct.new(:x, :y)

  # {Browser::NativeCachedWrapper} is a special case of {Native::Wrapper}.
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
  # and not `.new`'s - it won't work. Use {Native::Wrapper} in this case.
  module NativeCachedWrapper
    def self.included(klass)
      klass.include Native::Wrapper
      klass.extend NativeCachedWrapperClassMethods
    end

    def restricted?
      !!@restricted
    end

    # Change a native reference and make sure the change is reflected on JS
    # side as well. This method is used by Node#initialize_copy. Please don't
    # use this method outside of the cloning semantic.
    def set_native_reference(native)
      `#{native}.$$opal_native_cached = #{self}`
      @native = native
    end
  end

  module NativeCachedWrapperClassMethods
    # Check if we don't have access to arbitrary properties of a (presumably)
    # native object.
    private def restricted?(native)
      %x{
        try {
          typeof(#{native}.$$try_restricted_access);
        } catch (e) {
          if (e.name == 'SecurityError') return true;
        }
        return false;
      }
    end

    def new(native)
      # We can't access arbitrary properties if an element is restricted
      # i.e. the DOM element is an item we can't fully access due to CORS.
      if restricted?(native)
        # Let's try to bypass any further initializers... may be ugly, but
        # works.
        obj = allocate
        obj.instance_variable_set :@native, native
        obj.instance_variable_set :@restricted, true
        return obj
      end

      # It's not a native element? Weird, better throw an exception.
      raise ArgumentError if !native?(native)

      if defined? `#{native}.$$opal_native_cached`
        `#{native}.$$opal_native_cached`
      else
        `#{native}.$$opal_native_cached = #{super(native)}`
      end
    end
  end
end

class Object
  # Encode as URI.
  #
  # @deprecated Please use FormData.encode_uri
  # @return [String] the {Object#to_s} encoded for usage as URI
  def encode_uri
    warn "opal-browser: Object#encode_uri is deprecated. Please use FormData.encode_uri"
    FormData.encode_uri(to_s)
  end

  # Encode as URI component.
  #
  # @deprecated Please use FormData.encode
  # @return [String] the {Object#to_s} encoded for usage as URI component
  def encode_uri_component
    warn "opal-browser: Object#encode_uri_component is deprecated. Please use FormData.encode"
    FormData.encode(to_s)
  end
end

class String
  # Encode as URI component.
  #
  # @deprecated Please use FormData.encode
  # @return [String] the string encoded for usage as URI component
  def encode_uri_component
    warn "opal-browser: String#encode_uri_component is deprecated. Please use FormData.encode"
    FormData.encode(self)
  end

  # Encode as URI.
  #
  # @deprecated Please use FormData.encode_uri
  # @return [String] the string encoded as URI
  def encode_uri
    warn "opal-browser: String#encode_uri is deprecated. Please use FormData.encode_uri"
    FormData.encode_uri(self)
  end

  # Decode as URI component.
  #
  # @deprecated Please use FormData.decode
  # @return [String] the string decoded as URI component
  def decode_uri_component
    warn "opal-browser: String#decode_uri_component is deprecated. Please use FormData.decode"
    FormData.decode(self)
  end

  # Decode as URI.
  #
  # @deprecated Please use FormData.decode_uri
  # @return [String] the string decoded as URI
  def decode_uri
    warn "opal-browser: String#decode_uri is deprecated. Please use FormData.decode_uri"
    FormData.decode_uri(self)
  end
end

class Hash
  # Decode an URL encoded form to a {Hash}.
  #
  # @param string [String] the URL encoded form
  #
  # @deprecated Please use FormData.parse_query
  # @return [Hash]
  def self.decode_uri(string)
    warn "opal-browser: Hash.decode_uri is deprecated. Please use FormData.parse_query"
    FormData.parse_query(string)
  end

  # Encode the Hash to an URL form.
  #
  # @deprecated Please use FormData.build_query
  # @return [String] the URL encoded form
  def encode_uri
    warn "opal-browser: Hash#encode_uri is deprecated. Please use FormData.build_query"
    FormData.build_query(self)
  end
end
