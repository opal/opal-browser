module Browser; module DOM

class Comment < CharacterData
  def inspect
    "#<DOM::Comment: #{value}>"
  end
end

end; end
