require 'spec_helper'

describe "Service URI Helper" do

  it "should define corret URI for valid geometry service" do
     RGis::Helper::ServiceHelper.service_uri('http://sampleserver1.arcgisonline.com/ArcGIS/rest/services', :geometry_service).should == 'http://sampleserver1.arcgisonline.com/ArcGIS/rest/services/Geometry/GeometryServer'
  end

  it "should raise argument exception for invalid service type" do
    lambda {
      RGis::Helper::ServiceHelper.service_uri('http://www.foo.com', :invalid)
    }.should raise_error("invalid service type")
  end

  it "should return the correct geometry service name" do
    RGis::Helper::ServiceHelper.service_name('http://sampleserver1.arcgisonline.com/ArcGIS/rest/services', :geometry_service).should == 'Geometry'
  end

end
