require 'spec_helper'

describe 'Envelope Geometry' do
  
  before (:each) do
    RGis::Services::ServiceDirectory.uri = "http://sampleserver1.arcgisonline.com/ArcGIS/rest/services"    
    @lower_left_point = RGis::Point.new(-36.2847362,-40.29376351)
    @upper_right_point = RGis::Point.new(-25.293972,-12.83826382)
    @envelope = RGis::Envelope.new(@lower_left_point, @upper_right_point)
  end

  it "should reject construction when constructor parameters (RGis::Point) are missed" do
    lambda{RGis::Envelope.new(1,1)}.should raise_error(TypeError, "You should provide two RGis point objects to construct an envelope")
  end

  it "should create an envelope when two RGis points are passed in the envelope constructor" do
    @envelope.should be_kind_of(RGis::Envelope)
  end

  it "should format itself as an array" do
    @envelope.to_array.should =~ [{:xmin => @lower_left_point.x, :ymin => @lower_left_point.y, :xmax => @upper_right_point.x, :ymax => @upper_right_point.y}]
  end

  it "should report correct values for xmin, xmax, ymin and ymax" do
    @envelope.xmin.should == @lower_left_point.x
    @envelope.ymin.should == @lower_left_point.y
    @envelope.xmax.should == @upper_right_point.x
    @envelope.ymax.should == @upper_right_point.y
  end
  
  it "should compare equals envelopes" do
    another_envelope = RGis::Envelope.new(@lower_left_point, @upper_right_point)
    @envelope.should == another_envelope
  end
  
  it "should convert an envelope to a json representation expected by esri api" do
    json = "{\"geometryType\":\"esriGeometryEnvelope\",\"geometries\":[{\"xmin\":#{@lower_left_point.x},\"ymin\":#{@lower_left_point.y},\"xmax\":#{@upper_right_point.x},\"ymax\":#{@upper_right_point.y}}]}"
    @envelope.to_json.should == json    
  end
  
  it "should project an envelope from one spatial reference to another and return a new envelope" do
    VCR.use_cassette('envelope_project', :record => :new_episodes) do
      @envelope.project!(:from => 4326, :to => 102113)
      @envelope.xmin.should == -4039198.35735226
      @envelope.ymin.should == -4908723.47218843
      @envelope.xmax.should == -2815712.08317932
      @envelope.ymax.should == -1441260.28721334
    end
  end
  
  it "should project an envelope from one spatial reference and change its points when project! is called" do
    VCR.use_cassette('envelope_project_bang', :record => :new_episodes) do
      projected_lower_left_point = RGis::Point.new(-4039198.35735226, -4908723.47218843)
      projected_upper_right_point = RGis::Point.new(-2815712.08317932, -1441260.28721334)
      projected_envelope = RGis::Envelope.new(projected_lower_left_point, projected_upper_right_point)
      @envelope.project(:from => 4326, :to => 102113).should == projected_envelope
    end
  end
  
  it "should raise an exception when simplify method is called" do
    lambda{@envelope.simplify()}.should raise_error(TypeError, "Simplify operation is not supported on envelope types")
  end
  
  it "should raise an exception when buffer method is called" do
    lambda{@envelope.buffer()}.should raise_error(TypeError, "Buffer operation is not supported on envelope types")
  end  
  
  it "should raise an exception when lengths method is called" do
     lambda{@envelope.lengths(nil)}.should raise_error(TypeError, "Lengths operation is allowed only for polyline type")
  end
  
  it "should raise an exception when label_points method is called" do
    lambda{@envelope.label_points(nil)}.should raise_error(TypeError, "Label points operation is allowed only for polygon type")
  end

end


