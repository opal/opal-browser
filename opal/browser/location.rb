module Browser

class Location
  include Native::Base

  # Change the location.
  def assign(url)
    `#@native.assign(#{url.to_s})`
  end

  # Reload the page.
  #
  # @param force [Boolean] whether to force the reload
  def reload(force = false)
    `#@native.reload(force)`
  end

  # Replace the current URL.
  #
  # @param url [String] the URL to go to
  def replace(url)
    `#@native.replace(#{url.to_s})`
  end

  # Convert the location to a string.
  def to_s
    `#@native.toString()`
  end

  # @!attribute fragment
  # @return [String] the hash fragment of the location URI
  alias_native :fragment, :hash
  alias_native :fragment=, :hash=

  # @!attribute host
  # @return [String] the host part of the location URI
  alias_native :host
  alias_native :host=

  # @!attribute uri
  # @return [String] the whole location URI
  alias_native :uri, :href
  alias_native :uri=, :href=

  # @!attribute path
  # @return [String] the path part of the location URI
  alias_native :path, :pathname
  alias_native :path=, :pathname=

  # @!attribute port
  # @return [Integer] the port part of the location URI
  alias_native :port
  alias_native :port=

  # @!attribute scheme
  # @return [String] the scheme part of the location URI
  alias_native :scheme, :protocol
  alias_native :scheme=, :protocol=

  # @!attribute query
  # @return [String] the query part of the location URI
  alias_native :query, :search
  alias_native :query=, :search=
end

end
