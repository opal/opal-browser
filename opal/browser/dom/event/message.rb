require 'buffer'

module Browser; module DOM; class Event

class Message < Event
  def self.supported?
    not $$[:MessageEvent].nil?
  end

  class Definition < Definition
    def data=(value)
      `#@native.data = #{value.to_n}`
    end
  end

  def self.create(name, &block)
    new(`new MessageEvent(#{name}, #{Definition.new(&block)})`)
  end

  def data
    %x{
      if (#@native.data instanceof ArrayBuffer) {
        return #{Buffer.new(`#@native.data`)};
      }
      else if (#@native.data instanceof Blob) {
        return #{Blob.new(`#@native.data`)};
      }
      else {
        return #@native.data;
      }
    }
  end
end

end; end; end
