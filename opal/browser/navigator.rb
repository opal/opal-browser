module Browser

# Class that represents the browser attributes.
class Navigator
  include Native::Base

  Version = Struct.new(:major, :minor, :build)
  Product = Struct.new(:name, :version)
  Vendor  = Struct.new(:name, :version)

  # Class that represents a MIME type.
  class MimeType
    include Native::Base

    # Get the plugin for the MIME type.
    #
    # @!parse attr_reader :plugin
    # @return [Plugin]
    def plugin
      Plugin.new(`#@native.enabledPlugin`)
    end

    # Get the description for the MIME type.
    #
    # @!parse attr_reader :description
    # @return [String]
    alias_native :description

    # Extensions for this MIME type.
    #
    # @!parse attr_reader :extensions
    # @return [Array<String>]
    def extensions
      `#@native.suffixes`.split(/\s*/)
    end

    # The MIME type.
    #
    # @!parse attr_reader :type
    # @return [String]
    alias_native :type
  end

  # Class to represent a browser plugin.
  class Plugin < Native::Array
    def initialize(plugin)
      # FIXME: uncomment these
      #super plugin do |m|
        #MimeType.new(m)
      #end
    end

    # Get the plugin description.
    #
    # @!parse attr_reader :description
    # @return [String]
    alias_native :description

    # Get the file associated to the plugin.
    #
    # @!parse attr_reader :file
    # @return [String]
    alias_native :file, :filename

    # Get the plugin name.
    #
    # @!parse attr_reader :name
    # @return [String]
    alias_native :name

    # Get the plugin version.
    #
    # @!parse attr_reader :version
    # @return [String]
    alias_native :version
  end

  # Get the browser code name.
  #
  # @!parse attr_reader :code
  # @return [String]
  alias_native :code, :appCodeName

  # Get the browser name.
  #
  # @!parse attr_reader :name
  # @return [String]
  alias_native :name, :appName

  # Get the browser {Version}.
  #
  # @!parse attr_reader :version
  # @return [Version]
  def version
    Version.new(`#@native.appVersion`, `#@native.appMinorVersion`, `#@native.buildID`)
  end

  # Check if cookies are enabled.
  alias_native :cookies?, :cookieEnabled

  # Check if DNT is disabled.
  def track?
    `!#@native.doNotTrack`
  end

  # Check the browser language.
  #
  # @!parse attr_reader :language
  # @return [String]
  alias_native :language

  # Check the supported MIME types.
  #
  # @!parse attr_reader :mime_types
  # @return [Native::Array<MimeType>]
  def mime_types
    Native::Array.new `#@native.mimeTypes`, get: :item, named: :namedItem do |m|
      MimeType.new(m)
    end
  end

  # Check if the browser is in offline mode.
  def offline?
    `!#@native.onLine`
  end

  # Get the operating system the browser is running on.
  #
  # @!parse attr_reader :operating_system
  # @return [String]
  alias_native :operating_system, :oscpu

  alias os operating_system

  # Get the platform the browser is running on.
  #
  # @!parse attr_reader :platform
  # @return [String]
  alias_native :platform

  # Get enabled plugins.
  #
  # @!parse attr_reader :plugins
  # @return [Native::Array<Plugin>]
  def plugins
    Native::Array.new `#@native.plugins` do |p|
      Plugin.new(p)
    end
  end

  # Get the product name and version.
  #
  # @!parse attr_reader :product
  # @return [Product]
  def product
    Product.new(`#@native.product`, `#@native.productSub`)
  end

  alias_native :user_agent, :userAgent

  # Get the vendor name and version.
  #
  # @!parse attr_reader :vendor
  # @return [Vendor]
  def vendor
    Vendor.new(`#@native.vendor`, `#@naive.vendorSub`)
  end

  # Check if Java is enabled.
  def java?
    `#@native.javaEnabled()`
  rescue
    false
  end
end

end
