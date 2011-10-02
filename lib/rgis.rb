require 'rgis/lookup'
require 'rgis/geometry_service'
require 'net/http'

module RGis  
  
  # validate if a geometry argument is corret
  def validate_geometry_arg(arg)
    raise ArgumentError, "geometry argument must be a Array or Hash" if !arg.is_a?(Array) || !arg.is_a?(Hash)
  end
  
end