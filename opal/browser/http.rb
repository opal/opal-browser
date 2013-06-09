require 'browser/http/binary'
require 'browser/http/headers'
require 'browser/http/parameters'
require 'browser/http/request'
require 'browser/http/response'

module Browser

module HTTP
  def self.get(url, &block)
    Request.open(:get, url, &block)
  end

  def self.head(url, &block)
    Request.open(:head, url, &block)
  end

  def self.post(url, &block)
    Request.open(:post, url, &block)
  end
end

end
