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

  s.add_dependency 'opal'
  s.add_dependency 'paggio'
}
