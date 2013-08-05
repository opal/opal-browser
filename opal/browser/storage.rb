#--
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.
#++

require 'json'

module Browser

class Storage < Hash
  attr_reader :name

  def initialize(window, name)
    super()

    @window = window
    @name   = name

    autosave!

    init if respond_to? :init
  end

  def encoded_name
    "$opal.storage.#{@name}"
  end

  def autosave?;    @autosave;         end
  def autosave!;    @autosave = true;  end
  def no_autosave!; @autosave = false; end

  def replace(what)
    if what.is_a?(String)
      super JSON.parse(what)
    else
      super
    end
  end

  %w([] []= delete clear).each {|name|
    define_method name do |*args|
      super.tap {
        save if autosave?
      }
    end
  }

  def save; end

  if `window.localStorage`
    def init
      replace `#@window.localStorage[#{encoded_name}] || '{}'`
    end

    def save
      `#@window.localStorage[#{encoded_name}] = #{JSON.dump(self)}`
    end
  elsif `window.globalStorage`
    def init
      replace `#@window.globalStorage[#@window.location.hostname][#{encoded_name}] || '{}'`
    end

    def save
      `#@window.globalStorage[#@window.location.hostname][#{encoded_name}] = #{JSON.dump(self)}`
    end
  elsif `document.body.addBehavior`
    def init
      %x{
        #@element = #@window.document.createElement('link');
        #@element.addBehavior('#default#userData');

        #@window.document.getElementsByTagName('head')[0].appendChild(#@element);

        #@element.load(#{encoded_name});
      }

      replace `#@element.getAttribute(#{encoded_name}) || '{}'`
    end

    def save
      %x{
        #@element.setAttribute(#{encoded_name}, #{JSON.dump(self)});
        #@element.save(#{encoded_name});
      }
    end
  else
    def init
      @document = Document.new(`#@window.document`)
      @document.cookies.options expires: 60 * 60 * 24 * 365

      replace @document.cookies[encoded_name]
    end

    def save
      @document.cookies[encoded_name] = self
    end
  end
end

class SessionStorage < Storage
  def init
    replace `#@window.sessionStorage[#{encoded_name}] || '{}'`
  end

  def save
    `#@window.sessionStorage[#{encoded_name}] = #{JSON.dump(self)}`
  end
end

class Window < Native
  def storage(name = :default)
    Storage.new(to_n, name)
  end

  def session_storage(name = :default)
    SessionStorage.new(to_n, name)
  end
end

end
