require 'rgis/request'
require 'rgis/services/geometry_service'
require 'json'

module RGis
  
  # The RGis Multipoint class represents a single geometry composed by an unordered collection of points.
	#
	# To create an instance of this class, you must have previously created at least two instances of RGis points
	# and use these objects to set the points property of the new Multipoint instance.
	# Example:
	# @point1 = RGis::Point.new(3,3)
	# @point1 = RGis::Point.new(5,5)
	# 
	# @multipoint = RGis::Multipoint.new()
	# @multipoint.points << point1 << point2
	#
  class Multipoint
    include RGis::Services::GeometryService
   
		# An array of RGis Points which composes this Multipoint
    attr_accessor :points
    
    def initialize()
      @points = []
    end
    
    # The == method compares the equality of two RGis Multipoint instances.
    # The instances are equal when the X and Y fields of every point in the Multipoint of both instances are equal. Otherwise, the method will return false.
    def ==(other)
      @points == other.points
    end
    
    def to_json
      JSON.unparse(to_hash)
    end
    
    # Validates the current Multipoint. A Multipoint is considered valid when it has at least one Point.
    def valid?
      @points.count > 0
    end
    
    private
    
    # Generate an array of arrays containing the Multipoint Points. Each element of the array is also an array with the x and y point coordinates in the following form: [x,y]
    # Example: 
    #          @multipoint = RGis::Multipoint.new()
    #          @multipoint.points << RGis::Point.new(2,4) << RGis::Point.new(4,8) << RGis::Point.new(6,6) << RGis::Point.new(5,5)
    #          puts @multipoint.to_array
    #          => [[2,4],[4,8],[6,6],[5,5]]
    def points_to_array
      [{:points => @points.collect { |p| [p.x,p.y]}}]
    end
    
    def to_hash
      request = Request.new
      request.geometryType = RGis::Helper::GEOMETRY_TYPES[:multipoint]
      request.geometries = points_to_array
      request
    end
    
  end
  
end
