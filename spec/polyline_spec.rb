require 'spec_helper'

describe 'Polyline Geometry' do
  
  before (:each) do
    RGis::Services::ServiceDirectory.uri = "http://sampleserver1.arcgisonline.com/ArcGIS/rest/services"
  end
  
  it "should compare equal polylines" do 
    polyline = RGis::Polyline.new()
    path = RGis::Path.new()
    path.points << RGis::Point.new(2,3) << RGis::Point.new(7,8)
    
    another_polyline = RGis::Polyline.new()
    another_path = RGis::Path.new()
    another_path.points << RGis::Point.new(2,3) << RGis::Point.new(7,8)
    
    polyline.should == another_polyline
  end
  
  it "should convert a polyline to a json representation expected by esri api" do
    json = '{"geometryType":"esriGeometryPolyline","geometries":[{"paths":[[[2.0,2.0],[4.0,4.0]]]}]}'    
    path = RGis::Path.new()
    path.points << RGis::Point.new(2,2) << RGis::Point.new(4,4)
    polyline = RGis::Polyline.new()
    polyline.paths << path
    polyline.to_json.should == json    
  end
  
  it "should project a polyline from one spatial reference to another and return a new polyline" do
    VCR.use_cassette('polyline_project', :record => :new_episodes) do
      path = RGis::Path.new()
      path.points << RGis::Point.new(2,2) << RGis::Point.new(4,4)
      polyline = RGis::Polyline.new()
      polyline.paths << path

      another_path = RGis::Path.new()
      another_path.points << RGis::Point.new(222638.981586547,222684.208505545) << RGis::Point.new(445277.963173094,445640.109656027)
      another_polyline = RGis::Polyline.new()
      another_polyline.paths << another_path

      polyline.project(:from => 4326, :to => 102100).should == another_polyline    
    end
  end  
  
  it "should change points from a polyline when reprojected" do
    VCR.use_cassette('polyline_project_bang', :record => :new_episodes) do
      path = RGis::Path.new()
      path.points << RGis::Point.new(2,2) << RGis::Point.new(4,4)
      polyline = RGis::Polyline.new()
      polyline.paths << path    
      polyline.project!(:from => 4326, :to => 102100)

      polyline.paths[0].points[0].should == RGis::Point.new(222638.981586547,222684.208505545)
      polyline.paths[0].points[1].should ==  RGis::Point.new(445277.963173094,445640.109656027)
    end
  end
  
  it "should simplify a polyline" do
    VCR.use_cassette('polyline_simplify', :record => :new_episodes) do
      path = RGis::Path.new()
      path.points << RGis::Point.new(2,2) << RGis::Point.new(4,4)
      polyline = RGis::Polyline.new()
      polyline.paths << path    
      polyline.simplify(:spatial_reference => 4326).should == polyline
    end
  end
  
  it "should calculate a buffer for a polyline" do
    VCR.use_cassette('polyline_buffer', :record => :new_episodes) do
      ring = RGis::Ring.new()
      ring.points << RGis::Point.new(222638.983399998, 222684.2062)
      ring.points << RGis::Point.new(222638.981899999, 222684.205499999)
      ring.points << RGis::Point.new(222638.979899999, 222684.206099998)
      ring.points << RGis::Point.new(222638.978700001, 222684.208000001)
      ring.points << RGis::Point.new(222638.9791, 222684.210200001)
      ring.points << RGis::Point.new(445277.9617, 445640.112300001)
      ring.points << RGis::Point.new(445277.9637, 445640.112599999)
      ring.points << RGis::Point.new(445277.965300001, 445640.1118)      
      ring.points << RGis::Point.new(445277.9661, 445640.110199999)      
      ring.points << RGis::Point.new(445277.965799998, 445640.108199999)      
      ring.points << RGis::Point.new(222638.983399998, 222684.2062)                        
      polygon = RGis::Polygon.new()
      polygon.rings << ring
      
      path = RGis::Path.new()
      path.points << RGis::Point.new(2,2) << RGis::Point.new(4,4)
      polyline = RGis::Polyline.new()
      polyline.paths << path

      polyline.buffer( :input_spatial_reference => 4326,
                    :output_spatial_reference => 102100,
                    :buffer_spatial_reference => 102100,
                    :distances => 0.01,
                    :distance_units => RGis::Helper::UNIT_TYPES[:survey_foot],
                    :union_results => true).should == polygon
    end
  end
  
end
