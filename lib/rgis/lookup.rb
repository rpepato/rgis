require 'json'
require 'net/http'
require 'uri'
require 'rgis/object_builder'

module RGis
  class Lookup
    # gets a new URI and returns an object representation from JSON returned 
    def self.search(uri)
      response = Net::HTTP.get_response(URI.parse(uri)).body
      # returns an object from json
      # ObjectBuilder.from_json(JSON.parse(response))
      JSON.parse(response)
    end
    
    def self.post(uri, args)
      Net::HTTP.post_form(URI.parse(uri), args)
    end
  end
end