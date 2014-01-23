module Browser; module DOM; class Element

unless C.xpath?
  if C.wgxpath?
    `wgxpath.install()`
  else
    def xpath(path)
      raise NotImplementedError
    end
  end
end

end; end; end
