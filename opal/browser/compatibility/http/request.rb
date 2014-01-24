module Browser; module HTTP; class Request

if Browser.supports? :XHR
  def transport
    `new XMLHttpRequest()`
  end
elsif Browser.supports? :ActiveX
  def transport
    `new ActiveXObject("MSXML2.XMLHTTP.3.0")`
  end
end

end; end; end
