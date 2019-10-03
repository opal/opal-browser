require 'browser/css/declaration'
require 'browser/css/style_sheet'
require 'browser/css/rule'
require 'browser/css/rule/style'

module Kernel
  # @overload CSS(document = $document, &block)
  #
  #   Create a `<style>` element from a {Paggio::CSS} DSL.
  #
  #   @param document [Browser::DOM::Document] the document instance
  #     we intend to use
  #
  #   @return [Browser::DOM::Element] the created `<style>` element
  #
  # @overload CSS(string, document = $document)
  #
  #   Create a `<style>` element from a string.
  #
  #   @param document [Browser::DOM::Document] the document instance
  #     we intend to use
  #
  #   @return [Browser::DOM::Element] the created `<style>` element
  def CSS(*args, &block)
    document = args.pop || $document

    style = document.create_element(:style)
    style[:type] = 'text/css'

    if block
      style.inner_text = Paggio.css(&block)
    else
      style.inner_text = args.join("")
    end

    style
  end
end
