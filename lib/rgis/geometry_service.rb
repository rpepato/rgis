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
    
    def buffer(input_spatial_reference, geometry, params)
      request = Request.new
      request.f = 'json'
      request.inSR = input_spatial_reference
      request.outSR = params[:outSR]
      request.bufferSR = params[:bufferSR]
      request.distances = params[:distances]
      request.unit = params[:unit]
      request.unionResults = params[:unionResults]                                                      
      request.geometries = JSON.unparse(geometry)       
      Lookup.post("#{@uri}/buffer", request)
    end    
  end
end
