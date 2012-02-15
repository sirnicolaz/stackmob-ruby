require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'minitest/unit'
require 'mocha'
require 'yajl'
require 'httpclient'

Dir[File.expand_path("support/*.rb", File.dirname(__FILE__))].each do |file|
  require file
end


$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'stackmob'
require 'stackmob/deployer' # include deployer explicitly for testing purposes since its not required by default


class MiniTest::Unit::TestCase
end



MiniTest::Unit.autorun
