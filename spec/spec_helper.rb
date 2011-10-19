$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'rspec'
require 'rgis'
require 'rgis/geometry_service'
require 'rgis/point'
require 'rgis/polygon'
require 'rgis/polyline'
require 'rgis/path'
require 'rgis/ring'
require 'rgis/lookup'
require 'rgis/helper'
require 'rgis/services/service_directory'


# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  
end
