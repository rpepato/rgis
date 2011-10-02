require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "test lookup helper class" do
  
  it "should parse a hash to http query string" do
    RGis::Lookup.hash_to_querystring(:f => 'json').should == "f=json"
    RGis::Lookup.hash_to_querystring({:query => 'string', :test => 'test'}).should == "query=string&test=test"
    RGis::Lookup.hash_to_querystring({:query => 'string', :number => 1}).should == "query=string&number=1"
  end

  it "should return a empty string for a empty hash" do
    RGis::Lookup.hash_to_querystring().should == ""
  end

  it "should return a uri from same uri" do
    RGis::Lookup.prepare_uri('http://sampleserver1.arcgisonline.com/ArcGIS/rest').to_s.should == "http://sampleserver1.arcgisonline.com/ArcGIS/rest"
  end
  
  it "should return a uri with query string from same uri with query string" do
    RGis::Lookup.prepare_uri('http://sampleserver1.arcgisonline.com/ArcGIS/rest?f=json').to_s.should == "http://sampleserver1.arcgisonline.com/ArcGIS/rest?f=json"
  end

  it "should return a uri with query string from uri without query string" do
    RGis::Lookup.prepare_uri('http://sampleserver1.arcgisonline.com/ArcGIS/rest', :f => 'json').to_s.should == "http://sampleserver1.arcgisonline.com/ArcGIS/rest?f=json"
    RGis::Lookup.prepare_uri('http://sampleserver1.arcgisonline.com/ArcGIS/rest', {:query => 'string', :test => 'test'}).to_s.should == "http://sampleserver1.arcgisonline.com/ArcGIS/rest?query=string&test=test"
  end

  it "should return a uri with query string from uri with query string" do
    RGis::Lookup.prepare_uri('http://sampleserver1.arcgisonline.com/ArcGIS/rest?f=json', {:query => 'string', :test => 'test'}).to_s.should == "http://sampleserver1.arcgisonline.com/ArcGIS/rest?f=json&query=string&test=test"
  end

  it "should get a information from arcgis services directory" do
    response = RGis::Lookup.get('http://sampleserver1.arcgisonline.com/ArcGIS/rest/services', :f => 'json')
    response.currentVersion.should == 10.01
    response.folders.count == 7
    response.services.count == 1
  end

end
