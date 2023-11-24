# backtick_javascript: true

module Browser; module DOM; class Element < Node

class Form < Element
  def_selector "form"

  # Capture the content of this form to a new {FormData} object,
  #
  # @return [FormData]
  def form_data
    FormData.create(self)
  end

  # Returns true if form is valid, false otherwise
  def valid?
    `#@native.reportValidity()`
  end

  # Submit a form. This will NOT fire a submit event.
  def submit
    `#@native.submit()`
  end

  # Submit a form, optionally with a button argument.
  # This will fire a submit event.
  def request_submit(submitter = nil)
    if submitter
      `#@native.requestSubmit(#{submitter.to_n})`
    else
      `#@native.requestSubmit()`
    end
  end

  # Submit a form using AJAX.
  def ajax_submit(&block)
    data = form_data
    data = data.to_h unless encoding == 'multipart/form-data'
    HTTP.send(method, target, form_data, &block)
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
  alias_native :encoding
  alias_native :encoding=

  # Return a NodeSet containing all form controls belonging to this form element.
  def controls
    NodeSet[Native::Array.new(`#@native.elements`)]
  end
end

end; end; end
