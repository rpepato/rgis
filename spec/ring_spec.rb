require 'spec_helper'   

describe 'Ring Equality and Validation' do
  
  it "should compare equal rings" do
    ring = RGis::Ring.new()
    another_ring = RGis::Ring.new()
    another_ring.points << RGis::Point.new(1,2) << RGis::Point.new(5,6) << RGis::Point.new(-14,6)    
    ring.points << RGis::Point.new(1,2) << RGis::Point.new(5,6) << RGis::Point.new(-14,6)
    ring.should == another_ring
  end
  
  it "should validate a ring with closed polygon" do
    ring = RGis::Ring.new()
    ring.points << RGis::Point.new(2,0) << RGis::Point.new(8,0) << RGis::Point.new(8,5) << RGis::Point.new(2,0)
    ring.should be_valid
  end
  
  it "should reject a ring with less than 4 points" do
    ring = RGis::Ring.new()
    ring.points << RGis::Point.new(0,0) << RGis::Point.new(1,1) << RGis::Point.new(0,0)
    ring.should_not be_valid
  end
  
  it "should reject a ring with open polygon (path)" do
    ring = RGis::Ring.new()
    ring.points << RGis::Point.new(0,0) << RGis::Point.new(1,1) << RGis::Point.new(2,2) << RGis::Point.new(3,3)
    ring.should_not be_valid    
  end
  
  it "should return raw data for ring" do
    ring = RGis::Ring.new()
    ring.points << RGis::Point.new(2,4) << RGis::Point.new(4,8)
    ring.raw_data.should =~ [[2,4],[4,8]]
  end
  
end