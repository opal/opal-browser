module Browser; module DOM; class Element < Node

class Template < Element
  def content
    DOM(`#@native.content`)
  end
end

end; end; end
