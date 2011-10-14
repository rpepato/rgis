require 'rgis/lookup'
require 'rgis/request'

module RGis
  module Services
    module GeometryService


 
      def project(params = {})
        r = Request.new  
        r.f = 'json'      
        r.inSR = params[:from]
        r.outSR = params[:to]
        r.geometries = self.to_json
        response = Lookup.post("#{RGis::Services::ServiceDirectory.geometry_service_uri}/project", r)
        Point.new(response.geometries[0][:x], response.geometries[0][:y])
      end

    end

  end

end

