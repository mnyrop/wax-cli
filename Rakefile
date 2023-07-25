# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'reek/rake/task'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

begin
  RSpec::Core::RakeTask.new :spec
  Reek::Rake::Task.new :reek
  RuboCop::RakeTask.new :rubocop

  desc 'run rspec, rake, and reek'
  task :test do
    Rake::Task['spec'].invoke
    Rake::Task['rubocop'].invoke
    Rake::Task['reek'].invoke
  end

  task default: :test
end
