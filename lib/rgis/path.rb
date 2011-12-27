module RGis
  
  # The path type represents a geometry path (a sequence of points that when connected creates a path). A path is a sequence of points (at least two points) where the first and last point are different each other.
  # This type isn't used to directly manipulate geometries in rgis, but it is used to create an instance of a polyline. 
  class Path

    # An array of points that forms the current path instance
    attr_accessor :points
   
    # The constructor of this class initializes an empty array to store its points.
    def initialize
      @points = []
    end
   
   
    # The == method is use to compare two instances of path type for equality.
    # The instances are equal when each of these points are equals . Otherwise, the method will return false.
    #
    # This method is frequently used by Polyline types, to determine the validity of these geometries    
    def == (other)
      @points == other.points
    end
   
    # Determines when a path geometry is a valid one. Paths are valid when they have at least two points
    def valid?
      @points.count > 1
    end
    
    # Generate an array of arrays with the path points. Each element of the array is also an array with the x and y point coordinates in the following form: [x,y]
    # Example: 
    #          @path = RGis::Path.new()
    #          @path.points << RGis::Point.new(2,4) << RGis::Point.new(4,8) << RGis::Point.new(8,16)
    #          puts @path.to_array
    #          => [[2,4],[4,8],[8,16]]
    def to_array
      @points.collect { |p| [p.x, p.y] }
    end    
    
  end
end
