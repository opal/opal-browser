require 'ostruct'

module Browser; module DOM; class Event < Native

class Custom < Event
  def self.supported?
    not $$[:CustomEvent].nil?
  end

  def self.create(name, &block)
    data = OpenStruct.new
    block.call(data) if block

    new(`new CustomEvent(#{name}, { detail: #{data.to_n} })`)
  end

  def initialize(native)
    super(native)

    @detail = Hash.new(`#{native}.detail`)
  end

  def method_missing(id, *)
    return @detail[id] if @detail.has_key?(id)

    super
  end
end

end; end; end
