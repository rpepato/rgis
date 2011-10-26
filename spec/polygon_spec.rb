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
    VCR.use_cassette('polygon_project', :record => :new_episodes) do
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
  end
  
  it "should change points from a polygon when reprojected" do
    VCR.use_cassette('polygon_project_bang', :record => :new_episodes) do
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
  
  it "should simplify a polygon" do 
    VCR.use_cassette('polygon_simplify', :record => :new_episodes) do
      ring = RGis::Ring.new()
      ring.points << RGis::Point.new(2,0) << RGis::Point.new(6,0) << RGis::Point.new(6,4) << RGis::Point.new(3,4.3) << RGis::Point.new(2,4) << RGis::Point.new(2,0)
      polygon = RGis::Polygon.new()
      polygon.rings << ring

      another_ring = RGis::Ring.new()
      another_ring.points << RGis::Point.new(6.00000000000006, 5.6843418860808E-14) << RGis::Point.new(2.00000000000006, 5.6843418860808E-14) << RGis::Point.new(2.00000000000006, 4.00000000000006) << RGis::Point.new(3.00000000000006, 4.30000000000007) << RGis::Point.new(6.00000000000006, 4.00000000000006) << RGis::Point.new(6.00000000000006, 5.6843418860808E-14)
      another_polygon = RGis::Polygon.new()
      another_polygon.rings << another_ring

      polygon.simplify(:spatial_reference => 4326).should == another_polygon
    end
  end
  
  
  it "should calculate a buffer for a polygon" do
    VCR.use_cassette('polygon_buffer', :record => :new_episodes) do
      ring = RGis::Ring.new()
      ring.points << RGis::Point.new(2,2) << RGis::Point.new(4,4) << RGis::Point.new(6,6) << RGis::Point.new(2,2)
      polygon = RGis::Polygon.new()
      polygon.rings << ring
      
      
      another_ring = RGis::Ring.new()
      another_ring.points << RGis::Point.new(222638.981281747, 222684.208400744)
      another_ring.points << RGis::Point.new(222638.981281747, 222684.208500744) 
      another_ring.points << RGis::Point.new(222638.981281747, 222684.208600744) 
      another_ring.points << RGis::Point.new(222638.981281747, 222684.208700744) 
      another_ring.points << RGis::Point.new(222638.981381747, 222684.208700744) 
      another_ring.points << RGis::Point.new(667916.944581747, 669141.057200744)
      another_ring.points << RGis::Point.new(667916.944681747, 669141.057300744) 
      another_ring.points << RGis::Point.new(667916.944781746, 669141.057300744) 
      another_ring.points << RGis::Point.new(667916.944881747, 669141.057300744) 
      another_ring.points << RGis::Point.new(667916.944981747, 669141.057300744) 
      another_ring.points << RGis::Point.new(667916.944981747, 669141.057200744) 
      another_ring.points << RGis::Point.new(667916.945081747, 669141.057200744) 
      another_ring.points << RGis::Point.new(667916.945081747, 669141.057100744) 
      another_ring.points << RGis::Point.new(667916.945081747, 669141.057000744) 
      another_ring.points << RGis::Point.new(667916.945081747, 669141.056900744) 
      another_ring.points << RGis::Point.new(667916.944981747, 669141.056800744) 
      another_ring.points << RGis::Point.new(445277.963381747, 445640.109500744) 
      another_ring.points << RGis::Point.new(222638.981781747, 222684.208300744) 
      another_ring.points << RGis::Point.new(222638.981781747, 222684.208200744) 
      another_ring.points << RGis::Point.new(222638.981681747, 222684.208200744) 
      another_ring.points << RGis::Point.new(222638.981581747, 222684.208200744) 
      another_ring.points << RGis::Point.new(222638.981481747, 222684.208200744) 
      another_ring.points << RGis::Point.new(222638.981481747, 222684.208300744) 
      another_ring.points << RGis::Point.new(222638.981381747, 222684.208300744) 
      another_ring.points << RGis::Point.new(222638.981381747, 222684.208400744) 
      another_ring.points << RGis::Point.new(222638.981281747, 222684.208400744)                        
      another_polygon = RGis::Polygon.new()
      another_polygon.rings << another_ring
      
      polygon.buffer( :input_spatial_reference => 4326,
                      :output_spatial_reference => 102100,
                      :buffer_spatial_reference => 102100,
                      :distances => 0.001,
                      :distance_units => RGis::Helper::UNIT_TYPES[:survey_foot],
                      :union_results => false).should == another_polygon
    end
  end
  
  it "should calculate area and perimter for a polygon" do
    VCR.use_cassette('polygon_area_and_perimeter', :record => :new_episodes) do    
      ring = RGis::Ring.new()

      ring.points << RGis::Point.new(-628833.344099998,206205.236200001)
      ring.points << RGis::Point.new(-630269.659900002,192298.906100001)
      ring.points << RGis::Point.new(-631848.233800001,173991.394400001)
      ring.points << RGis::Point.new(-616471.690300003,341822.557500001)
      ring.points << RGis::Point.new(-620213.661300004,301450.162799999)
      ring.points << RGis::Point.new(-625923.431999996,237538.0579)     
      ring.points << RGis::Point.new(-628833.344099998,206205.236200001) 

      polygon = RGis::Polygon.new()
      polygon.rings << ring


      area_and_perimeter = polygon.area_and_perimeter( :spatial_reference => 102009, 
      :length_unit => RGis::Helper::UNIT_TYPES[:survey_mile],
      :area_unit =>  RGis::Helper::AREA_UNIT_TYPES[:acres])    
      area_and_perimeter[:area].should =~ [615.362788718949]
      area_and_perimeter[:perimeter].should =~ [209.444905018474]
    end    
  end
  
  it "should raise an exception when area_and_perimeter method is called" do
    VCR.use_cassette('polyline_area_and_perimeter', :record => :new_episodes) do
      polyline = RGis::Polyline.new()
      lambda{polyline.area_and_perimeter(nil)}.should raise_error(TypeError, "Area and perimeter operation is allowed only for polygon types")
    end
  end  
  
end
