require 'json'
require 'stringio'

module Browser

# A {Storage} allows you to store data across page loads and browser
# restarts.
#
# Compatibility
# -------------
# The compatibility layer will try various implementations in the following
# order.
#
# + [window.localStorage](https://developer.mozilla.org/en-US/docs/Web/Guide/API/DOM/Storage#localStorage)
# + [window.globalStorage](https://developer.mozilla.org/en-US/docs/Web/Guide/API/DOM/Storage#globalStorage)
# + [document.body.addBehavior](http://msdn.microsoft.com/en-us/library/ms531424(VS.85).aspx)
# + [document.cookie](https://developer.mozilla.org/en-US/docs/Web/API/document.cookie)
#
# @see https://developer.mozilla.org/en-US/docs/Web/Guide/API/DOM/Storage
# @todo remove method_defined? checks when require order is fixed
class Storage
  def self.json_create(data)
    data.delete(JSON.create_id)

    Hash[data.map {|key, value|
      [JSON.parse(key), value]
    }]
  end

  include Enumerable

  # @!attribute [r] name
  # @return [String] the name of the storage
  attr_reader :name

  # Create a new storage on the given window with the given name.
  #
  # @param window [native] the window to save the storage to
  # @param name [String] the name to use to discern different storages
  def initialize(window, name)
    super()

    @window = window
    @name   = name
    @data   = {}

    autosave!
    init
  end

  # @!attribute [r] encoded_name
  # @return [String] the generated name
  def encoded_name
    "$opal.storage.#@name"
  end

  # Check if autosaving is enabled.
  #
  # When autosaving is enabled the {Storage} is saved every time a change is
  # made, otherwise you'll have to save it manually yourself.
  def autosave?
    @autosave
  end

  # Enable autosaving.
  def autosave!
    @autosave = true
  end

  # Disable autosaving.
  def no_autosave!
    @autosave = false
  end

  # Iterate over the (key, value) pairs in the storage.
  #
  # @yield [key, value]
  def each(&block)
    return enum_for :each unless block

    @data.each(&block)

    self
  end

  # Get a value in the storage.
  def [](key)
    @data[key]
  end

  # Set a value in the storage.
  def []=(key, value)
    @data[key] = value

    save if autosave?
  end

  # Delete a value from the storage.
  def delete(key)
    @data.delete(key).tap {
      save if autosave
    }
  end

  # Clear the storage.
  def clear
    @data.clear.tap {
      save if autosave?
    }
  end

  # Replace the current storage with the given one.
  #
  # @param new [Hash, String] if new is a {String} it will be parsed as JSON
  def replace(new)
    if String === new
      @data.replace(JSON.parse(new))
    else
      @data.replace(new)
    end
  end

  # @private
  def init
    replace `#@window.localStorage[#{encoded_name}] || '{}'`
  end unless method_defined? :init

  # Save a snapshot of the storage.
  def save
    `#@window.localStorage[#{encoded_name}] = #{JSON.dump(self)}`
  end unless method_defined? :save

  # Convert the storage to JSON.
  #
  # @return [String] the JSON representation
  def to_json
    io = StringIO.new("{")

    io << JSON.create_id.to_json << ":" << self.class.name.to_json << ","

    each {|key, value|
      io << key.to_json.to_json << ":" << value.to_json << ","
    }

    io.seek(-1, IO::SEEK_CUR)
    io << "}"

    io.string
  end
end

# A {SessionStorage} allows you to store data across page reloads, as long as the session
# is active.
#
# @see https://developer.mozilla.org/en-US/docs/Web/Guide/API/DOM/Storage#sessionStorage
class SessionStorage < Storage
  def init
    replace `#@window.sessionStorage[#{encoded_name}] || '{}'`
  end

  def save
    `#@window.sessionStorage[#{encoded_name}] = #{JSON.dump(self)}`
  end
end

class Window
  # Get a storage with the given name.
  #
  # @param name [Symbol] the name of the storage
  #
  # @return [Storage]
  def storage(name = :default)
    Storage.new(to_n, name)
  end

  # Get a session storage with the given name.
  #
  # @param name [Symbol] the name of the storage
  #
  # @return [SessionStorage]
  def session_storage(name = :default)
    SessionStorage.new(to_n, name)
  end
end

end

require 'browser/compatibility/storage'
