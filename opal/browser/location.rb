module Browser

class Location
  include Native::Base

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
    alias_native name
    alias_native "#{name}="
  }

  alias path pathname
  alias path= pathaname=
end

end
