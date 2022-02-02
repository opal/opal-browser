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

task :build_gh_pages do
  require 'fileutils'

  output_dir = __dir__+"/gh-pages/examples/"
  FileUtils.mkdir_p output_dir

  Dir['examples/*'].reject { |i| i =~ /integrations|svg/ }.each do |example_path|
    example = File.basename(example_path)

    output_example_dir = output_dir+"/"+example
    FileUtils.mkdir_p output_example_dir

    Dir.chdir(example_path) do
      Bundler.with_unbundled_env do
        `bundle install`
        `bundle exec opal -qopal-browser -c app/application.rb > #{output_example_dir}/app.js`
      end
      File.write("#{output_example_dir}/index.html", <<~HTML)
        <!DOCTYPE html>
        <html>
          <head></head>
          <body>
            <script src="app.js"></script>
          </body>
        </html>
      HTML
    end
  end
end