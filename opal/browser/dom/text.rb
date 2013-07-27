module Browser; module DOM

class Text < CharacterData
  def whole
    `#@native.wholeText`
  end

  def split(offset)
    `#@native.splitText(offset)`
  end

  def inspect
    "#<DOM::Text: #{data}>"
  end
end

end; end
