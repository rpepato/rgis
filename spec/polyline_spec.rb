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
  
end
