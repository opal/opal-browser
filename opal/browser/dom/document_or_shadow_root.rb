# backtick_javascript: true
module Browser; module DOM

# Document and ShadowRoot have some methods and properties in common.
# This solution mimics how it's done in DOM.
#
# @see https://developer.mozilla.org/en-US/docs/Web/API/DocumentOrShadowRoot
module DocumentOrShadowRoot
  # @!attribute [r] style_sheets
  # @return [Array<CSS::StyleSheet>] the style sheets for the document
  def style_sheets
    Native::Array.new(`#@native.styleSheets`) {|e|
      CSS::StyleSheet.new(e)
    }
  end

  alias stylesheets style_sheets
end

end; end