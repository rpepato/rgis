require 'rgis/request'
require 'rgis/services/geometry_service'
require 'json'

module RGis

  # The RGis Polygon class represents a geometry composed of one or more Rings, creating what can be understood as a closed polyline.
  # A ring is a connected sequence of four or more Points that form a closed, non-self-intersecting loop (Can be compared to a Path where the first and last Points are exactly the same).
  # A Polygon may contain multiple outer Rings and the order of vertices or orientation for a Ring indicates which side of the Ring is the interior of the Polygon. The neighborhood to the right of an observer walking along the Ring in vertex order is the neighborhood inside the Polygon. Vertices of Rings defining holes in Polygons are in a counterclockwise direction. Vertices for a single, ringed Polygon are, therefore, always in clockwise order. The Rings of a Polygon are referred to as its parts.
  #
  # To create an instance of this class, you'll have to have previously created one or more instances of the RGis Ring objects and use those objects to set the rings properties of a new Polygon object instance (Always respecting the clockwise/counterclockwise order as described above).
  #
  # @ring = RGis::Ring.new()
  # @ring.points << RGis::Point.new(2,2) << RGis::Point.new(4,4) << RGis::Point.new(6,6) << RGis::Point.new(2,2)
  # @polygon = RGis::Polygon.new()
  # @polygon.rings << ring
  #
  class Polygon
    include RGis::Services::GeometryService

    # An array of RGis Ring used to represent parts of this Polygon (or the entire Polygon if it's constituted of a single Ring).
    attr_accessor :rings
    
    def initialize()
      @rings = []
    end
    
    # The == method is use to compare two instances of RGis Polygon for equality.
    # The instances are equal when x and y fields in every point of every ring in both instances are equals. Otherwise, the method will return false.
    def ==(other)
      @rings == other.rings
    end
    
    # Converts the current instance to a json representation expected for the esri rest api. 
    # For example:
    #   @polygon = RGis::Polygon.new()
    #   @first_ring = RGis::Ring.new()
    #   @first_ring.points << RGis::Point.new(-97.06138,32.837) << RGis::Point.new(-97.06133,32.836) << RGis::Point.new(-97.06124,32.834) << RGis::Point.new(-97.06127,32.832) << RGis::Point.new(-97.06138,32.837)
    #   @second_ring = RGis::Ring.new()
    #   @second_ring.points << RGis::Point.new(-97.06326,32.759) << RGis::Point.new(-97.06298,32.755) << RGis::Point.new(-97.06153,32.749) << RGis::Point.new(-97.06326,32.759)
    #   @polygon.rings << @first_ring << @second_ring
    #   puts polygon.to_json
    #   
    #   => {"geometryType":"esriGeometryPolygon","geometries":[{"rings":[[[-97.06138,32.837],[-97.06133,32.836],[-97.06124,32.834],[-97.06127,32.832],[-97.06138,32.837]],[[-97.06326,32.759],[-97.06298,32.755],[-97.06153,32.749],[-97.06326,32.759]]]}]}
    #
    def to_json
      JSON.unparse(to_hash)
    end
    
    def rings_to_json
      JSON.unparse(rings_to_array)      
    end
    

    # Validates the current Polygon. An Polygon is considered valid when it has at least one Ring and each Ring inside it must also be valid, having at least four Points and being the first point equal to last point.
    def valid?
      return false unless @rings.count >= 1
      @rings.each do |r|
        return false unless r.valid?
      end
      true
    end
    
    private 
    
    # Returns the Rings of the current Polygon instance as an array of array. The array returned is a three-dimensional array.
    # The first dimension, the inner most, is a two element representation of a Point. The second dimension, the middle one, is an array of Point, representing a Ring, and the third dimension, the outer-most is the array of the Rings that represent the Polygon.
    def rings_to_array
      [{:rings => rings.collect {|r| r.to_array}}]
    end

    # Creates a hash from the current instance (using the hashie gem) to be used for json generation.
    def to_hash
      request = Request.new
      request.geometryType = RGis::Helper::GEOMETRY_TYPES[:polygon]
      request.geometries = rings_to_array     
      request
    end
  end  
end
