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

  alias_native :origin

  def source
    %x{
      var source = #@native.source;

      if (source instanceof window.Window) {
        return #{Window.new(`source`)};
      }
      else {
        return nil;
      }
    }
  end
end

end; end; end
