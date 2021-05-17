source 'https://rubygems.org'
gemspec

# specs
gem 'rake'
gem 'rack'
gem 'sinatra'
gem 'sinatra-websocket'
gem 'opal-rspec', '>= 0.8.0.alpha1'
if File.exist? "../opal-sprockets"
  gem 'opal-sprockets', path: "../opal-sprockets"
else
  gem 'opal-sprockets'
end

# runner
gem 'selenium-webdriver', require: false
gem 'rest-client', require: false

# browser
gem 'opal', ['>= 1.0', '< 2.0']
if File.exist? "../paggio"
  gem 'paggio', path: '../paggio'
else
  gem 'paggio', github: 'hmdne/paggio'
end
