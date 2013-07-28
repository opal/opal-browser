module Browser

class History < Native
  alias_native :length, :length

  def back(number = 1)
    `#@native.go(-number)`

    self
  end

  def forward(number = 1)
    `#@native.go(number)`

    self
  end

  def push(url, data = nil)
    data = `null` if data.nil?

    `#@native.pushState(data, null, url)`

    self
  end

  def replace(url, data = nil)
    data = `null` if data.nil?

    `#@native.replaceState(data, null, url)`
  end

  def current
    $window.location.pathname
  end

  def state
    `#@native.state`
  end
end

end
