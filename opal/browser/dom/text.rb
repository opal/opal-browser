module Browser; module DOM

# Encapsulates a text node.
#
# @see https://developer.mozilla.org/en-US/docs/Web/API/Text
class Text < CharacterData
  # (see Document#create_text)
  def self.create(*args)
    $document.create_text(*args)
  end

  # @!attribute [r] whole
  # @return [String] the whole text
  #
  # @see https://developer.mozilla.org/en-US/docs/Web/API/Text.wholeText
  def whole
    `#@native.wholeText`
  end

  # Split the text node at a given offset.
  #
  # @param offset [Integer] the offset where to split the text node
  #
  # @return [Text] the newly created text node
  #
  # @see https://developer.mozilla.org/en-US/docs/Web/API/Text.splitText
  def split(offset)
    DOM(`#@native.splitText(offset)`)
  end

  def inspect
    "#<DOM::Text: #{data}>"
  end
end

end; end
