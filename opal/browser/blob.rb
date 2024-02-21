# backtick_javascript: true
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

  # Convert a blob to a UTF-8 encoded string.
  #
  # If block is given it will be called with a parameter once we receive
  # the text. Otherwise return a {Promise} which will resolve once we
  # receive it.
  def text(&block)
    promise = nil
    unless block_given?
      promise = Promise.new
      block = proc { |i| promise.resolve(i) }
    end
    `#@native.text().then(#{block.to_n})`
    promise
  end

  # {Buffer} view into the blob
  #
  # If block is given it will be called with a parameter once we receive
  # the buffer. Otherwise return a {Promise} which will resolve once we
  # receive it.
  def buffer
    promise = nil
    unless block_given?
      promise = Promise.new
      block = proc { |i| promise.resolve(i) }
    end
    resblock = proc { |i| block.call(Buffer.new(i)) }
    `#@native.arrayBuffer().then(#{resblock.to_n})`
    promise
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

  # Rename a blob and return a {File} with a new name.
  #
  # @return [File] a renamed blob
  def rename(new_filename)
    File.create([self], new_filename, type: type, 
                                      lastModified: respond_to?(:last_modified) ? 
                                                      last_modified : Time.now)
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
