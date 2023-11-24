# backtick_javascript: true

module Browser; module DOM; class Element < Node

class Image < Element
  def_selector "img"

  alias_native :complete?, :complete
  alias_native :cross?, :crossOrigin
  alias_native :height, :naturalHeight
  alias_native :width, :naturalWidth
end

Img = Image

end; end; end
