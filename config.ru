require 'bundler'
Bundler.require
require './spec/app'

apps = []

sprockets_env = Opal::RSpec::SprocketsEnvironment.new(spec_pattern         = 'spec/**/*_spec.{rb,opal}',
                                                      spec_exclude_pattern = nil,
                                                      spec_files           = nil,
                                                      default_path         = 'spec')

apps << Opal::Sprockets::Server.new(sprockets: sprockets_env) { |s|
  s.main = 'opal/rspec/sprockets_runner'
  s.append_path 'spec'
  s.index_path = 'index.html.erb'
  s.debug = false
}

apps << app
run Rack::Cascade.new(apps)
