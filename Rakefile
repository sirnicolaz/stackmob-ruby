# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "stackmob"
  gem.homepage = "http://github.com/stackmob/stackmob-heroku"
  gem.license = "MIT"
  gem.summary = "Support Gem for StackMob Heroku Add-On"
  gem.description = "Support Gem for StackMob Heroku Add-On"
  gem.email = "jordan@stackmob.com"
  gem.authors = ["StackMob"]
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
require 'rcov/rcovtask'
namespace :test do
 
  
  Rake::TestTask.new(:unit) do |test|
    test.libs << 'lib' << 'test'
    test.pattern = 'test/unit/**/test_*.rb'
    test.verbose = true
  end		

  Rake::TestTask.new(:integration) do |test|
    test.libs << 'lib' << 'test'
    test.pattern = 'test/integration/**/test_*.rb'
    test.verbose = true
  end

  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/test_*.rb'
    test.verbose = true
    test.rcov_opts << '--exclude "gems/*"'
  end

  desc "Run Unit & Integration Tests"
  task :all => [:unit, :integration]
end

task :default => "test:all"

require 'yard'
YARD::Rake::YardocTask.new
