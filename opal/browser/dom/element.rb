module Browser; module DOM

class Element < Node
  def inspect
    "#<DOM::Element: #{name}>"
  end
end

end; end
