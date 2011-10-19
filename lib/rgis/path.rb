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
    
  end
end