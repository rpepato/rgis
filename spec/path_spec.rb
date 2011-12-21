require 'spec_helper'   

describe 'Path Equality And Validation' do
  before(:each) do
    @path = RGis::Path.new()
    @another_path = RGis::Path.new()
    @path.points << RGis::Point.new(-97.06138, 32.837) << RGis::Point.new(-97.06133, 32.836) << RGis::Point.new(-97.06124, 32.834) << RGis::Point.new(-97.06127, 32.832) 
    @another_path.points << RGis::Point.new(-97.06138, 32.837) << RGis::Point.new(-97.06133, 32.836) << RGis::Point.new(-97.06124, 32.834) << RGis::Point.new(-97.06127, 32.832)
  end
  
  it "should compare equal paths" do
    @path.should == @another_path
  end
  
  it "should validate a polyline when more than one point is present" do
    @path.should be_valid
  end
  
  it "should reject a polyline when only a point is present" do
    3.times { @path.points.pop }
    @path.should_not be_valid
  end
  
  it "should expose its points as an array" do
    @path.to_array.should =~ [[-97.06138,32.837],[-97.06133,32.836],[-97.06124,32.834],[-97.06127,32.832]]
  end
  
end