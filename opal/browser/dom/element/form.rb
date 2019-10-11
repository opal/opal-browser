require 'browser/blob'

module Browser; module DOM; class Element < Node

class Form < Element
  # Capture the content of this form to a new {FormData} object,
  #
  # @return [FormData]
  def form_data
    FormData.create(self)
  end
end

end; end; end
