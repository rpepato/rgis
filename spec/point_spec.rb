require 'spec_helper'   

describe 'Point Geometry' do

  before (:each) do
    RGis::Services::ServiceDirectory.uri = "http://sampleserver1.arcgisonline.com/ArcGIS/rest/services"
    @point = RGis::Point.new(-104.53, 34.74)
    @projected_point = RGis::Point.new(-11636226.3726209, 4128604.07739995)
  end

  it "should points with equals [x,y] be compared as equals" do
    @point.should == RGis::Point.new(-104.53, 34.74)
  end
  
  it "should convert a point to a json representation expected by esri api" do
    json = '{"geometryType":"esriGeometryPoint","geometries":[{"x":-104.53,"y":34.74}]}'    
    @point.to_json.should == json    
  end

  it "should project a point from one spatial reference to another and return a new point" do
    VCR.use_cassette('point_project', :record => :new_episodes) do
      @point.project(:from => 4326, :to => 102113).should == @projected_point
      @projected_point.project(:from => 102113, :to => 4326).should == @point
    end
  end
  
  it "should change x and y atrributes from a point when reprojected" do
    VCR.use_cassette('point_project_bang', :record => :new_episodes) do
      @point.project!(:from => 4326, :to => 102113)
      @point.x.should == -11636226.3726209
      @point.y.should == 4128604.07739995
    end
  end
  
  it "should simplify a point" do
    VCR.use_cassette('point_simplify', :record => :new_episodes) do
      @point.simplify(:spatial_reference => 4326).should == @point
    end
  end
  
  it "should calculate a buffer for a point" do
    VCR.use_cassette('point_buffer', :record => :new_episodes) do
      point = RGis::Point.new(15,17)
      ring = RGis::Ring.new()
      ring.points << RGis::Point.new(-11636226.3726209, 4128604.08044796)
      ring.points << RGis::Point.new(-11636226.3699812, 4128604.07892395)
      ring.points << RGis::Point.new(-11636226.3699812, 4128604.07587595)
      ring.points << RGis::Point.new(-11636226.3726209, 4128604.07435194)
      ring.points << RGis::Point.new(-11636226.3752605, 4128604.07587595)
      ring.points << RGis::Point.new(-11636226.3752605, 4128604.07892395)
      ring.points << RGis::Point.new(-11636226.3726209, 4128604.08044796)
      polygon = RGis::Polygon.new()
      polygon.rings << ring

      @point.buffer( :input_spatial_reference => 4326,
                    :output_spatial_reference => 102100,
                    :buffer_spatial_reference => 102100,
                    :distances => 0.01,
                    :distance_units => RGis::Helper::UNIT_TYPES[:survey_foot],
                    :union_results => false).should == polygon
    end
  end
  
  it "should raise an exception when area_and_perimeter method is called" do
    VCR.use_cassette('point_area_and_perimeter', :record => :new_episodes) do
      lambda{@point.area_and_perimeter(nil)}.should raise_error(TypeError, "Area and perimeter operation is allowed only for polygon type")
    end
  end

end


