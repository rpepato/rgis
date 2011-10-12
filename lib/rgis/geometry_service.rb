require 'rgis/lookup'
require 'rgis/helper'
require 'rgis/request'
require 'uri'
require 'json'

module RGis  
  class GeometryService
    attr_reader :uri

    def initialize(uri)
      @uri = RGis::Helper::ServiceHelper.service_uri(uri, :geometry_service)
    end

    # project a geometry from one spatial reference to another
    def project(input_spatial_reference, output_spatial_reference, geometry)
      # prepare request object
      request = Request.new
      request.f = 'json'
      request.inSR = input_spatial_reference
      request.outSR = output_spatial_reference
      request.geometries = JSON.unparse(RGis::Helper::GeometryHelper.parse(geometry))
      Lookup.post("#{@uri}/project", request)
    end       
    
    # simplify a geometry
    def simplify(input_spatial_reference, geometry)
      request = Request.new
      request.f = 'json'
      request.sr = input_spatial_reference    
      request.geometries = JSON.unparse(geometry)    
      Lookup.post("#{@uri}/simplify", request)
    end  
                                            
    # generates a buffer geometry 
    def buffer(input_spatial_reference, geometry, params)
      request = Request.new
      request.f = 'json'
      request.inSR = input_spatial_reference
      request.outSR = params[:out_sr]
      request.bufferSR = params[:buffer_sr]
      request.distances = params[:distances]
      request.unit = params[:unit]
      request.unionResults = params[:union_results]                                                      
      request.geometries = JSON.unparse(geometry)       
      Lookup.post("#{@uri}/buffer", request)
    end                           
    
    # calculates length and area from polygons
    def length_and_area(input_spatial_reference, polygons, params)
      request = Request.new
      request.f = 'json'
      request.sr = input_spatial_reference
      request.lengthUnit = params[:length_unit]
      request.areaUnit = JSON.unparse(params[:area_unit])
      request.polygons = JSON.unparse(polygons)
      Lookup.post("#{@uri}/areasAndLengths", request)                                                   
    end                                      
                                                    
    # calculates the length of polylines
    def lengths (input_spatial_reference, polylines, params)
      request = Request.new
      request.f = 'json'
      request.sr = input_spatial_reference
      request.lengthUnit = params[:length_unit]
      request.geodesic = params[:geodesic]
      request.polylines = JSON.unparse(polylines)  
      Lookup.post("#{@uri}/lengths", request)            
    end

    # determines the label point from polygons
    def label_points(input_spatial_reference, polygons)
      request = Request.new
      request.f = 'json'
      request.sr = input_spatial_reference
      request.polygons = JSON.unparse(polygons)  
      Lookup.post("#{@uri}/labelPoints", request)      
    end                     

    # performs relation on two geometries as specifiec by the "relation" param   
    def relation(input_spatial_reference, geometry, related_geometry, params)
      request = Request.new
      request.f = 'json'
      request.sr = input_spatial_reference
      request.geometries1 = JSON.unparse(geometry)
      request.geometries2 = JSON.unparse(related_geometry)
      request.relation = params[:relation]
      request.relationParam = params[:relationParam]
      Lookup.post("#{@uri}/relation", request)
    end
    
  end
end
