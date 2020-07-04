module Browser; module DOM; class Element < Node

class Template < Element
  def_selector "template"

  def content
    DOM(`#@native.content`)
  end
end

end; end; end
