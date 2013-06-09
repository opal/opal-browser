module Browser; module HTTP

class Header
  attr_reader :name, :value

  def initialize(name, value)
    @name  = name
    @value = value
  end

  def to_s
    @value
  end

  alias to_str to_s
end

class Headers < Hash
  def self.parse(string)
    self[string.lines.map { |l| l.chomp.split(/\s*:\s*/) }]
  end

  def self.[](hash)
    result = new

    hash.each {|name, value|
      result[name] = value
    }

    result
  end

  def []=(name, value)
    super(name, value.is_a?(Header) ? value : Header.new(name, value))
  end

  def merge!(other)
    other.each {|name, value|
      self[name] = value
    }
  end
end

end; end

module Kernel
  def require_external(url)
    result = if url.end_with? '.js'
      `eval(#{File.read(url)})`
    else
      eval File.read(url)
    end

    if block_given?
      yield result
    else
      result
    end
  end
end
