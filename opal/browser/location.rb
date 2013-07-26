module Browser

class Location < Native
  def assign(url)
    `#@native.assign(#{url.to_s})`
  end

  def reload(force = false)
    `#@native.reload(force)`
  end

  def replace(url)
    `#@native.replace(#{url.to_s})`
  end

  def to_s
    `#@native.toString()`
  end

  %w[hash host hostname href pathname port protocol search].each {|name|
    define_method name do
      `#@native[#{name}]`
    end

    define_method "#{name}=" do |value|
      `#@native[#{name}] = #{value}`
    end
  }

  alias path pathname
  alias path= pathaname=
end

end
