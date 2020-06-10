module Browser

class FormData
  include NativeCachedWrapper

  module Converter
    # Encode as URI component.
    #
    # @return [String] the string encoded for usage as URI component
    def encode(string)
      `encodeURIComponent(#{string})`
    end

    # Decode as URI component.
    #
    # @return [String] the string decoded as URI component
    def decode(string)
      `decodeURIComponent(#{string})`
    end

    # Encode as URI.
    #
    # @return [String] the string encoded as URI
    def encode_uri(string)
      `encodeURI(#{string})`
    end

    # Decode as URI.
    #
    # @return [String] the string decoded as URI
    def decode_uri(string)
      `decodeURI(#{string})`
    end

    # Flattens a hash to build a flat array, later to be formatted to
    # produce a nested query.
    #
    # This code should be compatible with what Rack::Utils#build_nested_query [1]
    # does.
    #
    # [1] https://github.com/rack/rack/blob/master/lib/rack/utils.rb
    def flatten(value, key="")
      case value
      when Hash
        out = []
        value.each do |k,v|
          k = "#{key}[#{k}]" if key != ''
          out += flatten(v,k)
        end
        out
      when Array
        out = []
        value.each do |v|
          k = "#{key}[]"
          out += flatten(v,k)
        end
        out
      else
        [[key,value]]
      end
    end

    # Converts a flat array to a Hash.
    #
    # This code should be compatible with what Rack::Utils#parse_nested_query [1]
    # does.
    #
    # [1] https://github.com/rack/rack/blob/master/lib/rack/utils.rb
    def unflatten(array)
      out = {}
      array.each do |k,v|
        path = [k.split("[").first] + k.scan(/\[(.*?)\]/).flatten
        c = out

        set = proc { |v,weak| } # Do nothing for the first level

        path.each do |i|
          case i
          when "" # Array
            set.([], true)
            set = proc do |v,weak|
              c << v
              c = c.last
            end
          else # Hash
            set.({}, true)
            set = proc do |v,weak|
              c[i] ||= v
              c[i] = v if !weak
              c = c[i]
            end
          end
        end
        set.(v, false)

      end
      out
    end

    # Checks if a query Hash contains any files.
    def contain_files?(hash)
      flatten(hash).any? { |k,v| [File, Blob].include?(v.class) }
    end

    # Convert a query Hash to a query string
    #
    # @return [String] the string encoded as URI
    def build_query(hash, sep=?&)
      flatten(hash).map { |k,v| encode(k) + ?= + encode(v.to_s) }.join(sep)
    end

    # Convert a query Hash to a FormData instance
    #
    # @return [FormData] the instance of FormData
    def build_form_data(hash)
      fd = FormData.create
      flatten(hash).each { |k,v| fd << [k,v] }
      fd
    end

    # Convert a query string to a query Hash
    #
    # @return [Hash] the query hash
    def parse_query(string, sep=?&)
      unflatten(string.split(sep).map { |s| s.split(?=).map(&method(:decode)) })
    end
  end

  extend Converter
  include Enumerable

  # Create a new FormData instance
  def self.create(hash=nil)
    if Hash === hash
      FormData.build_form_data(hash)
    elsif DOM::Element::Form === hash
      new(`new FormData(#{hash.to_n})`)
    else
      new(`new FormData()`)
    end
  end

  # Append a tuple to this FormData instance
  #
  # @param tuple [Array(String, String), Array(String, Blob), Array(String, File),
  #               Array(String, Blob, String), Array(String, File, String)]
  #        a tuple of a key, value and possibly a filename
  def <<(tuple)
    key, value, filename = tuple

    unless filename
      `#@native.append(#{key}, #{Native.convert(value)})`
    else
      `#@native.append(#{key}, #{Native.convert(value)}, #{filename})`
    end
  end

  # Get a field from this FormData instance with a given name
  def [](key)
    Native(`#@native.get(#{key})`)
  end

  # Set a field in this FormData instance with a given name
  def set(key, value, filename = nil)
    unless filename
      `#@native.set(#{key}, #{Native.convert(value)})`
    else
      `#@native.set(#{key}, #{Native.convert(value)}, #{filename})`
    end
  end
  alias []= set

  # Iterate over all elements of this FormData
  def each(&block)
    Native(`#@native.getAll()`).each(&block)
    self
  end

  # Checks if a field of this name exists in this FormData instance
  def include?(key)
    `#@native.has(#{key})`
  end

  # Delete a field from this FormData instance
  def delete(key)
    `#@native.delete(#{key})`
  end
end

end