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
    
    def paths_to_json
      JSON.unparse(paths_to_array)
    end
    
    def valid?
      return false unless @paths.count > 1
      @paths.each do |p|
        return false unless p.points.count > 1
      end
      true
    end
    
    private
    
    def paths_to_array
      [{:paths => paths.collect {|p| p.to_array}}]
    end
    
    def to_hash
      request = Request.new
      request.geometryType = RGis::Helper::GEOMETRY_TYPES[:polyline]
      request.geometries = paths_to_array
      request
    end
    
  end
end