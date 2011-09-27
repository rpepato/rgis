require 'rgis/lookup'

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
  
  def self.project(uri, input_reference, output_reference, options = {})
    json = self.at(uri)
  end

  private
  
  def self.at(uri)
    Lookup.search(uri)
  end

  
end