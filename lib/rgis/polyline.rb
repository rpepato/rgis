require 'rgis/request'
require 'rgis/services/geometry_service'
require 'json'

module RGis
  class Polyline
    include RGis::Services::GeometryService
    
    attr_accessor :paths
    
    def initialize
      @paths = []
    end
    
    def ==(other)
      @paths == other.paths
    end
    
    def to_json
      JSON.unparse(to_hash)
    end
    
    private
    
    def to_hash
      request = Request.new
      request.geometryType = RGis::Helper::GEOMETRY_TYPES[:polyline]
      geometries = []
      @paths.each do |path|
        p = []
        path.points.each do |point|
          p << [point.x, point.y]
        end
        geometries << p
      end
      request.geometries = [{:paths => geometries}]
      request
    end
    
  end
end