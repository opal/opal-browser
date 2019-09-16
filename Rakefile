require 'bundler'
Bundler.require

require 'opal/rspec/rake_task'
Opal::RSpec::RakeTask.new(:default) do |_, task|
  task.default_path = 'spec'
  task.pattern = 'spec/**/*_spec.{rb,opal}'
end