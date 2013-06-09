module Browser

class Cookies
  include Enumerable

  def initialize(document)
    @document = document

    @options = {
      expires: Time.now + 1.day,
      path:    '',
      domain:  '',
      secure:  ''
    }
  end

  def options (value = nil)
    value ? @options.merge!(value) : @options
  end

  def [] (name)
    matches = `#@document.cookie`.scan(/#{Regexp.escape(key.encode_uri_component)}=([^;]*)/)

    return if matches.empty?

    result = matches.map {|cookie|
      JSON.parse(cookie.match(/^.*?=(.*)$/)[1].decode_uri_component)
    }

    result.length == 1 ? result.first : result
  end

  def []= (name, value, options = {})
    `#@document.cookie = #{encode name, value.is_a?(String) ? value : JSON.dump(value), @options.merge(options)}`
  end

  def delete (name)
    `#@document.cookie = #{encode name, '', expires: Time.now}`
  end

  def keys
    Array(`#@document.cookie.split(/; /)`).map {|cookie|
      cookie.split(/\s*=\s*/).first
    }
  end

  def values
    keys.map {|key|
      self[key]
    }
  end

  def each
    keys.each {|key|
      yield key, self[key]
    }
  end

  def clear
    keys.each {|key|
      delete key
    }
  end

protected
  def encode (key, value, options = {})
    result = "#{key.encode_uri_component}=#{value.encode_uri_component}; "

    result += "max-age=#{options[:max_age]}; "        if options[:max_age]
    result += "expires=#{options[:expires].to_utc}; " if options[:expires]
    result += "path=#{options[:path]}; "              if options[:path]
    result += "domain=#{options[:domain]}; "          if options[:domain]
    result += 'secure'                                if options[:secure]

    result
  end
end

end
