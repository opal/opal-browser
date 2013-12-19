Gem::Specification.new {|s|
  s.name         = 'opal-browser'
  s.version      = '0.1.0'
  s.author       = 'meh.'
  s.email        = 'meh@schizofreni.co'
  s.homepage     = 'http://github.com/opal/opal-browser'
  s.platform     = Gem::Platform::RUBY
  s.summary      = 'Browser support for Opal.'

  s.files         = `git ls-files`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = ['lib']

  s.add_dependency 'opal', ['>= 0.5.0', '< 1.0.0']
  s.add_dependency 'paggio'

  s.add_development_dependency 'opal-rspec'
  s.add_development_dependency 'rake'
}
