module Browser; module DOM; class Element

class Offset
  unless C.has? `document.body`, :getBoundingClientRect
    def position
      doc  = document
      root = doc.root.to_n
      win  = doc.window.to_n

      %x{
        var y = (#{win}.pageYOffset || #{root}.scrollTop) - (#{root}.clientTop || 0),
            x = (#{win}.pageXOffset || #{root}.scrollLeft) - (#{root}.clientLeft || 0);
      }

      Browser::Position.new(`x`, `y`)
    end
  end
end

end; end; end
