# frozen_string_literal: true

require 'bundler'
Bundler.require
require 'opal/rspec/rake_task'
require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

# a few specs require a "real DOM" and/or a server response, so these
# specs are run using the hyper-spec gem.  These specs are marked with
# the server_side_test tag.

# The remaining specs can be run using opal-rspec

# All the specs will run in the browser using opal-rspec:
# just run bundle exec rackup, and browse localhost:9292

# See spec/spec_helper.rb, spec/app.rb, and config.ru for more details

RSpec::Core::RakeTask.new(:server_and_client_specs) do |t|
  t.rspec_opts = '--tag js'
  t.pattern = 'spec/http_spec.rb,spec/native_cached_wrapper_spec.rb,spec/canvas/**/*_spec.rb'
end

require "webdrivers"
load 'webdrivers/Rakefile'

Opal::RSpec::RakeTask.new(:opal_rspec_runner) do |_, task|
  task.default_path = 'spec'
  task.pattern = 'spec/**/*_spec.{rb,opal}'
end

task :client_only_specs do
  # Must set the runner to chrome as after all we need a browser to test
  # this stuff.
  #
  # Also can't see how to set the format to progress and exclude the js tags
  # except by setting it up via SPEC_OPTS enviroment var and a require file
  sh 'RUNNER=chrome '\
     "SPEC_OPTS='--format progress --require exclude_requires_server' "\
     'rake opal_rspec_runner'
end

task default: %i[client_only_specs server_and_client_specs] do
end
