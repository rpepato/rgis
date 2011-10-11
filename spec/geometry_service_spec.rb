require 'spec_helper'   

describe "Lookup details from arcgis rest directory services" do
  
  before (:each) do
    @gs = RGis::GeometryService.new('http://sampleserver1.arcgisonline.com/ArcGIS/rest/services')
  end

  it "should initialize a geometry service from a uri" do
    @gs.uri.should == 'http://sampleserver1.arcgisonline.com/ArcGIS/rest/services/Geometry/GeometryServer'
  end

  it "should initialize a geometry service from a uri with slash in the end of service name" do
    gs = RGis::GeometryService.new('http://sampleserver1.arcgisonline.com/ArcGIS/rest/services/')
    gs.uri.should == 'http://sampleserver1.arcgisonline.com/ArcGIS/rest/services/Geometry/GeometryServer'
  end

  it "should reproject a point from 4326 SR to 102113" do
    @gs.project(4326, 102113, :point => [19.109209, 34.1928918184256]).geometries.should =~ [{'x' => 2127227.41534224, 'y' => 4054732.18582985}]
    @gs.project(4326, 102113, :point => [[19.109209, 34.1928918184256]]).geometries.should =~ [{'x' => 2127227.41534224, 'y' => 4054732.18582985}]
  end
  
  it "should simplify geometries in 4326 projection" do                                           
     geometry = {
        :geometryType => RGis::Helper::GEOMETRY_TYPES[:point],
        :geometries => [
          {:x => -104.53, :y => 34.74},
          {:x => -63.53, :y => 10.23}
          ]
      }
    @gs.simplify(4326, geometry).geometries.should =~ [{'x' => -104.53, 'y' => 34.74}, {'x' => -63.53, 'y' => 10.23}]
  end                
end
