require 'spec_helper'

describe 'Singleton Service' do

  before(:each) do
    RGis::Services::ServiceDirectory.uri = "http://www.foo.bar"
  end

  it "should raise an exception when calling instance before a base uri" do    
    lambda {RGis::Services::ServiceDirectory.uri = ""}.should raise_error(ArgumentError, "You should set a valid uri")    
  end

  it "should obtain the correct geometry service address" do
    RGis::Services::ServiceDirectory.uri = "http://sampleserver1.arcgisonline.com/ArcGIS/rest/services"
    VCR.use_cassette('geometry_service_uri', :record => :new_episodes) do
      RGis::Services::ServiceDirectory.geometry_service_uri.should == "http://sampleserver1.arcgisonline.com/ArcGIS/rest/services/Geometry/GeometryServer"
    end
  end

end

