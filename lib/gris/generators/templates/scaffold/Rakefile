#!/usr/bin/env rake
require File.expand_path('../config/boot', __FILE__)

Dir.glob('./lib/tasks/*.rake').each { |r| import r }

if Gris.env.development? || Gris.env.test?
  require 'rspec/core/rake_task'
  require 'rubocop/rake_task'
  RSpec::Core::RakeTask.new

  desc 'Run RuboCop'
  RuboCop::RakeTask.new(:rubocop) do |task|
    task.fail_on_error = true
    task.options = %w(-D --auto-correct)
  end

  task default: [:rubocop, :spec]
end
