module Browser; module DOM; class Element < Node

class Select < Element
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
end

end; end; end
