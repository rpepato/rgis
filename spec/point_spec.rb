require 'spec_helper'   

describe 'Point Geometry' do

  before (:each) do
    RGis::Services::ServiceDirectory.uri = "http://sampleserver1.arcgisonline.com/ArcGIS/rest/services"
  end

  it "should points with equals [x,y] be compared as equals" do
    RGis::Point.new(15,17).should == RGis::Point.new(15,17)
  end

  it "should project a point from 4326 to 102100 spatial reference" do
    point = RGis::Point.new(15,17)
    another_point = RGis::Point.new(1669792.3618991, 1920825.04037747)
    point.project(:from => 4326, :to => 102100).should == another_point
    another_point.project(:from => 102100, :to => 4326).should == point
  end
end


