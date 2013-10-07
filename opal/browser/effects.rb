module Browser; module DOM
  
class Element
  def show(what = :block)
    style[:display] = what
  end

  def hide
    style[:display] = :none
  end

  def toggle
    if style![:display] == :none
      show
    else
      hide
    end
  end
end

end; end
