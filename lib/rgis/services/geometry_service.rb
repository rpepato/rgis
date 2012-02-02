require 'rgis/lookup'
require 'rgis/request'

module RGis
  module Services
    module GeometryService
 
      def project(params = {})
        pre_validate_request
        response = project_geometry(params)
        parse_result(response)
      end
      
      def project!(params = {})
        pre_validate_request
        response = project_geometry(params)
        parse_result_for_bang_method(response)
        self
      end 
      
      def simplify(params = {})
        pre_validate_request
        raise TypeError, "Simplify operation is not supported on envelope types" if self.is_a?(Envelope)
        response = simplify_geometry(params)
        parse_result(response)
      end
      
      def buffer(params = {})
        pre_validate_request
        raise TypeError, "Buffer operation is not supported on envelope types" if self.is_a?(Envelope)        
        response = buffer_geometry(params)
        parse_result(response)
      end
      
      def area_and_perimeter(params = {})
        pre_validate_request
        raise TypeError, "Area and perimeter operation is allowed only for polygon type" unless self.is_a?(Polygon)
        response = area_and_perimeter_for_geometry(params)
        {:area => response[:areas], :perimeter => response[:lengths]}
      end
      
      def lengths(params = {})
        pre_validate_request
        raise TypeError, "Lengths operation is allowed only for polyline type" unless self.is_a?(Polyline)
        response = lengths_for_geometry(params)
        response[:lengths]
      end 
      
      def label_points(params = {})
        pre_validate_request
        raise TypeError, "Label points operation is allowed only for polygon type" unless self.is_a?(Polygon)
        response = label_points_for_geometry(params)
        response[:labelPoints].collect { |l| {:x => l[:x], :y => l[:y]}  }
      end
      
      def generalize(params = {})
        pre_validate_request
        raise TypeError, "Generalize opertion is allowed only for polygon or polyline types" unless self.is_a?(Polygon) || self.is_a?(Polyline)
        parse_result(generalize_for_geometry(params))
      end
      
      private
      
      def pre_validate_request
        raise "The operation couldn't be performed while the geometry is in an invalid state" unless self.valid?
      end
      
      def result_type? (geometry)
        return nil unless geometry.respond_to?('geometries')
        return RGis::Helper::GEOMETRY_TYPES[:point] if geometry.geometries[0].respond_to?(:x)
        return RGis::Helper::GEOMETRY_TYPES[:polygon] if geometry.geometries[0].respond_to?('rings')
        return RGis::Helper::GEOMETRY_TYPES[:polyline] if geometry.geometries[0].respond_to?('paths')
        return RGis::Helper::GEOMETRY_TYPES[:envelope] if geometry.geometries[0].respond_to?(:xmax)
        return RGis::Helper::GEOMETRY_TYPES[:multipoint] if geometry.geometries[0].respond_to?(:points)
      end
      
      def parse_result(response)
        if result_type?(response) == RGis::Helper::GEOMETRY_TYPES[:point]
          Point.new(response.geometries[0][:x], response.geometries[0][:y])
        elsif result_type?(response) == RGis::Helper::GEOMETRY_TYPES[:polygon]
          polygon = RGis::Polygon.new()
          response.geometries[0].rings.each do |ring|
            r = RGis::Ring.new()
            r.points = ring.collect { |point| Point.new(point[0], point[1])}
            polygon.rings << r
          end
          polygon
        elsif result_type?(response) == RGis::Helper::GEOMETRY_TYPES[:polyline]
          polyline = RGis::Polyline.new()
          response.geometries[0].paths.each do |path|
            p = RGis::Path.new()
            p.points = path.collect { |point| Point.new(point[0], point[1])}
            polyline.paths << p
          end
          polyline
        elsif result_type?(response) == RGis::Helper::GEOMETRY_TYPES[:envelope]
          lower_left_point = Point.new(response.geometries[0][:xmin], response.geometries[0][:ymin])
          upper_right_point = Point.new(response.geometries[0][:xmax], response.geometries[0][:ymax])
          Envelope.new(lower_left_point, upper_right_point)
        elsif result_type?(response) == RGis::Helper::GEOMETRY_TYPES[:multipoint]
          multipoint = RGis::Multipoint.new()
          response.geometries[0].points.each do |point|
            multipoint.points << RGis::Point.new(point[0], point[1])
          end
          multipoint          
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
        elsif result_type?(response) == RGis::Helper::GEOMETRY_TYPES[:envelope]
          lower_left_point = Point.new(response.geometries[0][:xmin], response.geometries[0][:ymin])
          upper_right_point = Point.new(response.geometries[0][:xmax], response.geometries[0][:ymax])
          self.lower_left_point = lower_left_point
          self.upper_right_point = upper_right_point
        elsif result_type?(response) == RGis::Helper::GEOMETRY_TYPES[:multipoint] 
          response.geometries[0].points.each_with_index do |point, point_index|
            self.points[point_index] = RGis::Point.new(point[0], point[1])
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
      
      def area_and_perimeter_for_geometry(params = {})
        request = Request.new
        request.f = 'json'
        request.sr = params[:spatial_reference]
        request.lengthUnit = params[:length_unit]
        request.areaUnit = JSON.unparse({:areaUnit => params[:area_unit]})
        request.polygons = self.rings_to_json
        response = Lookup.post("#{RGis::Services::ServiceDirectory.geometry_service_uri}/areasAndLengths", request)
        response        
      end
      
      def lengths_for_geometry(params = {})
        request = Request.new
        request.f = 'json'
        request.sr = params[:spatial_reference]
        request.lengthUnit = params[:length_unit]
        request.geodesic = params[:geodesic]
        request.polylines = self.paths_to_json
        response = Lookup.post("#{RGis::Services::ServiceDirectory.geometry_service_uri}/lengths", request)
      end
      
      def label_points_for_geometry(params = {})
        request = Request.new
        request.f = 'json'
        request.sr = params[:spatial_reference]
        request.polygons = self.rings_to_json
        Lookup.post("#{RGis::Services::ServiceDirectory.geometry_service_uri}/labelPoints", request)
      end
      
      def generalize_for_geometry(params = {})
        request = Request.new
        request.f = 'json'
        request.sr = params[:spatial_reference]
        request.maxDeviation = params[:max_deviation]
        request.deviationUnit = params[:deviation_unit]
        request.geometries = self.to_json
        Lookup.post("#{RGis::Services::ServiceDirectory.geometry_service_uri}/generalize", request)
      end
      
    end
  end
end

