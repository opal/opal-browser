module Browser; class Window; class AnimationFrame

unless C.has? :requestAnimationFrame
  supported_with_prefix = false
  %w{ webkit moz o ms }.each do |prefix|
    if C.has? "#{prefix}RequestAnimationFrame"
      def vendored_request_method_name
        "#{prefix}RequestAnimationFrame"
      end
      supported_with_prefix = true
    end
    if C.has? "#{prefix}CancelAnimationFrame"
      def vendored_cancel_method_name
        "#{prefix}CancelAnimationFrame"
      end
    end
    if C.has? "#{prefix}CancelRequestAnimationFrame"
      def vendored_cancel_method_name
        "#{prefix}CancelRequestAnimationFrame"
      end
    end
    break if supported_with_prefix
  end
  unless supported_with_prefix
    def vendored_request_method_name
      raise NotImplementedError, 'window requestAnimationFrame unsupported'
    end
    def vendored_cancel_method_name
      raise NotImplementedError, 'window cancelAnimationFrame unsupported'
    end
  end
end

end; end; end
