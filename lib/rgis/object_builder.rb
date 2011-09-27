require 'json'

module RGis
  class ObjectBuilder
    # Builds a Ruby object from its JSON representation
    def self.from_json (json_hash)
      def initialize(json_hash)
        json_hash.each do |k,v|
          self.instance_variable_set("@#{k}", v)  ## create and initialize an instance variable for this key/value pair
          self.class.send(:define_method, k, proc{self.instance_variable_get("@#{k}")})  ## create the getter that returns the instance variable
          self.class.send(:define_method, "#{k}=", proc{|v| self.instance_variable_set("@#{k}", v)})  ## create the setter that sets the instance variable
        end
      end
    end
  end
end
