module Browser; module DOM; class Element

unless C.has?(`document.body`, :getBoundingClientRect)
  def offset
    doc  = document
    root = doc.root.to_n
    win  = doc.window.to_n

    %x{
      var y = (#{win}.pageYOffset || #{root}.scrollTop) - (#{root}.clientTop || 0),
          x = (#{win}.pageXOffset || #{root}.scrollLeft) - (#{root}.clientLeft || 0);
    }

    Position.new(`x`, `y`, `#@native.offsetParent ? #@native.offsetParent : #{root}`)
  end
end

end; end; end
