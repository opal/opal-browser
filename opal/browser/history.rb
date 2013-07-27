module Browser

class History < Native
  alias_native :back, :back
  alias_native :forward, :forward
  alias_native :go, :go
  alias_native :length, :length
  alias_native :state, :state

  def push(url, data = nil)
    `#@native.pushState(data, null, url)`

    self
  end

  def replace(url, data = nil)
    `#@native.replaceState(data, null, url)`
  end
end

end
