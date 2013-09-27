module Browser; module DOM; class Document < Element

unless C.has? `document`, :defaultView
  if C.has? `document`, :parentWindow
    def window
      `#@native.parentWindow`
    end
  else
    def window
      raise NotImplementedError, 'window from document is unsupported'
    end
  end
end

end; end; end
