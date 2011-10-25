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
    VCR.use_cassette('point_project', :record => :new_episodes) do
      point = RGis::Point.new(15,17)
      another_point = RGis::Point.new(1669792.3618991, 1920825.04037747)
      point.project(:from => 4326, :to => 102100).should == another_point
      another_point.project(:from => 102100, :to => 4326).should == point
    end
  end
  
  it "should change x and y atrributes from a point when reprojected" do
    VCR.use_cassette('point_project_bang', :record => :new_episodes) do
      point = RGis::Point.new(15,17)
      point.project!(:from => 4326, :to => 102100)
      point.x.should == 1669792.3618991
      point.y.should == 1920825.04037747
    end
  end
  
  it "should simplify a point" do
    VCR.use_cassette('point_simplify', :record => :new_episodes) do
      point = RGis::Point.new(15,17)
      point.simplify(:spatial_reference => 4326).should == point
    end
  end
  
  it "should calculate a buffer for a point" do
    VCR.use_cassette('point_buffer', :record => :new_episodes) do
      point = RGis::Point.new(15,17)
      ring = RGis::Ring.new()
      ring.points << RGis::Point.new(1669792.3618991, 1920825.04342547)
      ring.points << RGis::Point.new(1669792.36453875, 1920825.04190147)
      ring.points << RGis::Point.new(1669792.36453875, 1920825.03885346)
      ring.points << RGis::Point.new(1669792.3618991, 1920825.03732946)
      ring.points << RGis::Point.new(1669792.35925945, 1920825.03885346)
      ring.points << RGis::Point.new(1669792.35925945, 1920825.04190147)
      ring.points << RGis::Point.new(1669792.3618991, 1920825.04342547)
      polygon = RGis::Polygon.new()
      polygon.rings << ring

      point.buffer( :input_spatial_reference => 4326,
                    :output_spatial_reference => 102100,
                    :buffer_spatial_reference => 102100,
                    :distances => 0.01,
                    :distance_units => RGis::Helper::UNIT_TYPES[:survey_foot],
                    :union_results => false).should == polygon
    end
  end

end


