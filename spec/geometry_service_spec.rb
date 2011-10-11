require 'spec_helper'   

describe "Lookup details from arcgis rest directory services" do
  
  before (:each) do
    @gs = RGis::GeometryService.new('http://sampleserver1.arcgisonline.com/ArcGIS/rest/services')
  end

  it "should initialize a geometry service from a uri" do
    @gs.uri.should == 'http://sampleserver1.arcgisonline.com/ArcGIS/rest/services/Geometry/GeometryServer'
  end

  it "should initialize a geometry service from a uri with slash in the end of service name" do
    gs = RGis::GeometryService.new('http://sampleserver1.arcgisonline.com/ArcGIS/rest/services/')
    gs.uri.should == 'http://sampleserver1.arcgisonline.com/ArcGIS/rest/services/Geometry/GeometryServer'
  end

  it "should reproject a point from 4326 SR to 102113" do
    @gs.project(4326, 102113, :point => [19.109209, 34.1928918184256]).geometries.should =~ [{'x' => 2127227.41534224, 'y' => 4054732.18582985}]
    @gs.project(4326, 102113, :point => [[19.109209, 34.1928918184256]]).geometries.should =~ [{'x' => 2127227.41534224, 'y' => 4054732.18582985}]
  end
  
  it "should simplify geometries in 4326 projection" do                                           
     geometry = {
        :geometryType => RGis::Helper::GEOMETRY_TYPES[:point],
        :geometries => [
          {:x => -104.53, :y => 34.74},
          {:x => -63.53, :y => 10.23}
          ]
      }
    @gs.simplify(4326, geometry).geometries.should =~ [{'x' => -104.53, 'y' => 34.74}, {'x' => -63.53, 'y' => 10.23}]
  end
  
  it "should perform a buffer around a simple geometry" do
    geometry = {
       :geometryType => RGis::Helper::GEOMETRY_TYPES[:point],
       :geometries => [
         {:x => -104.53, :y => 34.74},
         {:x => -63.53, :y => 10.23}
         ]
     }
     
     params = {
       :outSR => 4326,
       :bufferSR => 102113,
       :distances => 0.01,  
       :unit => RGis::Helper::UNIT_TYPES[:meter],
       :unionResults => false
     }      
     
     return_value = [
         {
           'rings' => 
           [
             [
               [-104.53, 34.7400000738187], 
               [-104.529999974692, 34.7400000708286], 
               [-104.529999951433, 34.7400000621003], 
               [-104.52999993211, 34.740000048341], 
               [-104.529999918286, 34.7400000306654], 
               [-104.529999911083, 34.7400000105055], 
               [-104.529999911083, 34.7399999894945], 
               [-104.529999918286, 34.7399999693346], 
               [-104.52999993211, 34.739999951659], 
               [-104.529999951433, 34.7399999378997], 
               [-104.529999974692, 34.7399999291714], 
               [-104.53, 34.7399999261813], 
               [-104.530000025308, 34.7399999291714], 
               [-104.530000048567, 34.7399999378997], 
               [-104.53000006789, 34.739999951659], 
               [-104.530000081714, 34.7399999693346], 
               [-104.530000088917, 34.7399999894945], 
               [-104.530000088917, 34.7400000105055], 
               [-104.530000081714, 34.7400000306654], 
               [-104.53000006789, 34.740000048341], 
               [-104.530000048567, 34.7400000621003], 
               [-104.530000025308, 34.7400000708286], 
               [-104.53, 34.7400000738187]
             ]
           ]
         }, 
         {
           'rings' => 
           [
             [
               [-63.53, 10.2300000884034], 
               [-63.5299999746915, 10.2300000848225], 
               [-63.5299999514334, 10.2300000743697], 
               [-63.5299999321099, 10.2300000578919], 
               [-63.5299999182864, 10.2300000367241], 
               [-63.5299999110828, 10.2300000125811], 
               [-63.5299999110828, 10.2299999874189], 
               [-63.5299999182864, 10.2299999632759], 
               [-63.5299999321099, 10.229999942108], 
               [-63.5299999514334, 10.2299999256303], 
               [-63.5299999746915, 10.2299999151775], 
               [-63.53, 10.2299999115965], 
               [-63.5300000253085, 10.2299999151775], 
               [-63.5300000485666, 10.2299999256303], 
               [-63.5300000678901, 10.229999942108], 
               [-63.5300000817136, 10.2299999632759], 
               [-63.5300000889172, 10.2299999874189], 
               [-63.5300000889172, 10.2300000125811], 
               [-63.5300000817136, 10.2300000367241], 
               [-63.5300000678901, 10.2300000578919], 
               [-63.5300000485666, 10.2300000743697], 
               [-63.5300000253085, 10.2300000848225], 
               [-63.53, 10.2300000884034]
             ]
           ]
         }
       ]
            
     @gs.buffer(4326, geometry, params).geometries.should =~ return_value

  end
  
end
