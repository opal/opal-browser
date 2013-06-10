require 'browser/http/binary'
require 'browser/http/headers'
require 'browser/http/parameters'
require 'browser/http/request'
require 'browser/http/response'

module Browser

module HTTP
  def self.get(url, &block)
    Request.new(&block).open(:get, url).send
  end

  def self.head(url, &block)
    Request.new(&block).open(:head, url).send
  end

  def self.post(url, data = nil, &block)
    Request.new(&block).open(:post, url).send(data)
  end

  def self.put(url, data = nil, &block)
    Request.new(&block).open(:put, url).send(data)
  end

  def self.delete(url, data = nil, &block)
    Request.new(&block).open(:delete, url).send(data)
  end
end

end
