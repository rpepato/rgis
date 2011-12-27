module RGis

  # The RGis Ring class represents a geometry composed of a sequence of four or more Points that form a closed, non-self-intersecting loop (Can be compared to a Path where the first and last Points are exactly the same).
  # The Points of a Rings are referred to as its parts.
  #
  # To create an instance of this class, you'll have to have previously created at least four instances of the RGis Point objects and use those objects to set the points properties of a new Ring object instance (Always respecting the first-point equals last-point rule).
  #
  # @point1 = RGis::Point.new(2,2)
  # @point2 = RGis::Point.new(4,2)
  # @point3 = RGis::Point.new(6,6)
  # @point4 = RGis::Point.new(2,2)
  #
  # @ring = RGis::Ring.new()
  # @ring.points << point1 << point2 << point3 << point4
  #
  class Ring

    # An array of RGis Point used to represent parts of this Ring.
    attr_accessor :points
    
    def initialize
      @points = []
    end
    
    # The == method is use to compare two instances of RGis Ring for equality.
    # The instances are equal when x and y fields in every point of the ring in both instances are equals. Otherwise, the method will return false.
    def == (other)
      @points == other.points
    end    

    # Validates the current Ring. A Ring is considered valid when it has at least four Points, being the first point equal to last point.
    def valid?
      @points.count > 3 && @points.first == @points.last
    end
    
    # Generate an array of arrays with the Ring Points. Each element of the array is also an array with the x and y point coordinates in the following form: [x,y]
    # Example: 
    #          @ring = RGis::Ring.new()
    #          @ring.points << RGis::Point.new(2,4) << RGis::Point.new(4,8) << RGis::Point.new(6,6) << RGis::Point.new(2,4)
    #          puts @path.to_array
    #          => [[2,4],[4,8],[6,6], [2,4]]
    def to_array
      @points.collect { |p| [p.x, p.y] }
    end
    
  end
end
