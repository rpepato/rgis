require 'rgis/lookup'

module RGis
  module Helper
    
    # valid types for element arrays
    VALID_TYPES = [Fixnum, Bignum, Float, Array]

    # valid geometry types
    GEOMETRY_TYPES = {
      :point => 'esriGeometryPoint',
      :polygon => 'esriGeometryPolygon',
      :envelope => 'esriGeometryEnvelope',
      :polyline => 'esriGeometryPolyline'
    }      
    
    # ESRI area unit types
    AREA_UNIT_TYPES = {
      :square_inches => 'esriSquareInches',
      :square_feet => 'esriSquareFeet',
      :square_yards => 'esriSquareYards',
      :acres => 'esriAcres',
      :square_miles => 'esriSquareMiles',
      :square_millimiters => 'esriSquareMillimiters',
      :square_centimeters => 'esriSquareCentimeters',
      :square_decimeters => 'esriSquareDecimeters',
      :square_meters => 'esriSquareMeters',
      :ares => 'esriSquareAres',
      :hectares => 'esriHectares',
      :square_kilometers => 'esriSquareKilometers'
    }
    
    # valid unit types for WKID (Well Known IDs)
    UNIT_TYPES = {
      :meter => 9001,
      :german_meter => 9031,
      :foot => 9002,
      :survey_foot => 9003,
      :clarke_foot => 9005,
      :fathom => 9014,
      :nautical_mile => 9030,
      :survey_chain => 9033,
      :survey_link => 9034,
      :survey_mile => 9035,
      :kilometer => 9036,
      :clarke_yard => 9037,
      :clarke_chain => 9038,
      :clarke_link => 9039,
      :sears_yard => 9040,
      :sears_foot => 9041,
      :sears_chain => 9042,
      :sears_link => 9043,
      :benoit_1895a_yard => 9050,
      :benoit_1895a_foot => 9051,
      :benoit_1895a_chain => 9052,
      :benoit_1895a_link => 9053,
      :benoit_1895b_yard => 9060,
      :benoit_1895b_foot => 9061,
      :benoit_1895b_chain => 9062,
      :benoit_1895b_link => 9063,
      :indian_foot => 9080,
      :indian_1937foot => 9081,
      :indian_1962foot => 9082,
      :indian_1975foot => 9083,
      :indian_yard => 9084,
      :indian_1937_yard => 9085,
      :indian_1962_yard => 9086,
      :indian_1975_yard => 9087,
      :foot_1865 => 9070,
      :radian => 9101,
      :degree => 9102,
      :arc_minute => 9103,
      :arc_second => 9104,
      :grad => 9105,
      :gon => 9106,
      :micro_radian => 9109,
      :arc_minute_centesimal => 9112,
      :arc_second_centesimal => 9113,
      :mil_6400 => 9114,
      :british_1936_foot => 9095,
      :goldcoast_foot => 9094,
      :international_chain => 109003,
      :international_link => 109004,
      :international_yard => 109001,
      :statute_mile => 9093,
      :survey_yard => 109002,
      :kilometer_50_length => 109030,
      :kilometer_150_length => 109031,
      :decimeter => 109005,
      :centimeter => 109006,
      :millimeter => 109007,
      :international_inch => 109008,
      :us_survey_inch => 109009,
      :international_rod => 109010,
      :us_survey_rod => 109011,
      :us_nautical_mile => 109012,
      :uk_nautical_mile => 109013
    }
   
    class GeometryHelper
    
      # parse a array or hash into a geometry in order to be serialized to JSON or another format
      #
      # geometry can be a Array or a Hash
      def self.parse(geometry)
        if geometry.is_a?(Hash)
          self.parse_hash(geometry)
        else
          raise ArgumentError, "argument geometry must a Hash"
        end
      end
    
      private 

      # parse an array into a geometry object
      def self.parse_array(array)
        if array.empty?
          raise ArgumentError, "geometry must have at least one element"
        end

        # should be a point
        if array.count == 1
          if !array[0].is_a?(Array)
            raise ArgumentError, "element of array geometry must have at least 2 numeric elements"
          end
          return self.parse_point(array[0])
        end
        
        # should be a point
        if array.count == 2 
          if array.count{|a| VALID_TYPES.include?(a.class)} == 2
            return self.parse_point(array)
          else
            raise ArgumentError, "elements of array geometry must have at only numeric elements"
          end
        end
        
        # polygon
        if array.first == array.last
          return self.parse_polygon(array)
        else
          return self.parse_polyline(array)
        end
        
      end

      # parse a hash into a geometry object
      def self.parse_hash(hash)
        if hash.empty?
          raise ArgumentError, "geometry must have at least one element"
        end
        
        valid_hash = hash.select { |key, value|  GEOMETRY_TYPES.has_key?(key)  }
        geometry_type = valid_hash.keys.first
        value = valid_hash[geometry_type]
        
        # points
        if geometry_type == :point
          if value.is_a?(Array)
              return self.parse_array(value)
          end
          if value.is_a?(Hash)
              if value.empty?
                raise ArgumentError, "geometry must have at least one element"
              end
              if value.has_key?(:x) && value.has_key?(:y)
                if value.select{ |key, value| !VALID_TYPES.include?(value.class) }.length > 0
                  raise ArgumentError, "elements of hash geometry must have at only numeric elements"
                end
                return self.parse_point(value)
              end
          end
        end
        
        if geometry_type == :envelope
          return self.parse_envelope(value)
        end

        if geometry_type == :polygon
          return self.parse_polygon(value)
        end

        if geometry_type == :polyline
          return self.parse_polyline(value)
        end

        
      end
      
      # parse a array of point to point object 
      def self.parse_point(array)
        if array.is_a?(Array)
          return { :geometryType => GEOMETRY_TYPES[:point], :geometries => [{ :x => array[0], :y => array[1] }] }
        end
        return { :geometryType => GEOMETRY_TYPES[:point], :geometries => [{ :x => array[:x], :y => array[:y] }] }
      end
    
      # parse a array of point to polygon object 
      def self.parse_polygon(array)
        return { :geometryType => GEOMETRY_TYPES[:polygon], :rings => [array] }
      end
    
      # parse a array of point to polyline object 
      def self.parse_polyline(array)
        return { :geometryType => GEOMETRY_TYPES[:polyline], :paths => [array] }
      end

      # parse a hash to envelope
      def self.parse_envelope(array)
        if array.is_a?(Array)
          return { :geometryType => GEOMETRY_TYPES[:envelope], :geometries => { :xmin => array[0][0], :ymin => array[0][1], :xmax => array[1][0], :ymax => array[1][1] } }
        end
        return { :geometryType => GEOMETRY_TYPES[:envelope], :geometries => array }
      end
    
    end
  end
end