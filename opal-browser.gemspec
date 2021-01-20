$LOAD_PATH << File.expand_path('../opal', __FILE__)
require 'browser/version'

Gem::Specification.new {|s|
  s.name     = 'opal-browser'
  s.version  = Browser::VERSION
  s.author   = 'meh.'
  s.email    = 'meh@schizofreni.co'
  s.homepage = 'http://github.com/opal/opal-browser'
  s.platform = Gem::Platform::RUBY
  s.summary  = 'Browser support for Opal.'
  s.license  = 'MIT'

  s.files         = `git ls-files`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = ['lib']

  s.add_dependency 'opal', ['>= 1.0', '< 2.0']
  s.add_dependency 'paggio'

  # s.add_development_dependency 'hyper-spec' # pulled in on the Gemfile as we need a specific version from github
  s.add_development_dependency 'rails', '~> 6.0'
  s.add_development_dependency 'opal-rails'
  s.add_development_dependency 'puma'
}
