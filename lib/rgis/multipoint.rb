require 'rgis/request'
require 'rgis/services/geometry_service'
require 'json'

module RGis
  
  class Multipoint
    include RGis::Services::GeometryService
    
    attr_accessor :points
    
    def initialize()
      @points = []
    end
    
    def ==(other)
      @points == other.points
    end
    
    def to_json
      JSON.unparse(to_hash)
    end
    
    def valid?
      @points.count > 0
    end
    
    private
    
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