require 'rake'
require 'rake/testtask'
require 'rake/clean'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "fluent-plugin-couch-sharded"
    gemspec.summary = "CouchDB output plugin for Fluentd event collector, forked to add 'sharding' features"
    gemspec.author = "Yudai Odagiri, James Birmingham"
    gemspec.email = "ixixizko@gmail.com"
    gemspec.homepage = "http://github.com/jimflip/fluent-plugin-couch-shard"
    gemspec.has_rdoc = false
    gemspec.require_paths = ["lib"]
    gemspec.add_dependency "fluentd", "~> 0.10.0"
    gemspec.add_dependency "couchrest", "~> 1.1.2"
    gemspec.add_dependency "jsonpath", "~> 0.4.2"

    gemspec.files = Dir["lib/**/*"] + %w[VERSION AUTHORS Rakefile]
    gemspec.executables = []
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler not available. Install it with: gem install jeweler"
end

Rake::TestTask.new(:test) do |t|
  t.test_files = Dir['test/*_test.rb']
  t.ruby_opts = ['-rubygems'] if defined? Gem
  t.ruby_opts << '-I.'
end

task :default => [:build]
