require 'rgis/request'
require 'rgis/services/geometry_service'
require 'json'

module RGis
  class Polygon
    include RGis::Services::GeometryService
        
    attr_accessor :rings
    
    def initialize()
      @rings = []
    end
    
    def ==(other)
      @rings == other.rings
    end
    
    def to_json
      JSON.unparse(to_hash)
    end
    
    def rings_to_json
      JSON.unparse(rings_to_raw_data)      
    end
    
    private 
    
    def rings_to_raw_data
      rings.collect { |r| {:rings => r.raw_data} }
    end

    def to_hash
      request = Request.new
      request.geometryType = RGis::Helper::GEOMETRY_TYPES[:polygon]
      request.geometries = rings.collect { |r| {:rings => [r.raw_data]} }     
      request
    end
  end  
end