require 'rgis/request'
require 'rgis/services/geometry_service'
require 'json'

module RGis
  
  # The RGis envelope class represents an envelope geometry type. An envelope is a closed polygon (a square or a rectangle) that defines some
  # extent to perform GIS operations over it
  # To create an instance of the envelope object, you'll need to previously create two instances of RGis Point objects and pass these objects to the constructor of the envelope. The first argument represents the lower left of the extent (aka xmin and ymin coordinates). The second argument represents the upper right of the extent (aka xmax and ymax coordinates).
  #   
  #  lower_left = RGis::Point.new(-46.23477632, -34.27347253)
  #  upper_right = RGis::Point.new(-22.7364552, -7.882377643)
  #  envelope = RGis::Envelope.new(lower_left, upper_right)  
  class Envelope
    include RGis::Services::GeometryService
    
    # RGis point objects representing the lower left and the upper right point of the current envelope
    attr_accessor :lower_left_point, :upper_right_point
    
    # Initializes an instance of an envelope object. You must pass two RGis Point objects to construct and instance of envelope object. 
    # If you try to pass in an instance of any other type, you'll receive a TypeError. 
    def initialize(lower_left_point, upper_right_point)
      
      raise TypeError, "You should provide two RGis point objects to construct an envelope" unless lower_left_point.is_a?(RGis::Point) && upper_right_point.is_a?(RGis::Point)
             
      @lower_left_point = lower_left_point
      @upper_right_point = upper_right_point
      
    end
    
    # Compare the current envelope instance with another envelope instance passed as a parameter for equality. The envelopes are evaluated as equals when its lower left and upper right points match on both instances. Otherwise, the method will return false
    def ==(other)
      self.lower_left_point == other.lower_left_point && self.upper_right_point == other.upper_right_point
    end
    
    # Returns the current envelope instance as an array of array. The array returned is a one-dimensional array with two elements (two inner arrays inside). The first element of the array is an inner array containing the x and y coordinates of the lower left point and the second element of the array is an inner array containing the x and y coordinates of the upper right point
    def to_array
      [{:xmin => xmin, :ymin => ymin, :xmax => xmax, :ymax => ymax}]
    end
    
    # Returns the minimun value for the x axis of the current extent represented by this instance
    def xmin
      lower_left_point.x
    end

    # Returns the minimun value for the y axis of the current extent represented by this instance    
    def ymin
      lower_left_point.y
    end
    
    # Returns the maximun value for the x axis of the current extent represented by this instance
    def xmax
      upper_right_point.x
    end
    
    # Returns the maximun value for the y axis of the current extent represented by this instance    
    def ymax
      upper_right_point.y
    end
    
    # Creates a hash from the current instance (using the hashie gem) to be used for json generation    
    def to_hash #:nodoc:
      request = Request.new
      request.geometryType = RGis::Helper::GEOMETRY_TYPES[:envelope]
      request.geometries = to_array
      request
    end
    
    # Converts the current instance to a json representation expected for the esri rest api. 
    # For example:
    #   lower_left_point = RGis::Point.new(-46.23477632, -34.27347253)
    #   upper_right_point = RGis::Point.new(-37.2342324, -12.23452346)
    #   envelope = RGis::Envelope(lower_left_point, upper_right_point)
    #   puts envelope.to_json
    #   
    #   => {"geometryType":"esriGeometryEnvelope","geometries":[{"xmin":-46.23477632,"ymin":-34.27347253, "xmax": -37.2342324, "ymax": -12.23452346}]}
    def to_json
      JSON.unparse(to_hash)
    end
    
  end
end