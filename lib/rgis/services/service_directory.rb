require 'singleton'
require 'rgis/helper'

module RGis
  module Services
    class ServiceDirectory
      
      def self.uri= uri
        raise ArgumentError, "You should set a valid uri" unless valid_uri?(uri)
        @@uri = uri
      end

      def self.geometry_service_uri
        raise ArgumentError, "You should set a value for uri before calling geometry service" unless valid_uri?(@@uri)
        @@geometry_services ||= RGis::Helper::ServiceHelper.service_uri(@@uri, :geometry_service)
      end 

      private

      def self.valid_uri? (uri)
        uri != nil && uri != ""
      end
    end
  end
end
