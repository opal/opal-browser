module Browser

# Representation of the navigator application.
#
# @see https://developer.mozilla.org/en-US/docs/Web/API/Navigator
class Navigator
  include Native

  Version = Struct.new(:major, :minor, :build)
  Product = Struct.new(:name, :version)
  Vendor  = Struct.new(:name, :version)

  # Representation of a MIME type.
  class MimeType
    include Native

    # @!attribute [r] plugin
    # @return [Plugin] the plugin for the MIME type
    def plugin
      Plugin.new(`#@native.enabledPlugin`)
    end

    # @!attribute [r] description
    # @return [String] the description for the MIME type
    alias_native :description

    # @!attribute [r] extensions
    # @return [Array<String>] the extensions for this MIME type
    def extensions
      `#@native.suffixes`.split(/\s*/)
    end

    # @!attribute [r] type
    # @return [String] the MIME type
    alias_native :type
  end

  # Representation of a navigator plugin.
  #
  # @see https://developer.mozilla.org/en-US/docs/Web/API/Plugin
  class Plugin < Native::Array
    def initialize(plugin)
      super plugin do |m|
        MimeType.new(m)
      end
    end

    # @!attribute [r] description
    # @return [String] the plugin description
    alias_native :description

    # @!attribute [r] file
    # @return [String] the file associated with the plugin
    alias_native :file, :filename

    # @!attribute [r] name
    # @return [String] the plugin name
    alias_native :name

    # @!attribute [r] version
    # @return [String] the plugin version
    alias_native :version
  end

  # Representation for the arary of plugins.
  #
  # @see https://developer.mozilla.org/en-US/docs/Web/API/NavigatorPlugins
  class Plugins < Native::Array
    def initialize(plugins)
      super plugins do |p|
        Plugin.new(p)
      end
    end

    # Reload all browser plugins.
    def refresh
      `#@native.refresh(false)`
    end

    # Reload all browser plugins reloading pages that contain `<embed>`s.
    def refresh!
      `#@native.refresh(true)`
    end
  end

  # @!attribute [r] code
  # @return [String] the browser code name
  alias_native :code, :appCodeName

  # @!attribute [r] name
  # @return [String] the browser name
  alias_native :name, :appName

  # @!attribute [r] version
  # @return [Version] the browser version
  def version
    Version.new(`#@native.appVersion`, `#@native.appMinorVersion`, `#@native.buildID`)
  end

  # Check if cookies are enabled.
  alias_native :cookies?, :cookieEnabled

  # Check if DNT is disabled.
  def track?
    `!#@native.doNotTrack`
  end

  # @!attribute [r] language
  # @return [String] the browser language
  alias_native :language

  # @!attribute [r] mime_types
  # @return [Native::Array<MimeType>] the supported MIME types
  def mime_types
    Native::Array.new `#@native.mimeTypes`, get: :item, named: :namedItem do |m|
      MimeType.new(m)
    end
  end

  # Check if the browser is in offline mode.
  def offline?
    `!#@native.onLine`
  end

  # @!attribute [r] operating_system
  # @return [String] the operating system the browser is running on
  alias_native :operating_system, :oscpu

  alias os operating_system

  # @!attribute [r] platform
  # @return [String] the platform the browser is running on
  alias_native :platform

  # @!attribute [r] plugins
  # @return [Plugins] the enabled plugins
  def plugins
    Plugins.new(`#@native.plugins`)
  end

  # @!attribute [r] product
  # @return [Product] the product name and version
  def product
    Product.new(`#@native.product`, `#@native.productSub`)
  end

  # @!attribute [r] user_agent
  # @return [String] the browser's user agent
  alias_native :user_agent, :userAgent

  # @!attribute [r] vendor
  # @return [Vendor] the vendor name and version
  def vendor
    Vendor.new(`#@native.vendor`, `#@native.vendorSub`)
  end

  # Check if Java is enabled.
  def java?
    `#@native.javaEnabled()`
  rescue
    false
  end
end

class Window
  # @!attribute [r] navigator
  # @return [Navigator] the navigator
  def navigator
    Navigator.new(`#@native.navigator`) if `#@native.navigator`
  end
end

end
