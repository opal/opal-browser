require 'browser/blob'

module Browser; module DOM; class Element < Node

class Form < Element
  # Capture the content of this form to a new {FormData} object,
  #
  # @return [FormData]
  def form_data
    FormData.create(self)
  end

  # Submit a form. This will fire a submit event.
  def submit
    `#@native.submit()`
  end

  # Reset a form. This will fire a reset event.
  def reset
    `#@native.reset()`
  end

  alias_native :action
  alias_native :action=
  alias_native :method
  alias_native :method=
  alias_native :target
  alias_native :target=
  alias_native :name
  alias_native :name= 
  alias_native :encoding
  alias_native :encoding=

  # Return a NodeSet containing all form controls belonging to this form element.
  def controls
    NodeSet[Native::Array.new(`#@native.elements`)]
  end
end

end; end; end
