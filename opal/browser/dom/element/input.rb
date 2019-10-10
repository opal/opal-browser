require 'browser/blob'

module Browser; module DOM; class Element < Node

class Input < Element
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

  def checked?
    `#@native.checked`
  end

  def check!
    `#@native.checked = 'checked'`
  end

  def uncheck!
    `#@native.checked = ''`
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
