module Browser; module DOM

class Text < CharacterData
  def self.create(*args)
    $document.create_text(*args)
  end

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
