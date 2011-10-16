# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{fluent-plugin-couch}
  s.version = "0.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Yudai Odagiri}]
  s.date = %q{2011-10-16}
  s.email = %q{ixixizko@gmail.com}
  s.extra_rdoc_files = [
    "README.rdoc"
  ]
  s.files = [
    "AUTHORS",
    "Rakefile",
    "VERSION",
    "lib/fluent/plugin/out_couch.rb"
  ]
  s.homepage = %q{http://github.com/fluent}
  s.require_paths = [%q{lib}]
  s.rubygems_version = %q{1.8.7}
  s.summary = %q{CouchDB output plugin for Fluent event collector}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<fluentd>, ["~> 0.10.0"])
    else
      s.add_dependency(%q<fluentd>, ["~> 0.10.0"])
    end
  else
    s.add_dependency(%q<fluentd>, ["~> 0.10.0"])
  end
end

