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
    reload
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

  include Enumerable

  # Iterate over the (key, value) pairs in the storage.
  #
  # @yield [key, value]
  def each(&block)
    return enum_for :each unless block

    @data.each(&block)

    self
  end

  def method_missing(*args, &block)
    @data.__send__(*args, &block)
  end

  # Set a value in the storage.
  def []=(key, value)
    @data[key] = value

    save if autosave?
  end

  # Delete a value from the storage.
  def delete(key)
    @data.delete(key).tap {
      save if autosave?
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

  # Call the block between a [#reload] and [#save].
  def commit(&block)
    autosave  = @autosave
    @autosave = false
    result    = nil

    reload

    begin
      result = block.call
      save
    rescue
      reload
      raise
    ensure
      @autosave = autosave
    end

    result
  end

  def to_h
    @data
  end

  # @!method reload
  #   Load the storage.

  # @!method save
  #   Persist the current state to the storage.

  if Browser.supports? 'Storage.local'
    def reload
      replace `#@window.localStorage[#@name] || '{}'`
    end

    def save
      `#@window.localStorage[#@name] = #{JSON.dump(self)}`
    end
  elsif Browser.supports? 'Storage.global'
    def reload
      replace `#@window.globalStorage[#@window.location.hostname][#@name] || '{}'`
    end

    def save
      `#@window.globalStorage[#@window.location.hostname][#@name] = #{JSON.dump(self)}`
    end
  elsif Browser.supports? 'Element.addBehavior'
    def reload
      %x{
        #@element = #@window.document.createElement('link');
        #@element.addBehavior('#default#userData');

        #@window.document.getElementsByTagName('head')[0].appendChild(#@element);

        #@element.load(#@name);
      }

      replace `#@element.getAttribute(#@name) || '{}'`
    end

    def save
      %x{
        #@element.setAttribute(#@name, #{JSON.dump(self)});
        #@element.save(#@name);
      }
    end
  else
    def reload
      $document.cookies.options expires: 60 * 60 * 24 * 365

      replace $document.cookies[@name]
    end

    def save
      $document.cookies[@name] = JSON.dump(self)
    end
  end

  # Convert the storage to JSON.
  #
  # @return [String] the JSON representation
  def to_json
    io = StringIO.new("{")

    io << JSON.create_id.to_json << ":" << self.class.name.to_json << ","

    @data.each {|key, value|
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
  def self.supported?
    Browser.supports? 'Storage.session'
  end

  def reload
    replace `#@window.sessionStorage[#@name] || '{}'`
  end

  def save
    `#@window.sessionStorage[#@name] = #{JSON.dump(self)}`
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
