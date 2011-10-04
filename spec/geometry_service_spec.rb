require 'spec_helper'

describe "Lookup details from arcgis rest directory services" do

  it "should initialize a geometry service from a uri" do
    gs = RGis::GeometryService.new('http://sampleserver1.arcgisonline.com/ArcGIS/rest/services')
    gs.uri.should == 'http://sampleserver1.arcgisonline.com/ArcGIS/rest/services/Geometry/GeometryServer'
  end


  it "should reproject a point from 4326 SR to 102113" do
    gs = RGis::GeometryService.new('http://sampleserver1.arcgisonline.com/ArcGIS/rest/services')
    gs.project(4326, 102113, [19.109209, 34.1928918184256]).geometries.should =~ [{'x' => 2127227.41534224, 'y' => 4054732.18582985}]
    gs.project(4326, 102113, [[19.109209, 34.1928918184256]]).geometries.should =~ [{'x' => 2127227.41534224, 'y' => 4054732.18582985}]
  end
end
