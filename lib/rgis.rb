require 'rgis/lookup'
require 'net/http'

module RGis  
  
  GEOMETRY_TYPES = {
    :point => "esriGeometryPoint"
  }
  
  def self.services_at(uri)
    json = self.at(uri)
    json["folders"]
  end

  def self.version_at(uri)
    json = self.at(uri)
    json["currentVersion"]
  end
  
  def self.geometry_service(uri)
    json = self.at(uri)
    geometryService = json["services"].select do |s|
      return s['name'] unless s['type'] != 'GeometryServer' 
    end
  end

  def self.has_geometry_service?(uri)
    geometry_service(uri) != nil
  end
  
  def self.project(uri, input_spatial_reference, output_spatial_reference, geometry = {})    
    args = {
      'f' => 'json',
      'inSR' => input_spatial_reference,
      'outSR' => output_spatial_reference,
      'geometries' => JSON.unparse({
        'geometryType' => GEOMETRY_TYPES[geometry.keys.first],
        'geometries' => [geometry[geometry.keys.first]]
      })
    }
    
    res, data = Lookup.post(uri, args)
    JSON.parse(data)['geometries']
  end

  private
  
  def self.at(uri)
    Lookup.search(uri)
  end

  
end