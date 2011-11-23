require 'spec_helper'   

describe 'Ring Equality and Validation' do
  
  before(:each) do
    @ring = RGis::Ring.new()
    @another_ring = RGis::Ring.new()
    @another_ring.points << RGis::Point.new(1,2) << RGis::Point.new(5,6) << RGis::Point.new(-14,6) << RGis::Point.new(1,2)    
    @ring.points << RGis::Point.new(1,2) << RGis::Point.new(5,6) << RGis::Point.new(-14,6) << RGis::Point.new(1,2)
  end
  
  it "should compare equal rings" do
    @ring.should == @another_ring
  end
  
  it "should validate a ring with closed polygon" do
    @ring.points << RGis::Point.new(1,2)
    @ring.should be_valid
  end
  
  it "should reject a ring with less than 4 points" do
    @ring.points.pop
    @ring.should_not be_valid
  end
  
  it "should reject a ring with open polygon (path)" do
    @ring.points.pop
    @ring.points << RGis::Point.new(1,1)
    @ring.should_not be_valid    
  end
  
  it "should return raw data for ring" do
    @ring.to_array.should =~ [[1,2],[5,6],[-14,6],[1,2]]
  end
  
end