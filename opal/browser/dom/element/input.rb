# backtick_javascript: true

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

  alias_native :value=
  alias_native :name_, :name
  alias_native :type
  alias_native :checked?, :checked
  alias_native :enabled?, :enabled

  def check!
    `#@native.checked = 'checked'`
  end

  def uncheck!
    `#@native.checked = ''`
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
