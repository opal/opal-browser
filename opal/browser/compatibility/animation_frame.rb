module Browser; class AnimationFrame

if Browser.supports? :animation, :request
  def request(block)
    `#@native.requestAnimationFrame(#{block.to_n})`
  end
elsif Browser.supports? :animation, :request, :chrome
  def request(block)
    `#@native.webkitRequestAnimationFrame(#{block.to_n})`
  end
elsif Browser.supports? :animation, :request, :firefox
  def request(block)
    `#@native.mozRequestAnimationFrame(#{block.to_n})`
  end
elsif Browser.supports? :animation, :request, :opera
  def request(block)
    `#@native.oRequestAnimationFrame(#{block.to_n})`
  end
elsif Browser.supports? :animation, :request, :ie
  def request(block)
    `#@native.msRequestAnimationFrame(#{block.to_n})`
  end
end

if Browser.supports? :animation, :cancel
  def cancel
    `#@native.cancelAnimationFrame(#@id)`
  end
elsif Browser.supports? :animation, :cancel, :chrome
  def cancel
    `#@native.webkitCancelAnimationFrame(#@id)`
  end
elsif Browser.supports? :animation, :cancelRequest, :chrome
  def cancel
    `#@native.webkitCancelRequestAnimationFrame(#@id)`
  end
elsif Browser.supports? :animation, :cancel, :firefox
  def cancel
    `#@native.mozCancelAnimationFrame(#@id)`
  end
elsif Browser.supports? :animation, :cancelRequest, :firefox
  def cancel
    `#@native.mozCancelRequestAnimationFrame(#@id)`
  end
elsif Browser.supports? :animation, :cancel, :opera
  def cancel
    `#@native.oCancelAnimationFrame(#@id)`
  end
elsif Browser.supports? :animation, :cancelRequest, :opera
  def cancel
    `#@native.oCancelRequestAnimationFrame(#@id)`
  end
elsif Browser.supports? :animation, :cancel, :ie
  def cancel
    `#@native.msCancelAnimationFrame(#@id)`
  end
elsif Browser.supports? :animation, :cancelRequest, :ie
  def cancel
    `#@native.msCancelRequestAnimationFrame(#@id)`
  end
end

end; end
