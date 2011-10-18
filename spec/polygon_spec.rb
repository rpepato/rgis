require 'spec_helper'   

describe 'Polygon Geometry' do
  
  before (:each) do
    RGis::Services::ServiceDirectory.uri = "http://sampleserver1.arcgisonline.com/ArcGIS/rest/services"
  end
  
  it "should compare equal polygons" do
    ring = RGis::Ring.new()
    ring.points << RGis::Point.new(2,2) << RGis::Point.new(4,4) << RGis::Point.new(6,6) << RGis::Point.new(2,2)
    polygon = RGis::Polygon.new()
    polygon.rings << ring
        
    another_ring = RGis::Ring.new()
    another_ring.points << RGis::Point.new(2,2) << RGis::Point.new(4,4) << RGis::Point.new(6,6) << RGis::Point.new(2,2)
    another_polygon = RGis::Polygon.new()
    another_polygon.rings << another_ring
    
    polygon.should == another_polygon

  end
  
  it "should convert a polygon to a json representation expected by esri api" do
    json = '{"geometryType":"esriGeometryPolygon","geometries":[{"rings":[[[2.0,2.0],[4.0,4.0],[6.0,6.0],[2.0,2.0]]]}]}'    
    ring = RGis::Ring.new()
    ring.points << RGis::Point.new(2,2) << RGis::Point.new(4,4) << RGis::Point.new(6,6) << RGis::Point.new(2,2)
    polygon = RGis::Polygon.new()
    polygon.rings << ring
    polygon.to_json.should == json  
  end  
  
  it "should project a polygon from one spatial reference to another and return a new polygon" do
    ring = RGis::Ring.new()
    ring.points << RGis::Point.new(2,2) << RGis::Point.new(4,4) << RGis::Point.new(6,6) << RGis::Point.new(2,2)
    polygon = RGis::Polygon.new()
    polygon.rings << ring
    
    another_ring = RGis::Ring.new()
    another_ring.points << RGis::Point.new(222638.981586547,222684.208505545) << RGis::Point.new(445277.963173094,445640.109656027) << RGis::Point.new(667916.944759641,669141.057044245) << RGis::Point.new(222638.981586547,222684.208505545)
    another_polygon = RGis::Polygon.new()
    another_polygon.rings << another_ring
    
    polygon.project(:from => 4326, :to => 102100).should == another_polygon    
  end
  
  it "should change points from a polygon when reprojected" do
    ring = RGis::Ring.new()
    ring.points << RGis::Point.new(2,2) << RGis::Point.new(4,4) << RGis::Point.new(6,6) << RGis::Point.new(2,2)
    polygon = RGis::Polygon.new()
    polygon.rings << ring    
    polygon.project!(:from => 4326, :to => 102100)
    
    polygon.rings[0].points[0].should == RGis::Point.new(222638.981586547,222684.208505545)
    polygon.rings[0].points[1].should ==  RGis::Point.new(445277.963173094,445640.109656027)
    polygon.rings[0].points[2].should == RGis::Point.new(667916.944759641,669141.057044245)
    polygon.rings[0].points[3].should == RGis::Point.new(222638.981586547,222684.208505545)
  end
  
end