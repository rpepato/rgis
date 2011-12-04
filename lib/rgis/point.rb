require 'rgis/request'
require 'rgis/services/geometry_service'
require 'json'

module RGis
  
  # The RGis point class represents a point geometry type.
  # To create an instance of this class, simple call new passing in its latitude and longitude (x and y arguments) in its constructor
  #   @point = RGis::Point.new(-46.23477632, -34.27347253)
  class Point
    include RGis::Services::GeometryService

    # X and Y attributes representing the latitude and longitude of the current point
    attr_accessor :x, :y
    
    def initialize(x, y)
      @x = Float(x)
      @y = Float(y)
    end

    # The == method is use to compare two instances of rgis point for equality.
    # The instances are equal when x and y fields in both instances are equals. Otherwise, the method will return false.
    #
    # This method is frequently used on Polygon and Polyline types, to determine the validity of these geometries
    def == other
      @x == other.x && @y == other.y
    end

    # Converts the current instance to a json representation expected for the esri rest api. 
    # For example:
    #   @point = RGis::Point.new(-46.23477632, -34.27347253)
    #   puts @point.to_json
    #   
    #   => {"geometryType":"esriGeometryPoint","geometries":[{"x":-46.23477632,"y":-34.27347253}]}
    def to_json
      JSON.unparse(to_hash)
    end
    
    # Converts the current instance to an array of hashes, containint one hash representing the current geometry
    def to_array
      [{:x => @x, :y => @y}]
    end

    private 
    
    # Creates a hash from the current instance (using the hashie gem) to be used for json generation
    def to_hash
      request = Request.new
      request.geometryType = RGis::Helper::GEOMETRY_TYPES[:point]
      request.geometries = to_array
      request
    end  
    
  end
end
