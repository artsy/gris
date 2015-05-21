# -*- encoding: utf-8 -*-
require File.expand_path('../lib/gris/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = 'gris'
  s.version     = Gris::VERSION
  s.summary     = 'A simple api microservice generator framework.'
  s.description = 'Gris is a generator for Grape, Roar, Hypermedia, PG API apps.'
  s.email       = 'email@dylanfareed.com'
  s.homepage    = 'http://github.com/artsy/gris/'
  s.authors     = ['Dylan Fareed']
  s.licenses    = 'MIT-LICENSE'

  s.files         = `git ls-files`.split($OUTPUT_RECORD_SEPARATOR)
  s.executables   << 'gris'
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.name          = 'gris'
  s.require_paths = ['lib']
  s.required_ruby_version = '>= 2.1.5'

  s.add_runtime_dependency 'thor', '~> 0.19', '>= 0.19.1'
  s.add_runtime_dependency 'activesupport', '~> 4.2', '>= 4.2.0'
  s.add_runtime_dependency 'rake', '~> 10.4', '>= 10.4.2'
  s.add_runtime_dependency 'git', '~> 1.2', '>= 1.2.8'
  s.add_runtime_dependency 'dotenv', '~> 2.0', '>= 2.0'
  s.add_runtime_dependency 'logging', '~> 2.0'
  s.add_runtime_dependency 'grape', '~> 0.11.0', '>= 0.11.0'
  s.add_runtime_dependency 'grape-roar', '~> 0.3.0', '>= 0.3.0'
  s.add_runtime_dependency 'grape-swagger', '~> 0.10.0'
  s.add_runtime_dependency 'roar', '~> 1.0.1'
  s.add_runtime_dependency 'racksh', '~> 1.0'
  s.add_runtime_dependency 'hashie-forbidden_attributes', '~> 0.1.0'
  s.add_runtime_dependency 'chronic', '~> 0.10.0'
  s.add_runtime_dependency 'dalli', '~> 2.7'

  s.add_development_dependency 'bundler'
  s.add_development_dependency 'rspec', '~> 3.2'
  s.add_development_dependency 'rubocop', '~> 0.29'
  s.add_development_dependency 'activerecord', '~> 4.2'
  s.add_development_dependency 'acts_as_fu', '~> 0'
end
