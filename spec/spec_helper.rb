require 'simplecov'
SimpleCov.start

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'rspec'
require 'vcr'
require 'rgis/point'
require 'rgis/envelope'
require 'rgis/polygon'
require 'rgis/polyline'
require 'rgis/path'
require 'rgis/multipoint'
require 'rgis/ring'
require 'rgis/lookup'
require 'rgis/helper'
require 'rgis/services/service_directory'


# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  config.extend VCR::RSpec::Macros
end

VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/cassette'
  c.hook_into :fakeweb
  c.default_cassette_options = { :record => :none }
  c.allow_http_connections_when_no_cassette = false
end
