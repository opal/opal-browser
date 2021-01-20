source 'https://rubygems.org'
gemspec

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
git 'git://github.com/hyperstack-org/hyperstack.git', branch: 'edge', glob: 'ruby/*/*.gemspec' do
  gem 'hyper-spec'
  gem 'hyper-component'
  gem 'hyper-store'
  gem 'hyper-state'
  gem 'hyperstack-config'
end

gemspec
