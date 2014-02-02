require 'stringio'

module Browser

# Allows manipulation of browser cookies.
#
# @see https://developer.mozilla.org/en-US/docs/Web/API/document.cookie
class Cookies
  # Default cookie options.
  DEFAULT = {
    expires: Time.now + 1.day,
    secure:  false
  }

  include Enumerable

  attr_reader :options

  # Create a new {Cookies} wrapper.
  #
  # @param document [native] the native document object
  def initialize(document)
    @document = document
    @options  = DEFAULT.dup
  end

  # Access the cookie with the given name.
  #
  # @param name [String] the name of the cookie
  #
  # @return [Object]
  def [](name)
    matches = `#@document.cookie`.scan(/#{Regexp.escape(name.encode_uri_component)}=([^;]*)/)

    return if matches.empty?

    result = matches.map {|cookie|
      JSON.parse(cookie.match(/^.*?=(.*)$/)[1].decode_uri_component)
    }

    result.length == 1 ? result.first : result
  end

  # Set a cookie.
  #
  # @param name [String] the name of the cookie
  # @param value [Object] the data to set
  # @param options [Hash] the options for the cookie
  #
  # @option options [Integer] :max_age the max age of the cookie in seconds
  # @option options [Time]    :expires the expire date
  # @option options [String]  :path    the path the cookie is valid on
  # @option options [String]  :domain  the domain the cookie is valid on
  # @option options [Boolean] :secure  whether the cookie is secure or not
  def []=(name, value, options = {})
    `#@document.cookie = #{encode name, value.is_a?(String) ? value : JSON.dump(value), @options.merge(options)}`
  end

  # Delete a cookie.
  #
  # @param name [String] the name of the cookie
  def delete(name)
    `#@document.cookie = #{encode name, '', expires: Time.now}`
  end

  # @!attribute [r] keys
  # @return [Array<String>] all the cookie names
  def keys
    Array(`#@document.cookie.split(/; /)`).map {|cookie|
      cookie.split(/\s*=\s*/).first
    }
  end

  # @!attribute [r] values
  # @return [Array] all the cookie values
  def values
    keys.map {|key|
      self[key]
    }
  end

  # Enumerate the cookies.
  #
  # @yieldparam key [String] the name of the cookie
  # @yieldparam value [String] the value of the cookie
  #
  # @return [self]
  def each(&block)
    return enum_for :each unless block

    keys.each {|key|
      yield key, self[key]
    }

    self
  end

  # Delete all the cookies
  #
  # @return [self]
  def clear
    keys.each {|key|
      delete key
    }

    self
  end

protected
  def encode(key, value, options = {})
    io = StringIO.new

    io << key.encode_uri_component << ?= << value.encode_uri_component << '; '

    io << 'max-age=' << options[:max_age] << '; '        if options[:max_age]
    io << 'expires=' << options[:expires].to_utc << '; ' if options[:expires]
    io << 'path='    << options[:path] << '; '           if options[:path]
    io << 'domain='  << options[:domain] << '; '         if options[:domain]
    io << 'secure'                                       if options[:secure]

    io.string
  end
end

class DOM::Document < DOM::Element
  # @!attribute [r] cookies
  # @return [Cookies] the cookies for the document
  def cookies
    Cookies.new(@native) if defined?(`#@native.cookie`)
  end
end

end
