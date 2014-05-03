# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "fluent-plugin-couch-sharded"
  s.version = "0.6.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Yudai Odagiri, James Birmingham"]
  s.date = "2014-05-03"
  s.email = "ixixizko@gmail.com"
  s.extra_rdoc_files = [
    "README.rdoc"
  ]
  s.files = [
    "AUTHORS",
    "Rakefile",
    "VERSION",
    "lib/fluent/plugin/out_couch.rb"
  ]
  s.homepage = "http://github.com/jimflip/fluent-plugin-couch-shard"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.25"
  s.summary = "CouchDB output plugin for Fluentd event collector, forked to add 'sharding' features"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rake>, [">= 0"])
      s.add_runtime_dependency(%q<jeweler>, [">= 0"])
      s.add_runtime_dependency(%q<rspec>, [">= 0"])
      s.add_runtime_dependency(%q<fluentd>, ["~> 0.10.0"])
      s.add_runtime_dependency(%q<couchrest>, ["~> 1.1.2"])
      s.add_runtime_dependency(%q<jsonpath>, ["~> 0.4.2"])
    else
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<jeweler>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<fluentd>, ["~> 0.10.0"])
      s.add_dependency(%q<couchrest>, ["~> 1.1.2"])
      s.add_dependency(%q<jsonpath>, ["~> 0.4.2"])
    end
  else
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<jeweler>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<fluentd>, ["~> 0.10.0"])
    s.add_dependency(%q<couchrest>, ["~> 1.1.2"])
    s.add_dependency(%q<jsonpath>, ["~> 0.4.2"])
  end
end

