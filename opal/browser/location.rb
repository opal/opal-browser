require 'forwardable'

module Browser

class Location < Native
  extend Forwardable

  def_delegators :@native, :hash, :host, :hostname, :href, :pathname, :port, :protocol, :search

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
end

end
