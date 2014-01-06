require 'ostruct'

module Browser; module DOM; class Event

class Custom < Event
  def self.supported?
    not $$[:CustomEvent].nil?
  end

  def self.create(name, &block)
    data = OpenStruct.new
    block.call(data) if block

    new(`new CustomEvent(#{name}, {
      bubbles:    #{data.bubbles},
      cancelable: #{data.cancelable},
      detail:     #{data.to_n} })`)
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
