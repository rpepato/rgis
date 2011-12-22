require 'spec_helper'

 describe 'Envelope Geometry' do
   
   it "should reject construction when constructor parameters (RGis::Point) are missed" do
     lambda{RGis::Envelope.new(1,1)}.should raise_error(TypeError, "You should provide two RGis point objects to construct an envelope")
   end
   
   it "should create an envelope when two RGis points are passed in the envelope constructor" do
     point = RGis::Point.new(-12,-12)
     another_point = RGis::Point.new(-14,-14)
     envelope = RGis::Envelope.new(point, another_point)
     envelope.should be_kind_of(RGis::Envelope)
   end
   
 end


