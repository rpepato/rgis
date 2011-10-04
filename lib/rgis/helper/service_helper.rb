require 'rgis/lookup'

module RGis
  module Helper

    SERVICE_TYPES = {
      :geometry_service => 'GeometryServer',
    }

    class ServiceHelper

      def self.service_uri (base_uri, type)
        base_uri = base_uri.chop if base_uri.end_with?('/')        
        service_name = service_name(base_uri, type)
        "#{base_uri}/#{service_name}/#{SERVICE_TYPES[type]}"
      end
          
      def self.service_name (base_uri, type)
        raise ArgumentError, "invalid service type" unless SERVICE_TYPES[type] != nil
        service_info = Lookup.get(base_uri, {'f' => 'json'})
        service_info.services.select do |s|
          return s.name unless s.type != SERVICE_TYPES[type]
        end
      end

    end
  
  end
end
