module RGis
  class Envelope
    attr_accessor :lower_left_point, :upper_right_point
    
    def initialize(lower_left_point, upper_right_point)
      
      raise TypeError, "You should provide two RGis point objects to construct an envelope" unless lower_left_point.is_a?(RGis::Point) && upper_right_point.is_a?(RGis::Point)
             
      @lower_left_point = lower_left_point
      @upper_right_point = upper_right_point
      
    end
    
  end
end