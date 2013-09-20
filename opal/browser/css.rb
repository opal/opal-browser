require 'browser/css/style_sheet'
require 'browser/css/declaration'
require 'browser/css/rule'
require 'browser/css/builder'

module Kernel
  def CSS(text = nil, &block)
    style = $document.create_element(:style)
    style[:type] = 'text/css'
    style.append_to($document.head)

    if block
      style.inner_text = Browser::CSS::Builder.new(&block).to_s
    else
      style.inner_text = text
    end

    style
  end
end
