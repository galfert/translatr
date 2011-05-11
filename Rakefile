require 'bundler'
require 'rspec/core/rake_task'

load 'lib/tasks/translatr.rake'

Bundler::GemHelper.install_tasks

RSpec::Core::RakeTask.new('spec')
task :default => :spec
