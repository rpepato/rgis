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
      
      raw_data_rings = []
      @rings.each do |ring|
        r = []
        ring.points.each do |point|
          r << [point.x, point.y]
        end
        raw_data_rings << r
      end
      
      geometry_rings = []
      raw_data_rings.each do |r|
        geometry_rings << {:rings => r}
      end

      
      JSON.unparse(geometry_rings)
      
    end
    
    
    private 

    def to_hash
      request = Request.new
      request.geometryType = RGis::Helper::GEOMETRY_TYPES[:polygon]
      geometries = []
      @rings.each do |ring|
        r = []
        ring.points.each do |point|
          r << [point.x, point.y]
        end
        geometries << r
      end
      request.geometries = [{:rings => geometries}]     
      request
    end
  end  
end