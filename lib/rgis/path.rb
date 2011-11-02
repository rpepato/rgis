module RGis
  class Path
    attr_accessor :points
   
    def initialize
      @points = []
    end
   
    def ==(other)
      @points == other.points
    end
   
    def valid?
      @points.count > 1
    end
    
    def to_array
      @points.collect { |p| [p.x, p.y] }
    end    
    
  end
end