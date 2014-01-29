module Browser; class Event

class Keyboard < UI
  def self.supported?
    Browser.supports? 'Event.Keyboard'
  end

  class Definition < UI::Definition
    def alt!
      `#@native.altKey = true`
    end

    def ctrl!
      `#@native.ctrlKey = true`
    end

    def meta!
      `#@native.metaKey = true`
    end

    def shift!
      `#@native.shiftKey = true`
    end

    def code=(code)
      `#@native.keyCode = #@native.which = #{code}`
    end

    def key=(key)
      `#@native.key = #{key}`
    end

    def char=(char)
      `#@native.char = #@native.charCode = #{char}`
    end

    def repeat!
      `#@native.repeat = true`
    end

    def locale=(value)
      `#@native.locale = value`
    end
  end

  if Browser.supports? 'Event.constructor'
    def self.construct(name, desc)
      `new KeyboardEvent(#{name}, #{desc})`
    end
  elsif Browser.supports? 'Event.create'
    def self.construct(name, desc)
      %x{
        var modifiers = "";

        if (desc.altKey) {
          modifiers += "Alt ";
        }

        if (desc.ctrlKey) {
          modifiers += "Ctrl ";
        }

        if (desc.shiftKey) {
          modifiers += "Shift" ;
        }

        if (desc.metaKey) {
          modifiers += "Meta ";
        }

        var event = document.createEvent("KeyboardEvent");
            event.initKeyboardEvent(name, desc.bubbles, desc.cancelable,
              desc.view || window, desc.which, 0,
              modifiers, desc.repeat, desc.locale);

        return event;
      }
    end
  end if supported?

  alias_native :alt?, :altKey
  alias_native :ctrl?, :ctrlKey
  alias_native :meta?, :metaKey
  alias_native :shift?, :shiftKey
  alias_native :locale
  alias_native :repeat?, :repeat

  def key
    `#@native.key || #@native.keyIdentifier || nil`
  end

  def code
    `#@native.keyCode || #@native.which || nil`
  end

  def char
    `#@native.char || #@native.charCode || #{code ? code.chr : nil}`
  end

  alias to_i key

  def down?
    name.downcase == 'keydown'
  end

  def press?
    name.downcase == 'keypress'
  end

  def up?
    name.downcase == 'keyup'
  end
end

end; end
