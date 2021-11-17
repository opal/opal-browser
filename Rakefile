require 'bundler'
Bundler.require
require 'bundler/gem_tasks'

require 'webdrivers'
load 'webdrivers/Rakefile'

require 'opal/rspec/rake_task'
Opal::RSpec::RakeTask.new(:broken_rspec) do |_, task|
  task.default_path = 'spec'
  task.pattern = 'spec/**/*_spec.{rb,opal}'
end

task(:nil) {}

%w[chrome edge gecko safari].each do |i|
  dependency = nil
  if %w[chrome edge gecko].include? i
    dependency = "webdrivers:#{i}driver:update"
  end
  desc "Run Selenium tests with #{i}"
  task :"selenium_#{i}" => dependency do
    server = Process.spawn("bundle", "exec", "rackup")
    at_exit { Process.kill(9, server) rescue nil }
    sleep 2
    ENV['BROWSER'] = i
    load 'spec/runner.rb'
  ensure
    Process.kill(9, server) rescue nil
  end
end

task :default => :selenium_chrome