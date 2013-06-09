module Browser; module DOM

class Text < CharacterData
  def inspect
    "#<DOM::Text: #{value}>"
  end
end

end; end
