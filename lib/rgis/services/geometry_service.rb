require 'rgis/lookup'
require 'rgis/request'

module RGis
  module Services
    module GeometryService
 
      def project(params = {})
        response = project_geometry(params)
        parse_result(response)
      end
      
      def project!(params = {})
        response = project_geometry(params)
        parse_result_for_bang_method(response)
        self
      end 
      
      def simplify(params = {})
        response = simplify_geometry(params)
        parse_result(response)
      end
      
      def buffer(params = {})
        response = buffer_geometry(params)
        parse_result(response)
      end
                  
      private
      
      def result_type? (geometry)
        return nil unless geometry.respond_to?('geometries')
        return RGis::Helper::GEOMETRY_TYPES[:point] if geometry.geometries[0].respond_to?(:x)
        return RGis::Helper::GEOMETRY_TYPES[:polygon] if geometry.geometries[0].respond_to?('rings')
        return RGis::Helper::GEOMETRY_TYPES[:polyline] if geometry.geometries[0].respond_to?('paths')
      end
      
      def parse_result(response)
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
        elsif result_type?(response) == RGis::Helper::GEOMETRY_TYPES[:polyline]
          polyline = RGis::Polyline.new()
          response.geometries[0].paths.each do |path|
            p = RGis::Path.new()
            path.each do |point|
              p.points << Point.new(point[0],point[1])
            end
            polyline.paths << p
          end
          polyline
        end        
      end
      
      def parse_result_for_bang_method(response)
        if result_type?(response) == RGis::Helper::GEOMETRY_TYPES[:point]
          self.x = Float(response.geometries[0][:x])
          self.y = Float(response.geometries[0][:y])
        elsif result_type?(response) == RGis::Helper::GEOMETRY_TYPES[:polygon]
          response.geometries[0].rings.each_with_index do |ring, ring_index|
            ring.each_with_index do |point, point_index|  
              self.rings[ring_index].points[point_index] = RGis::Point.new(point[0], point[1])
            end
          end
        elsif result_type?(response) == RGis::Helper::GEOMETRY_TYPES[:polyline]
          response.geometries[0].paths.each_with_index do |path, path_index|
            path.each_with_index do |point, point_index|
              self.paths[path_index].points[point_index] = RGis::Point.new(point[0], point[1])
            end
          end
        end        
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
      
      def simplify_geometry(params = {})
        request = Request.new
        request.f = 'json'
        request.sr = params[:spatial_reference]
        request.geometries = self.to_json
        response = Lookup.post("#{RGis::Services::ServiceDirectory.geometry_service_uri}/simplify", request)
        response
      end
      
      def buffer_geometry(params = {})
        request = Request.new
        request.f = 'json'
        request.inSR = params[:input_spatial_reference]
        request.outSR = params[:output_spatial_reference]
        request.bufferSR = params[:buffer_spatial_reference]
        request.distances = params[:distances]
        request.unit = params[:distance_units]
        request.unionResults = params[:union_results]
        request.geometries = self.to_json
        response = Lookup.post("#{RGis::Services::ServiceDirectory.geometry_service_uri}/buffer", request)
        response
      end

    end

  end

end

