module Browser

class Navigator
  include Native::Base

  Version = Struct.new(:major, :minor, :build)
  Product = Struct.new(:name, :version)
  Vendor = Struct.new(:name, :version)

  alias_native :code, :appCodeName
  alias_native :name, :appName

  def version
    Version.new(`#@native.appVersion`, `#@native.appMinorVersion`, `#@native.buildID`)
  end

  alias_native :cookies?, :cookieEnabled

  def track?
    `!#@native.doNotTrack`
  end

  alias_native :language, :language
  alias_native :mime_types, :mimeTypes

  def offline?
    `!#@native.onLine`
  end

  alias_native :operating_system, :oscpu
  alias_native :os, :oscpu
  alias_native :platform, :platform
  alias_native :plugins, :plugins
  alias_native :product, :product

  def product
    Product.new(`#@native.product`, `#@native.productSub`)
  end

  alias_native :user_agent, :userAgent

  def vendor
    Vendor.new(`#@native.vendor`, `#@naive.vendorSub`)
  end

  def java?
    `#@native.javaEnabled()`
  rescue
    false
  end
end

end
