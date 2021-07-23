# See: https://github.com/hmdne/roda-sprockets/issues/1

if ENV['RACK_ENV'] != 'production'
  require 'rack/lint'

  module Rack::Lint::Assertion
    def assert message
      unless yield
        puts "Rack::Lint error: #{message}"
      end
    end
  end
end
