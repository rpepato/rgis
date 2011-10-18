require 'rgis/lookup'
require 'rgis/request'

module RGis
  module Services
    module GeometryService
 
      def project(params = {})
        response = project_geometry(params)
        if result_type?(response) == RGis::Helper::GEOMETRY_TYPES[:point]
          Point.new(response.geometries[0][:x], response.geometries[0][:y])
        elsif result_type?(response) == RGis::Helper::GEOMETRY_TYPES[:polygon]
          polygon = RGis::Polygon.new()
          response.geometries[0].rings.each do |ring|
            r = RGis::Ring.new()
            ring.each do |point|
              r.points << Point.new(point[0], point[1])
            end
            polygon.rings << r
          end
          polygon
        end
      end
      
      def project!(params = {})
        response = project_geometry(params)
        if result_type?(response) == RGis::Helper::GEOMETRY_TYPES[:point]
          self.x = Float(response.geometries[0][:x])
          self.y = Float(response.geometries[0][:y])
          self
        end
      end 
            
      private
      
      def result_type? (geometry)
        nil unless geometry.respond_to?('geometries')
        RGis::Helper::GEOMETRY_TYPES[:point] if geometry.geometries[0].respond_to?('x')
        RGis::Helper::GEOMETRY_TYPES[:polygon] if geometry.geometries[0].respond_to?('rings')
      end
      
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

