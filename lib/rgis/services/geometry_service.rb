require 'rgis/lookup'
require 'rgis/request'

module RGis
  module Services
    module GeometryService
 
      def project(params = {})
        response = project_geometry(params)
        Point.new(response.geometries[0][:x], response.geometries[0][:y])
      end
      
      def project!(params = {})
        response = project_geometry(params)
        self.x = Float(response.geometries[0][:x])
        self.y = Float(response.geometries[0][:y])
        self
      end 
            
      private
      
      def project_geometry(params = {})
        request = Request.new  
        request.f = 'json'      
        request.inSR = params[:from]
        request.outSR = params[:to]
        request.geometries = self.to_json
        response = Lookup.post("#{RGis::Services::ServiceDirectory.geometry_service_uri}/project", request)
        response        
      end

    end

  end

end

