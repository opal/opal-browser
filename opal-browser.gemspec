require_relative 'opal/browser/version'

Gem::Specification.new do |spec|
  spec.name     = 'opal-browser'
  spec.version  = Browser::VERSION
  spec.author   = ['meh.', 'hmdne']
  spec.email    = 'meh@schizofreni.co'
  spec.homepage = 'http://github.com/opal/opal-browser'
  spec.platform = Gem::Platform::RUBY
  spec.summary  = 'Browser support for Opal.'
  spec.license  = 'MIT'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  # Remove symlinks because Windows doesn't always support them.
  files = Dir.chdir(__dir__) { `git ls-files -z`.split("\x0") }.reject(&File.method(:symlink?))

  spec.files         = files.grep(%r{^(test|spec|features)/})
  spec.test_files    = files.grep_v(%r{^(test|spec|features)/})
  spec.executables   = files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.bindir        = 'exe'
  spec.require_paths = ['lib']

  spec.add_dependency 'opal', ['>= 1.0', '< 2.0']
  spec.add_dependency 'paggio', '>= 0.3.0'
end
