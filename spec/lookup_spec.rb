require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

require 'rgis'

describe "Lookup services from ArcGIS" do
  it "should connect to arcgis service directory" do
    RGis.at('http://sampleserver1.arcgisonline.com/ArcGIS/rest/services/?f=json').should_not be_nil
  end
end
