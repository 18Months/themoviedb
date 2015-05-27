# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require "themoviedb/version"

Gem::Specification.new do |s|
  s.name        = "themoviedb"
  s.version     = Tmdb::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Ahmet Abdi"]
  s.email       = ["ahmetabdi@gmail.com"]
  s.homepage    = "http://rubygems.org/gems/themoviedb"
  s.summary     = %q{A Ruby wrapper for the The Movie Database API.}
  s.description = %q{Provides a simple, easy to use interface for the Movie Database API.}
  s.rubyforge_project = "themoviedb"

  s.files         = `git ls-files`.split($/)
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = %w[lib]

  s.add_runtime_dependency 'httparty', '~> 0.11.0'
  s.add_runtime_dependency 'activesupport', '~> 4.0.3'

  s.add_development_dependency 'vcr',     '~> 2.8.0'
  s.add_development_dependency 'rake',    '~> 10.0'
  s.add_development_dependency 'rspec',   '~> 2.14'
  s.add_development_dependency 'webmock', '~> 1.15.0'
end
