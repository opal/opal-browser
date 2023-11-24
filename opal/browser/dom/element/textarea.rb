# backtick_javascript: true

module Browser; module DOM; class Element < Node

class Textarea < Element
  def_selector "textarea"

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

  def clear
    `#@native.value = ''`
  end
end

end; end; end
