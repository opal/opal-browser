# backtick_javascript: true

require 'browser/blob'

module Browser; class Event

# {DataTransfer} is an object which manages included data to
# an event of type {Event::Drag} or {Event::Clipboard}.
class DataTransfer
  include NativeCachedWrapper

  # @!attribute [rw] effect
  # @return [Symbol] Effect of this drop operation.
  #   Must be one of: :none, :copy, :link or :move.
  def effect
    `#@native.dropEffect`
  end

  def effect= (effect)
    `#@native.dropEffect = #{effect}`
  end

  # Extract some text data from this {DataTransfer} instance.
  def [] (type)
    `#@native.getData(#{type})`
  end

  # Embed some text data in this {DataTransfer} instance.
  def []= (type, value)
    `#@native.setData(#{type}, #{Native.convert(value)})`
  end

  # Clear some (or all, if type is not specified) text data from
  # this {DataTransfer} instance.
  def clear (type=nil)
    `#@native.clearData(#{type.to_n})`
  end

  # @!attribute [w] drag_image
  # Sets a drag image for this {DataTransfer}. Use some
  # {DOM::Element::Image} or {Canvas} as a value.
  def drag_image= (image)
    `#@native.setDragImage(#{Native.convert(image)})`
  end

  # @!attribute [r] files
  # @return [Array<File>] list of files attached to this {DataTransfer}
  def files
    Native::Array.new(`#@native.files`).map { |f| File.new(f.to_n) }
  end

  # @!attribute [r] items
  # @return [Array<Item>] list of items attached to this {DataTransfer}
  def items
    Native::Array.new(`#@native.items`).map { |i| Item.new(i.to_n) }
  end

  # An instance of `DataTransferItem`
  class Item
    include NativeCachedWrapper

    # @!attribute [r] kind
    # @return [Symbol] kind of an item: :string or :file
    def kind
      `#@native.kind`
    end

    def string?; kind == 'string';           end
    def file?;   kind == 'file' && to_file;  end # Some files can't be resolved...

    # @!attribute [r] type
    # @return [String] mime type of an item
    def type
      `#@native.type`
    end

    # Convert to string and call back once ready, or return a
    # promise if a block isn't given.
    def to_string(&block)
      promise = nil
      if !block
        promise = Promise.new
        block = proc { |i| promise.resolve(i) }
      end
      `#@native.getAsString(#{block.to_n})`
      return promise
    end

    # Convert to file or return nil if impossible
    def to_file
      as_file = `#@native.getAsFile()`
      File.new(as_file) if as_file
    end
  end
end

end; end
