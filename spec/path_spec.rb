require 'spec_helper'   

describe 'Path Equality And Validation' do
  before(:each) do
    @path = RGis::Path.new()
    @another_path = RGis::Path.new()
    @path.points << RGis::Point.new(1,3) << RGis::Point.new(4,7) << ::RGis::Point.new(6,8)
    @another_path.points << RGis::Point.new(1,3) << RGis::Point.new(4,7) << ::RGis::Point.new(6,8)
  end
  
  it "should compare equal paths" do
    @path.should == @another_path
  end
  
  it "should validate a polyline when more than one point is present" do
    @path.should be_valid
  end
  
  it "should reject a polyline when only a point is present" do
    @path.points.pop
    @path.points.pop
    @path.should_not be_valid
  end
  
end