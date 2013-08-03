require 'browser/http/binary'
require 'browser/http/headers'
require 'browser/http/request'
require 'browser/http/response'

module Browser

module HTTP
  def self.send(method, url, data = nil, &block)
    Request.new(&block).open(method, url).send(data)
  end

  def self.get(url, &block)
    send(:get, url, &block)
  end

  def self.head(url, &block)
    send(:head, url, &block)
  end

  def self.post(url, data = nil, &block)
    send(:post, url, data, &block)
  end

  def self.put(url, data = nil, &block)
    send(:put, url, data, &block)
  end

  def self.delete(url, data = nil, &block)
    send(:delete, url, data, &block)
  end

  def self.send!(method, url, data = nil, &block)
    Request.new(&block).open(method, url, false).send(data)
  end

  def self.get!(url, &block)
    send!(:get, url, &block)
  end

  def self.head!(url, &block)
    send!(:head, url, &block)
  end

  def self.post!(url, data = nil, &block)
    send!(:post, url, data, &block)
  end

  def self.put!(url, data = nil, &block)
    send!(:put, url, data, &block)
  end

  def self.delete!(url, data = nil, &block)
    send!(:delete, url, data, &block)
  end
end

end
