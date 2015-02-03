# -*- encoding: utf-8 -*-
require File.expand_path('../lib/gris/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = 'gris'
  s.version     = Gris::VERSION
  s.summary     = 'A simple api microservice generator.'
  s.description = 'Gris is a generator for Grape, Roar, Hypermedia, PG API apps.'
  s.email       = 'email@dylanfareed.com'
  s.homepage    = 'http://github.com/dylanfareed/gris/'
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

  s.add_dependency 'logging'
  s.add_dependency 'dotenv', '~> 1.0.2', '>= 1.0.2'
  s.add_dependency 'grape', '~> 0.10.1', '>= 0.10.1'
  s.add_dependency 'grape-roar', '~> 0.3.0', '>= 0.3.0'

  s.add_dependency 'grape-swagger', '~> 0.9.0', '>= 0.9.0'
  s.add_dependency 'roar', '~> 1.0.0', '>= 1.0.0'
  s.add_dependency 'racksh', '~> 1.0'

  s.add_development_dependency 'bundler', '~> 1.7.10', '>= 1.7.10'
  s.add_development_dependency 'rspec', '~> 3.1', '>= 3.1.0'
  s.add_development_dependency 'rubocop', '~> 0.28', '>= 0.28.0'
  s.add_development_dependency 'activerecord', '~> 4.2', '>= 4.2.0'
  s.add_development_dependency 'acts_as_fu', '~> 0'
end
