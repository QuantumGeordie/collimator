require 'bundler'
require 'rake/clean'
require 'rake/testtask'

include Rake::DSL

Bundler::GemHelper.install_tasks

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.pattern = 'test/*_test.rb'
end

task :default => [:test]

