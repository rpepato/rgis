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
    
    private
    
    def paths_to_array
      [{:paths => paths.collect {|p| p.to_array}}]
      #paths.collect { |p| {:paths => [p.to_array]}}
    end
    
    def to_hash
      request = Request.new
      request.geometryType = RGis::Helper::GEOMETRY_TYPES[:polyline]
      request.geometries = paths_to_array
      request
    end
    
  end
end