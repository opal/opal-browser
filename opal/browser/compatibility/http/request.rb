module Browser; module HTTP; class Request

unless C.has? :XMLHttpRequest
  if C.has? :ActiveXObject
    def transport
      `new ActiveXObject("MSXML2.XMLHTTP.3.0")`
    end
  else
    def transport
      raise NotImplementedError, 'XMLHttpRequest is unsupported'
    end
  end
end

end; end; end
