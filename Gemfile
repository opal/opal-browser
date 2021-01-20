source 'https://rubygems.org'

# specs
gem 'rake'
gem 'rack'
gem 'sinatra'
gem 'sinatra-websocket'
gem 'opal-rspec', '>= 0.8.0.alpha1'
gem 'opal-sprockets'

# runner
gem 'selenium-webdriver', require: false
gem 'rest-client', require: false

# browser
gem 'opal', ['>= 1.0', '< 2.0']
gem 'paggio', github: 'meh/paggio'

# hyper-spec (for testing http requests)
git 'https://github.com/hyperstack-org/hyperstack.git', branch: 'edge', glob: 'ruby/*/*.gemspec' do
  gem 'hyper-spec'
end

gemspec
