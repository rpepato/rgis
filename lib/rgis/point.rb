require 'rgis/request'
require 'rgis/helper'
require 'rgis/services/geometry_service'
require 'json'

module RGis
  class Point
    include RGis::Services::GeometryService

    attr_accessor :x, :y

    def initialize(x, y)
      @x = Float(x)
      @y = Float(y)
    end

    def == other
      @x == Float(other.x) && @y == Float(other.y)
    end

    def to_json
      JSON.unparse(to_hash)
    end

    private 

    def to_hash
      r = Request.new
      r.geometryType = RGis::Helper::GEOMETRY_TYPES[:point]
      r.geometries = [{:x => @x, :y => @y}]     
      r
    end  
  end
end
