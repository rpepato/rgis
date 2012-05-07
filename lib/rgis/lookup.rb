require 'json'
require 'net/http'
require 'uri'
require 'rgis/response'

module RGis
  class Lookup

    # gets a new URI and returns an object representation from JSON returned 
    def self.get(uri, args={})
      response  = Net::HTTP.get_response(Lookup.prepare_uri(uri, args)).body
      # returns an object from json
      Response.new(JSON.parse(response))
    end
    
    def self.post(uri, args={})
      u = URI.parse(uri)
      response, body = Net::HTTP.post_form(URI.parse(uri), args)
      if (ENV["RUBY_VERSION"].index("1.9.2"))
        Response.new(JSON.parse(body))        
      else
        Response.new(JSON.parse(response.body))
      end
      #response =  Curl::Easy.http_post(uri, JSON.unparse(args)) do |curl|
      #              curl.headers['Accept'] = 'application/json'
      #              curl.headers['Content-Type'] = 'application/json'
      #              curl.headers['Api-Version'] = '2.2'
      #            end
      #Response.New(JSON.parse(response.body_str))
    end
    
    # convert a hash to http query string
    # by http://justanothercoder.wordpress.com/2009/04/24/converting-a-hash-to-a-query-string-in-ruby/
    def self.hash_to_querystring(hash={})
      hash.keys.inject('') do |query_string, key|
        query_string << '&' unless key.to_s == hash.keys.first.to_s
        query_string << "#{URI.encode(key.to_s)}=#{URI.encode(hash[key].to_s)}"
      end
    end
    
    # prepare uri
    def self.prepare_uri(uri, query={})
      parse = URI.parse(uri)
      query_string = Lookup.hash_to_querystring(query)
      if !query_string.empty?
        if parse.query
          parse.query << "&" << query_string if parse.query
        else
          parse.query = query_string
        end
      end
      parse
    end

  end
end