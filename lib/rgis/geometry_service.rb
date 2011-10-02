require 'rgis/lookup'
require 'rgis/helper'
require 'rgis/request'
require 'uri'
require 'json'

module RGis  
  class GeometryService
    attr_reader :uri

    def initialize(uri)
      @uri = uri
    end

    # project a geometry from one spatial reference to another
    def project(input_spatial_reference, output_spatial_reference, geometry)
      # prepare request object
      request = Request.new
      request.f = 'json'
      request.inSR = input_spatial_reference
      request.outSR = output_spatial_reference
      request.geometries = JSON.unparse(RGis::Helper::GeometryHelper.parse(geometry))
      Lookup.post(service_uri_for('project'), request)
    end

    private 
    
    def service_uri_for(service)
      if uri.end_with?('/')
        uri << service
      else
        uri << '/' << service
      end
    end

  end
end