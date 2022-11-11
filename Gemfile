source 'https://rubygems.org'
gemspec

# specs
gem 'rake'
gem 'rack'
gem 'sinatra'
gem 'sinatra-websocket'
case ENV['OPAL_RSPEC_VERSION']
when nil
  gem 'opal-rspec'
when /\./
  gem 'opal-rspec', "~> #{ENV['OPAL_RSPEC_VERSION']}.0a"
end
gem 'opal-sprockets'
# Force build of eventmachine... I wish we could find a way to not use
# this unmaintained library anymore.
gem 'eventmachine', github: 'eventmachine/eventmachine'
gem 'thin', github: 'macournoyer/thin' unless RUBY_PLATFORM =~ /mingw/

# runner
gem 'selenium-webdriver', require: false
gem 'rest-client', require: false
gem 'webdrivers', require: false
gem 'rexml', require: false
gem 'ffi'

# browser
case ENV['OPAL_VERSION']
when nil
  # noop
when ->(path) { File.exist? path }
  gem 'opal', path: ENV['OPAL_VERSION']
when /\./
  gem 'opal', "~> #{ENV['OPAL_VERSION']}.0a"
else
  gem 'opal', github: 'opal/opal', ref: ENV['OPAL_VERSION']
end

