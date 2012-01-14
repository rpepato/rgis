require 'rgis/request'
require 'rgis/services/geometry_service'
require 'json'

module RGis

  # The RGis Polyline class represents a geometry composed of one or more Paths. The paths do not have to be connected to each other.
  # A Path is a connected sequence of two or more Points that form an opened geometry (The first and last point cannot be the same, otherwise they'll form a Ring, and not a Path).
  #
  # To create an instance of this class, you'll have to have previously created one or more instances of the RGis Path objects and use those objects to set the paths properties of a new Palyline object instance.
  #
  # @ring = RGis::Ring.new()
  # @ring.points << RGis::Point.new(2,2) << RGis::Point.new(4,2) << RGis::Point.new(6,6) << RGis::Point.new(2,2)
  # @polygon = RGis::Polygon.new()
  # @polygon.rings << ring
  #
  class Polyline
    include RGis::Services::GeometryService

    # An array of RGis Paths used to represent parts of this Polyline.
    attr_accessor :paths

    def initialize
      @paths = []
    end

    # The == method is use to compare two instances of a Polyline type for equality.
    # The instances are equal when each of the Paths are equals in both objects intances. Otherwise, the method will return false.
    def == (other)
      @paths == other.paths
    end

    # Converts the current instance to a json representation expected for the esri rest api.
    # For example:
    #   @polyline = RGis::Polyline.new()
    #   @first_path = RGis::Path.new()
    #   @first_path.points << RGis::Point.new(-97.06138,32.837) << RGis::Point.new(-97.06133,32.836) << RGis::Point.new(-97.06124,32.834) << RGis::Point.new(-97.06127,32.832)
    #   @second_path = RGis::Ring.new()
    #   @second_path.points << RGis::Point.new(-97.06326,32.759) << RGis::Point.new(-97.06298,32.755) << RGis::Point.new(-97.06153,32.749)
    #   @polyline.paths << @first_path << @second_path
    #   puts polyline.to_json
    #
    #   => {"geometryType":"esriGeometryPolyline","geometries":[{"paths":[[[-97.06138,32.837],[-97.06133,32.836],[-97.06124,32.834],[-97.06127,32.832]],[[-97.06326,32.759],[-97.06298,32.755],[-97.06153,32.749]]]}]}
    #
    def to_json
      JSON.unparse(to_hash)
    end

    # Validates the current Polyline. A Polyline is considered valid when it has at least one Path and, all the paths it contains are also valid.
    def valid?
      return false unless @paths.count > 1
      @paths.each do |p|
        return false unless p.valid?
      end
      true
    end

    private

    # Returns the Paths of the current Polyline instance as an array of array. The array returned is a three-dimensional array.
    # The first dimension, the inner most, is a two element representation of a Point. The second dimension, the middle one, is an array of Point, representing a Path, and the third dimension, the outer-most is the array of the Paths that represent the Polyline.
    def paths_to_array
      [{:paths => paths.collect {|p| p.to_array}}]
    end

    # Creates a hash from the current instance (using the hashie gem) to be used for json generation.
    def to_hash
      request = Request.new
      request.geometryType = RGis::Helper::GEOMETRY_TYPES[:polyline]
      request.geometries = paths_to_array
      request
    end

  end
end
