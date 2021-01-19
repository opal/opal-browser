require 'bundler'
Bundler.require

require 'opal/rspec/rake_task'

# Must set the runner to chrome as after all we need a browser to test
# this stuff.

ENV['RUNNER'] = 'chrome'

# this is specified here rather than in spec helper as
# setting the format will cause problems when running in the
# browser (i.e. via rackup)

ENV['SPEC_OPTS'] = '--format documentation' 

Opal::RSpec::RakeTask.new(:default) do |_, task|
  task.default_path = 'spec'
  task.pattern = 'spec/**/*_spec.{rb,opal}'
end
