require 'spec_helper'   

describe 'Polygon Geometry' do
  
  before (:each) do
    RGis::Services::ServiceDirectory.uri = "http://sampleserver1.arcgisonline.com/ArcGIS/rest/services"
    @polygon = RGis::Polygon.new()
    @ring = RGis::Ring.new()
    @another_ring = RGis::Ring.new()
    @ring.points << RGis::Point.new(-97.06138,32.837) << RGis::Point.new(-97.06133,32.836) << RGis::Point.new(-97.06124,32.834) << RGis::Point.new(-97.06127,32.832) << RGis::Point.new(-97.06138,32.837)
    @another_ring.points << RGis::Point.new(-97.06326,32.759) << RGis::Point.new(-97.06298,32.755) << RGis::Point.new(-97.06153,32.749) << RGis::Point.new(-97.06326,32.759)
    @polygon.rings << @ring << @another_ring
    
    @cloned_polygon = RGis::Polygon.new()
    @cloned_ring = RGis::Ring.new()
    @another_cloned_ring = RGis::Ring.new()
    @cloned_ring.points << RGis::Point.new(-97.06138,32.837) << RGis::Point.new(-97.06133,32.836) << RGis::Point.new(-97.06124,32.834) << RGis::Point.new(-97.06127,32.832) << RGis::Point.new(-97.06138,32.837)
    @another_cloned_ring.points << RGis::Point.new(-97.06326,32.759) << RGis::Point.new(-97.06298,32.755) << RGis::Point.new(-97.06153,32.749) << RGis::Point.new(-97.06326,32.759)
    @cloned_polygon.rings << @cloned_ring << @another_cloned_ring
  end
  
  it "should compare equal polygons" do
    @polygon.should == @cloned_polygon
  end
  
  it "should convert a polygon to a json representation expected by esri api" do
    json = '{"geometryType":"esriGeometryPolygon","geometries":[{"rings":[[[-97.06138,32.837],[-97.06133,32.836],[-97.06124,32.834],[-97.06127,32.832],[-97.06138,32.837]],[[-97.06326,32.759],[-97.06298,32.755],[-97.06153,32.749],[-97.06326,32.759]]]}]}'    
    @polygon.to_json.should == json  
  end  
  
  it "should project a polygon from one spatial reference to another and return a new polygon" do
    VCR.use_cassette('polygon_project', :record => :new_episodes) do
      projected_polygon = RGis::Polygon.new()
      projected_ring = RGis::Ring.new()
      another_projected_ring = RGis::Ring.new()
      projected_ring.points << RGis::Point.new(-10804823.3972924, 3873688.37165364) << RGis::Point.new(-10804817.8313179, 3873555.88336103) << RGis::Point.new(-10804807.8125637, 3873290.91125252) << RGis::Point.new(-10804811.1521484, 3873025.94511247) << RGis::Point.new(-10804823.3972924, 3873688.37165364)
      another_projected_ring.points << RGis::Point.new(-10805032.6779351, 3863358.76046768) << RGis::Point.new(-10805001.5084777, 3862829.2809139) << RGis::Point.new(-10804840.095216, 3862035.10617018) << RGis::Point.new(-10805032.6779351, 3863358.76046768)
      projected_polygon.rings << projected_ring << another_projected_ring

      
      @polygon.project(:from => 4326, :to => 102113).should == projected_polygon    
    end
  end
  
  it "should change points from a polygon when reprojected" do
    VCR.use_cassette('polygon_project_bang', :record => :new_episodes) do   
      @polygon.project!(:from => 4326, :to => 102100)

      @polygon.rings[0].points[0].should == RGis::Point.new(-10804823.3972924, 3873688.37165364)
      @polygon.rings[0].points[1].should ==  RGis::Point.new(-10804817.8313179, 3873555.88336103)
      @polygon.rings[0].points[2].should == RGis::Point.new(-10804807.8125637, 3873290.91125252)
      @polygon.rings[0].points[3].should == RGis::Point.new(-10804811.1521484, 3873025.94511247)
      @polygon.rings[0].points[4].should == RGis::Point.new(-10804823.3972924, 3873688.37165364)
      
      @polygon.rings[1].points[0].should == RGis::Point.new(-10805032.6779351, 3863358.76046768)
      @polygon.rings[1].points[1].should == RGis::Point.new(-10805001.5084777, 3862829.2809139)
      @polygon.rings[1].points[2].should == RGis::Point.new(-10804840.095216, 3862035.10617018)
      @polygon.rings[1].points[3].should == RGis::Point.new(-10805032.6779351, 3863358.76046768)
    end
  end
  
  it "should simplify a polygon" do 
    VCR.use_cassette('polygon_simplify', :record => :new_episodes) do

      simplified_polygon = RGis::Polygon.new()
      simplified_ring = RGis::Ring.new()
      another_simplified_ring = RGis::Ring.new()
      simplified_ring.points << RGis::Point.new(-97.06326, 32.7590000000001) << RGis::Point.new(-97.0615299999999, 32.749) << RGis::Point.new(-97.06298, 32.7550000000001) << RGis::Point.new(-97.06326, 32.7590000000001)
      another_simplified_ring.points << RGis::Point.new(-97.0612399999999, 32.8340000000001) << RGis::Point.new(-97.06127, 32.8320000000001) << RGis::Point.new(-97.06138, 32.837) << RGis::Point.new(-97.0613299999999, 32.8360000000001) << RGis::Point.new(-97.0612399999999, 32.8340000000001)
      simplified_polygon.rings << simplified_ring << another_simplified_ring
     
      @polygon.simplify(:spatial_reference => 4326).should == simplified_polygon
    end
  end
  
  
  it "should calculate a buffer for a polygon" do
    VCR.use_cassette('polygon_buffer', :record => :new_episodes) do
      polygon_buffer = RGis::Polygon.new()
      ring = RGis::Ring.new()
      another_ring = RGis::Ring.new()
      yet_another_ring = RGis::Ring.new()
      
      ring.points << RGis::Point.new(-97.0632599260227, 32.7590000009996) 
      ring.points << RGis::Point.new(-97.061529943262, 32.7489999737818)
      ring.points << RGis::Point.new(-97.0615300528565, 32.7489999503605) 
      ring.points << RGis::Point.new(-97.0629800882353, 32.7549999908293)
      ring.points << RGis::Point.new(-97.063260075143, 32.7590000304619)
      ring.points << RGis::Point.new(-97.0632600212441, 32.7590000712557) 
      ring.points << RGis::Point.new(-97.0632599808199, 32.7590000621904) 
      ring.points << RGis::Point.new(-97.0632599314126, 32.7590000410381) 
      ring.points << RGis::Point.new(-97.0632599260227, 32.7590000009996)
      
      
      another_ring.points << RGis::Point.new(-97.0629799813357, 32.7549999704314) 
      another_ring.points << RGis::Point.new(-97.0615305487265, 32.7490026543905) 
      another_ring.points << RGis::Point.new(-97.0632597876821, 32.7589982506408) 
      another_ring.points << RGis::Point.new(-97.0629799597762, 32.7550000150045) 
      another_ring.points << RGis::Point.new(-97.0629799813357, 32.7549999704314)
      
      yet_another_ring.points << RGis::Point.new(-97.0612700058531, 32.8319999606552)
      yet_another_ring.points << RGis::Point.new(-97.0612700516672, 32.8319999523521) 
      yet_another_ring.points << RGis::Point.new(-97.0613800593568, 32.8370000426176) 
      yet_another_ring.points << RGis::Point.new(-97.0613799443725, 32.8370000471463) 
      yet_another_ring.points << RGis::Point.new(-97.0613299100078, 32.8360000033133) 
      yet_another_ring.points << RGis::Point.new(-97.0612399104944, 32.8340000011132) 
      yet_another_ring.points << RGis::Point.new(-97.0612699447676, 32.8320000104734) 
      yet_another_ring.points << RGis::Point.new(-97.0612699591407, 32.8319999666937) 
      yet_another_ring.points << RGis::Point.new(-97.0612700058531, 32.8319999606552)
      
      polygon_buffer.rings << ring
      polygon_buffer.rings << another_ring
      polygon_buffer.rings << yet_another_ring
      
      @polygon.buffer(:input_spatial_reference => 4326,
                      :output_spatial_reference => 4326,
                      :buffer_spatial_reference => 102113,
                      :distances => 0.01,
                      :union_results => true).should == polygon_buffer
    end
  end
  
  it "should calculate area and perimter for a polygon" do
    VCR.use_cassette('polygon_area_and_perimeter', :record => :new_episodes) do
      area_and_perimeter = @polygon.area_and_perimeter( :spatial_reference => 102009, 
      :length_unit => RGis::Helper::UNIT_TYPES[:survey_mile],
      :area_unit =>  RGis::Helper::AREA_UNIT_TYPES[:acres])    
      area_and_perimeter[:area].should =~ [-4.62087063337152E-10]
      area_and_perimeter[:perimeter].should =~ [1.88497297088255E-05]
    end    
  end
  

  
end
