require 'bundler'
Bundler.require

require 'opal/rspec/rake_task'

# Must set the runner to chrome as after all we need a browser to test
# this stuff.

ENV['RUNNER'] = 'chrome'

# this is specified here rather than in spec helper as
# setting the format will cause problems when running in the
# browser (i.e. via rackup)

# we also require the exclude_requires_server which will turn off the specs
# needing to fetch files from the server, which ATM I don't know how to implement
# within Opal spec

ENV['SPEC_OPTS'] = '--format documentation --require exclude_requires_server'

Opal::RSpec::RakeTask.new(:client_side_only) do |_, task|
  task.default_path = 'spec'
  task.pattern = 'spec/**/*_spec.{rb,opal}'
end
