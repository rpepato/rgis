require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Lookup details from arcgis rest directory services" do

  it "version should be 10.01" do
    RGis.version_at('http://sampleserver1.arcgisonline.com/ArcGIS/rest/services/?f=json').should == 10.01
  end

  it "should have 10 services available" do
    RGis.services_at('http://sampleserver1.arcgisonline.com/ArcGIS/rest/services/?f=json').count.should == 10
  end

  it "should return a Geometry Service from ArcGIS" do
    RGis.geometry_service('http://sampleserver1.arcgisonline.com/ArcGIS/rest/services/?f=json').should == "Geometry"
  end

  it "should return a true when a geometry service exists" do
    RGis.has_geometry_service?('http://sampleserver1.arcgisonline.com/ArcGIS/rest/services/?f=json').should == true
  end
  
  it "should reproject a point from 4326 SR to 102113" do
    RGis.project('http://sampleserver1.arcgisonline.com/ArcGIS/rest/services/Geometry/GeometryServer', 4326, 102113, :point => { :x => -117, :y => 34 })
  end

end
