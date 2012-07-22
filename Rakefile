require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

desc 'Default: run unit tests.'
task :default => :test

task :environment do
  plugin_dir = "#{File.dirname(__FILE__)}/.."
  rails_root = "#{plugin_dir}/../../"
  require(File.join(rails_root, 'config', 'environment'))
end

desc 'Test the pathfinder_common plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

#task :test => :environment

desc 'Generate documentation for the pathfinder_common plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'PathfinderCommon'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
