require 'promise'
require 'browser/animation_frame'

module Browser; module DOM

class Document < Element
  # @!attribute [r] active_element
  # @return [Element] the element with focus
  def active_element
    DOM(`#@native.activeElement`)
  end
end

class Element
  # Show the element.
  #
  # @param what [Symbol] how to display it
  def show(what = :block)
    style[:display] = what
    self
  end

  # Hide the element.
  def hide
    style[:display] = :none
    self
  end
  
  def visible?
    # Let's check if we want to lie about the real visibility of an element.
    # It could be wise to lie about it when it's in a process of animation...
    if !@virtually_visible.nil?
      @virtually_visible
    else
      style![:display] != :none
    end
  end

  # Toggle the visibility of the element, hide it if it's shown, show it if
  # it's hidden.
  def toggle
    if visible?
      show
    else
      hide
    end
    self
  end

  # Set the focus on the element.
  def focus
    `#@native.focus()`
    self
  end

  # Blur the focus from the element.
  def blur
    `#@native.blur()`
    self
  end

  # Check if the element is focused.
  def focused?
    `#@native.hasFocus`
  end

  # Queue the block to happen when currently queued animations finish or during
  # the next animation frame.
  def animation_queue &block
    promise = Promise.new

    promise_resolve = proc do
      @animation_promise = nil if @animation_promise == promise
      promise.resolve
    end

    @animation_promise = (@animation_promise || Promise.value(true)).then do
      animation_frame do
        yield promise_resolve
      end
      promise
    end
  end
  
  # Transform an element smoothly using CSS transitions, jQuery style. Yield
  # a block afterwards if it's provided.
  def animate(properties, duration: 0.4.s, easing: :ease, resolve: false, &block)
    animation_queue(resolve) do |res|
      duration = 0.6.s if duration == :slow
      duration = 0.2.s if duration == :fast
      
      original_value = style['transition']
      
      style['transition'] = [original_value,
                            *properties.keys.map do |key|
                              "#{key} #{duration} #{easing}"
                            end].compact.join(", ")
      
      properties.each do |key, value|
        style[key] = value
      end
      
      promise = Promise.new

      one :transitionend do |*args|
        style['transition'] = original_value
                
        yield(*args) if block_given?

        res.call
      end
    end
    self
  end

  # Show a hidden element with a "fade in" animation. Yield a block afterwards.
  def fade_in(**kwargs, &block)
    animation_queue do |resolve|
      if !visible?
        @virtually_visible = true
        show
          
        style[:opacity] = 0.0
        animate opacity: 1.0, **kwargs do |*args|
          @virtually_visible = nil
          style[:opacity] = nil
          yield(*args) if block_given?
        end
      end
      resolve.call
    end
    self
  end
  
  # Hide a visible element with a "fade out" animation. Yield a block afterwards.
  def fade_out(**kwargs, &block)
    animation_queue do |resolve|
      if visible?
        @virtually_visible = false

        style[:opacity] = 1.0
        animate opacity: 0.0, **kwargs do |*args|
          @virtually_visible = nil
          style[:opacity] = nil
          hide
          yield(*args) if block_given?
        end
      end
      resolve.call
    end
    self
  end
  
  # Toggle a visibility of an element with a "fade in"/"fade out" animation. Yield
  # a block afterwards.
  def fade_toggle(**kwargs, &block)
    if visible?
      fade_out(**kwargs, &block)
    else
      fade_in(**kwargs, &block)
    end
    self
  end

  # Show a hidden element with a "slide down" animation. Yield a block afterwards.  
  def slide_down(**kwargs, &block)
    animation_queue do |resolve|
      if !visible?
        @virtually_visible = true
        show
        height = size.height
        orig_height = style[:height]
        style[:height] = 0.px
        
        animate height: height.px, **kwargs do |*args|
          @virtually_visible = nil
          style[:height] = orig_height
          yield(*args) if block_given?
        end
      end
      resolve.call
    end
    self
  end
  
  # Hide a visible element with a "slide up" animation. Yield a block afterwards.
  def slide_up(**kwargs, &block)
    animation_queue do |resolve|
      if visible?
        @virtually_visible = false
        orig_height = style[:height]
        
        animate height: 0.px, **kwargs do |*args|
          @virtually_visible = nil
          style[:height] = orig_height
          hide
          yield(*args) if block_given?
        end
      end
      resolve.call
    end
    self
  end
  
  # Toggle a visibility of an element with a "slide up"/"slide down" animation.
  # Yield a block afterwards.
  def slide_toggle(**kwargs, &block)
    if visible?
      slide_up(**kwargs, &block)
    else
      slide_down(**kwargs, &block)
    end
    self
  end
end

end; end
