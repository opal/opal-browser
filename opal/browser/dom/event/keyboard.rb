module Browser; module DOM; class Event

class Keyboard < UI
  def self.supported?
    not $$[:KeyboardEvent].nil?
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
  end

  def self.create(name, &block)
    new(`new KeyboardEvent(#{name}, #{Definition.new(&block)})`)
  end

  def alt?
    `#@native.altKey`
  end

  def ctrl?
    `#@native.ctrlKey`
  end

  def meta?
    `#@native.metaKey`
  end

  def shift?
    `#@native.shiftKey`
  end

  def repeat?
    `#@native.repeat`
  end

  def key
    `#@native.key`
  end

  def code
    `#@native.keyCode || #@native.which`
  end

  def char
    `#@native.char || #@native.charCode || #{key.chr}`
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

end; end; end
