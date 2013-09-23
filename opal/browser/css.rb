require 'browser/css/style_sheet'
require 'browser/css/declaration'
require 'browser/css/rule'
require 'browser/css/builder'

module Kernel
  # Create a <style> element from a string or a block using the
  # {Browser::CSS::Builder} DSL.
  #
  # @param text [String] the CSS text
  # @return [Browser::DOM::Element] the create <style> element
  def CSS(text = nil, &block)
    style = $document.create_element(:style)
    style[:type] = 'text/css'

    if block
      style.inner_text = Browser::CSS::Builder.new(&block).to_s
    else
      style.inner_text = text
    end

    style
  end
end
