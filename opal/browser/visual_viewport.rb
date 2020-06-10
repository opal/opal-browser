# Firefox browsers need either a flag or a polyfill
require "browser/polyfill/visual_viewport"

module Browser
  # The mobile web contains two viewports, the Layout and Visual viewport.
  # The Layout viewport is what a page lays out its elements into and the
  # Visual viewport is what is actually visible on the screen. When the user
  # pinch-zooms into the page, the visual viewport shrinks but the layout viewport
  # is unchanged. UI like the on-screen keyboard (OSK) can also shrink the visual
  # viewport without affecting the layout viewport.
  #
  # https://github.com/WICG/visual-viewport
  # https://developer.mozilla.org/en-US/docs/Web/API/VisualViewport
  class VisualViewport
    include Browser::NativeCachedWrapper
    include Event::Target

    alias_native :offset_left, :offsetLeft
    alias_native :offset_top, :offsetTop
    alias_native :page_left, :pageLeft
    alias_native :page_top, :pageTop
    alias_native :width, :width
    alias_native :height, :height
    alias_native :scale, :scale
  end

  class Window
    def visual_viewport
      @visual_viewport ||= VisualViewport.new(`#@native.visualViewport`)
    end
  end
end