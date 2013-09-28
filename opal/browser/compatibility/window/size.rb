module Browser; class Window

unless C.has? :innerHeight
  def size
    Size.new(`#@native.document.documentElement.clientWidth`,
             `#@native.document.documentElement.clientHeight`)
  end
end

end; end
