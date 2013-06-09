module Browser; module DOM

class CDATA < Text
  def inspect
    "#<DOM::CDATA: #{value}>"
  end
end

end; end
