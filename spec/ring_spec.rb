require 'spec_helper'   

describe 'Ring Equality and Validation' do
  
  before(:each) do
    @ring = RGis::Ring.new()
    @another_ring = RGis::Ring.new()
    @another_ring.points << RGis::Point.new(-97.06138, 32.837) << RGis::Point.new(-97.06133, 32.836) << RGis::Point.new(-97.06124, 32.834) << RGis::Point.new(-97.06127, 32.832) << RGis::Point.new(-97.06138,32.837)    
    @ring.points << RGis::Point.new(-97.06138, 32.837) << RGis::Point.new(-97.06133, 32.836) << RGis::Point.new(-97.06124, 32.834) << RGis::Point.new(-97.06127, 32.832) << RGis::Point.new(-97.06138,32.837)
  end
  
  it "should compare equal rings" do
    @ring.should == @another_ring
  end
  
  it "should validate a ring with closed polygon" do
    @ring.should be_valid
  end
  
  it "should reject a ring with less than 4 points" do
    2.times { @ring.points.pop }
    @ring.should_not be_valid
  end
  
  it "should reject a ring with open polygon (path)" do
    @ring.points.pop
    @ring.points << RGis::Point.new(1,1)
    @ring.should_not be_valid    
  end
  
  it "should return raw data for ring" do
    @ring.to_array.should =~ [[-97.06138,32.837],[-97.06133,32.836],[-97.06124,32.834],[-97.06127,32.832],[-97.06138,32.837]]
  end
  
end