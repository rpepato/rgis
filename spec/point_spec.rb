require 'spec_helper'   

describe 'Point Geometry' do

  before (:each) do
    RGis::Services::ServiceDirectory.uri = "http://sampleserver1.arcgisonline.com/ArcGIS/rest/services"
  end

  it "should points with equals [x,y] be compared as equals" do
    RGis::Point.new(15,17).should == RGis::Point.new(15,17)
  end
  
  it "should convert a point to a json representation expected by esri api" do
    json = '{"geometryType":"esriGeometryPoint","geometries":[{"x":15.0,"y":17.0}]}'    
    point = RGis::Point.new(15,17)
    point.to_json.should == json    
  end

  it "should project a point from one spatial reference to another and return a new point" do
    point = RGis::Point.new(15,17)
    another_point = RGis::Point.new(1669792.3618991, 1920825.04037747)
    point.project(:from => 4326, :to => 102100).should == another_point
    another_point.project(:from => 102100, :to => 4326).should == point
  end
  
  it "should change x and y atrributes from a point when reprojected" do
    point = RGis::Point.new(15,17)
    point.project!(:from => 4326, :to => 102100)
    point.x.should == 1669792.3618991
    point.y.should == 1920825.04037747
  end
  
end


