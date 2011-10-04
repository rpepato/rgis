require 'rgis/lookup'
require 'rgis/helper'
require 'rgis/request'
require 'uri'
require 'json'

module RGis  
  class GeometryService
    attr_reader :uri

    def initialize(uri)
      @uri = service_uri(uri)
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

    def service_uri (base_uri)
      service_name = geometry_service_name(base_uri)
      "#{base_uri}/#{service_name}/GeometryServer"
    end
    
    def service_uri_for(service)
      "#{@uri}/#{service}"
    end

    def geometry_service_name (base_uri)
      service_info = Lookup.get(base_uri, {'f' => 'json'})
      service_info.services.select do |s|
        return s.name unless s.type != 'GeometryServer'
      end
    end
  end
end
