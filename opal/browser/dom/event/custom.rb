require 'ostruct'

module Browser; module DOM; class Event

class Custom < Event
  def self.supported?
    not $$[:CustomEvent].nil?
  end

  class Definition < Definition
    def method_missing(name, value)
      if name.end_with? ?=
        `#@native[#{name[0 .. -2]}] = value`
      end
    end
  end

  def self.construct(name, desc)
    `new CustomEvent(name, desc)`
  end

  def initialize(native)
    super(native); @native = native # FIXME: remove this when super is fixed

    @detail = Hash.new(`#{native}.detail`)
  end

  def method_missing(id, *)
    return @detail[id] if @detail.has_key?(id)

    super
  end
end

end; end; end
