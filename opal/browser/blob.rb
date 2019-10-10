module Browser

class Blob
  include NativeCachedWrapper

  # Create a new blob from anything that Blob API supports
  def self.create(from, options={})
    new(`new Blob(#{Native.convert(from)}, #{options.to_n})`)
  end

  # @!attribute [r] size
  # @return [Integer] blob size in bytes
  def size
    `#@native.size`
  end

  # @!attribute [r] type
  # @return [String] blob mime type
  def type
    `#@native.type`
  end

  # Blob converted to an UTF-8 encoded string
  def text
    `#@native.text()`
  end

  # {Buffer} view into the blob
  def buffer
    Buffer.new(`#@native.arrayBuffer()`)
  end

  # Create a new blob by slicing this blob
  def slice(start, finish=nil)
    Blob.new(`#@native.slice(#{start}, #{finish})`)
  end

  # Convert a blob to an URL that can be used to reference this blob in DOM
  # eg. display some multimedia
  def to_url(window=$window)
    `#{window.to_n}.URL.createObjectURL(#@native)`
  end
end

class File < Blob
  # Create a new file from anything that File API supports
  def self.create(from, name, options={})
    new(`new File(#{Native.convert(from)}, #{name}, #{options.to_n})`)
  end

  # @!attribute [r] last_modified
  # @return [Time] last modified date of this file
  def last_modified
    Time.at(`#@native.lastModified`/1000.0)
  end

  # @!attribute [r] name
  # @return [String] filename 
  def name
    `#@native.name`
  end
end

end