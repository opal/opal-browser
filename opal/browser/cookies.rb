# backtick_javascript: true
module Browser

# Allows manipulation of browser cookies.
#
# @see https://developer.mozilla.org/en-US/docs/Web/API/document.cookie
#
# Usage:
#
#   cookies = $document.cookies
#   cookies["my-cookie"] = "monster"
#   cookies.delete("my-cookie")
#
# By default, cookies are stored JSON-encoded. You can supply a `raw:` option
# whenever you need to access/write the cookies in a raw way, eg.
#
#   cookies["my-other-cookie", raw: true] = 123
#
# You can also set this option while referencing $document.cookies, eg.
#
#   cookies = $document.cookies(raw: true)
#   cookies["my-other-cookie"] = 123
class Cookies
  # Default cookie options.
  DEFAULT = {
    expires: Time.now + 60 * 60 * 24,
    secure:  false
  }

  include Enumerable

  attr_reader :options

  # Create a new {Cookies} wrapper.
  #
  # @param document [native] the native document object
  # @param options [Hash] the default cookie options
  def initialize(document, options = {})
    @document = document
    @options  = DEFAULT.merge(options)
  end

  # Access the cookie with the given name.
  #
  # @param name [String] the name of the cookie
  # @param options [Hash] the options for the cookie
  #
  # @option options [Boolean] :raw     get a raw cookie value, don't encode it with JSON
  #
  # @return [Object]
  def [](name, options = {})
    options = @options.merge(options)

    matches = `#@document.cookie`.scan(/#{Regexp.escape(FormData.encode(name))}=([^;]*)/)

    return if matches.empty?

    result = matches.flatten.map do |value|
      if options[:raw]
        FormData.decode(value)
      else
        JSON.parse(FormData.decode(value))
      end
    end

    result.length == 1 ? result.first : result
  end

  # Set a cookie.
  #
  # @param name [String] the name of the cookie
  # @param value [Object] the data to set
  # @param options [Hash] the options for the cookie
  #
  # @option options [Boolean] :raw     don't encode a value with JSON
  # @option options [Integer] :max_age the max age of the cookie in seconds
  # @option options [Time]    :expires the expire date
  # @option options [String]  :path    the path the cookie is valid on
  # @option options [String]  :domain  the domain the cookie is valid on
  # @option options [Boolean] :secure  whether the cookie is secure or not
  def []=(name, options = {}, value)
    options = @options.merge(options)
    if options[:raw]
      string = value.to_s
    else
      string = JSON.dump(value)
    end
    encoded_value = encode(name, string, options)
    `#@document.cookie = #{encoded_value}`
  end

  # Delete a cookie.
  #
  # @param name [String] the name of the cookie
  def delete(name, _options = {})
    `#@document.cookie = #{encode name, '', expires: Time.now}`
  end

  # @!attribute [r] keys
  # @return [Array<String>] all the cookie names
  def keys(_options = {})
    Array(`#@document.cookie.split(/; /)`).map do |cookie|
      cookie.split(/\s*=\s*/).first
    end
  end

  # @!attribute [r] values
  # @return [Array] all the cookie values
  def values(options = {})
    options = @options.merge(options)
    keys.map do |key|
      self[key, options]
    end
  end

  # Enumerate the cookies.
  #
  # @yieldparam key [String] the name of the cookie
  # @yieldparam value [String] the value of the cookie
  #
  # @param options [Hash] the options for the cookie
  #
  # @option options [Boolean] :raw     don't encode a value with JSON
  #
  # @return [self]
  def each(options = {}, &block)
    return enum_for :each, options unless block
    options = @options.merge(options)

    keys.each do |key|
      yield key, self[key, options]
    end

    self
  end

  # Delete all the cookies
  #
  # @return [self]
  def clear(_options = {})
    keys.each do |key|
      delete key
    end

    self
  end

protected
  def encode(key, value, options = {})
    io = []

    io << FormData.encode(key) << ?= << FormData.encode(value) << '; '

    io << 'max-age=' << options[:max_age] << '; '        if options[:max_age]
    io << 'expires=' << options[:expires].utc << '; '    if options[:expires]
    io << 'path='    << options[:path] << '; '           if options[:path]
    io << 'domain='  << options[:domain] << '; '         if options[:domain]
    io << 'secure'                                       if options[:secure]

    io.join
  end
end

class DOM::Document < DOM::Element
  # @!attribute [r] cookies
  # @return [Cookies] the cookies for the document
  def cookies(options = {})
    Cookies.new(@native, options) if defined?(`#@native.cookie`)
  end
end

end
