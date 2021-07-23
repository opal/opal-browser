source 'https://rubygems.org'
gemspec

# specs
gem 'rake'
gem 'rack'
gem 'sinatra'
gem 'sinatra-websocket'
# For opal-rspec, a release is needed
gem 'opal-rspec', github: 'opal/opal-rspec', submodules: true # '>= 0.8.0.alpha1'
gem 'opal-sprockets'
# Force build of eventmachine on Windows
gem 'eventmachine', github: 'eventmachine/eventmachine' if RUBY_PLATFORM =~ /mingw/


# runner
gem 'selenium-webdriver', require: false
gem 'rest-client', require: false
gem 'webdrivers', github: 'hmdne/webdrivers', require: false
gem 'rexml', require: false

# browser
case ENV['OPAL_VERSION']
when nil
when 'master'
  gem 'opal', github: 'opal/opal'
else
  gem 'opal', "~> #{ENV['OPAL_VERSION']}"
end
# At this time, we need to use a branch. Please see:
# https://github.com/meh/paggio/issues/7
gem 'paggio', github: 'hmdne/paggio'
