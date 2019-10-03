module Browser; module DOM; class Element < Node

class Iframe < Element
  # @!attribute src
  # @return [String] the URL of the page to embed
  alias_native :src
  alias_native :src=

  # @!attribute [r] content_window
  # @return [Window] window of content of this iframe
  def content_window
    Browser::Window.new(`#@native.contentWindow`)
  end

  # @!attribute [r] content_document
  # @return [Document] document of content of this iframe 
  def content_document
    DOM(`#@native.contentDocument || #@native.contentWindow.document`)
  end

  # Send a message to the iframe content's window.
  #
  # @param message [String] the message
  # @param options [Hash] optional `to: target`
  def send(message, options={})
    content_window.send(message, options)
  end
end

end; end; end
