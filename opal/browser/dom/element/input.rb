module Browser; module DOM; class Element < Node

class Input < Element
  def_selector "input"

  def value
    %x{
      if (#@native.value == "") {
        return nil;
      }
      else {
        return #@native.value;
      }
    }
  end

  def value=(value)
    `#@native.value = #{value}`
  end

  def name_
    `#@native.name`
  end

  def type
    `#@native.type`
  end

  def checked?
    `#@native.checked`
  end

  def check!
    `#@native.checked = 'checked'`
  end

  def uncheck!
    `#@native.checked = ''`
  end

  def enabled?
    `#@native.enabled`
  end

  def disable!
    `#@native.disabled = 'disabled'`
  end

  def enable!
    `#@native.disabled = ''`
  end

  def clear
    `#@native.value = ''`
  end

  # @!attribute [r] files
  # @return [Array<File>] list of files attached to this {Input}
  def files
    Native::Array.new(`#@native.files`).map { |f| File.new(f.to_n) }
  end
end

end; end; end
