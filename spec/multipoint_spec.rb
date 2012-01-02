require 'spec_helper'

describe 'Multipoint Geometry' do
  
  before (:each) do
    RGis::Services::ServiceDirectory.uri = "http://sampleserver1.arcgisonline.com/ArcGIS/rest/services"
    @multipoint = RGis::Multipoint.new()
    @multipoint.points << RGis::Point.new(-97.06138,32.837)
    @multipoint.points << RGis::Point.new(-97.06133,32.836)
    @multipoint.points << RGis::Point.new(-97.06124,32.834)
    @multipoint.points << RGis::Point.new(-97.06127,32.832)
    
    @cloned_multipoint = RGis::Multipoint.new()
    @cloned_multipoint.points << RGis::Point.new(-97.06138,32.837)
    @cloned_multipoint.points << RGis::Point.new(-97.06133,32.836)
    @cloned_multipoint.points << RGis::Point.new(-97.06124,32.834)
    @cloned_multipoint.points << RGis::Point.new(-97.06127,32.832)
  end

  it "should compare equal multipoints as equals" do
    @multipoint.should == @cloned_multipoint
    @cloned_multipoint.points.pop
    @multipoint.should_not == @cloned_multipoint
  end
  
  it "should be valid when it have at least one point" do
    @multipoint.should be_valid
    4.times { @multipoint.points.pop }
    @multipoint.should_not be_valid
  end
  
  it "should convert a multipoint to a json representation expected by the esri api" do
    json = '{"geometryType":"esriGeometryMultipoint","geometries":[{"points":[[-97.06138,32.837],[-97.06133,32.836],[-97.06124,32.834],[-97.06127,32.832]]}]}'
    @multipoint.to_json.should == json
  end
  
  it "should project a multipoint from one spatial reference to another and return a new multipoint geometry" do
    VCR.use_cassette('multipoint_project', :record => :new_episodes) do
      projected_multipoint = RGis::Multipoint.new()
      projected_multipoint.points << RGis::Point.new(-0.000871917211517328, 0.000294979789848263)
      projected_multipoint.points << RGis::Point.new(-0.000871916762359686, 0.000294970806689621)
      projected_multipoint.points << RGis::Point.new(-0.000871915953875931, 0.000294952840385059)
      projected_multipoint.points << RGis::Point.new(-0.000871916223370516, 0.000294934874080496)
    
      @multipoint.project(:from => 102100, :to => 4326).should == projected_multipoint
    end
  end
  
  it "should change point coordinates from a multipoint object when reprojected" do
    VCR.use_cassette('multipoint_project_bang', :record => :new_episodes) do
      @multipoint.project!(:from => 102100, :to => 4326)
      @multipoint.points[0].should == RGis::Point.new(-0.000871917211517328, 0.000294979789848263)
      @multipoint.points[1].should == RGis::Point.new(-0.000871916762359686, 0.000294970806689621)
      @multipoint.points[2].should == RGis::Point.new(-0.000871915953875931, 0.000294952840385059)
      @multipoint.points[3].should == RGis::Point.new(-0.000871916223370516, 0.000294934874080496)
    end
  end
  
  it "should simplify a geometry" do
    VCR.use_cassette('multipoint_simplify', :record => :new_episodes) do
      simplified_multipoint = RGis::Multipoint.new()
      simplified_multipoint.points << RGis::Point.new(-97.06138, 32.837)
      simplified_multipoint.points << RGis::Point.new(-97.0613299999999, 32.8360000000001)
      simplified_multipoint.points << RGis::Point.new(-97.06127, 32.8320000000001)
      simplified_multipoint.points << RGis::Point.new(-97.0612399999999, 32.8340000000001)
      
      @multipoint.simplify(:spatial_reference => 4326).should == simplified_multipoint
    end
  end
  
  it "should calculate buffer for a multipoint geometry" do
    polygon = RGis::Polygon.new()
    ring = RGis::Ring.new()
    ring.points << RGis::Point.new(-10806413.239, 3873178.6411) 
    ring.points << RGis::Point.new(-10806416.3537747, 3873239.98217147) 
    ring.points << RGis::Point.new(-10806417.1256494, 3873301.39742266) 
    ring.points << RGis::Point.new(-10806415.5535, 3873362.7974)
    ring.points << RGis::Point.new(-10806421.9749534, 3873426.57157531) 
    ring.points << RGis::Point.new(-10806425.8518366, 3873490.55087099) 
    ring.points << RGis::Point.new(-10806427.178, 3873554.6338)
    ring.points << RGis::Point.new(-10806431.7840502, 3873632.78013022) 
    ring.points << RGis::Point.new(-10806432.5845775, 3873711.05799287) 
    ring.points << RGis::Point.new(-10806429.5776879, 3873789.28217864) 
    ring.points << RGis::Point.new(-10806422.7704959, 3873867.26760524) 
    ring.points << RGis::Point.new(-10806412.1791075, 3873944.82975527) 
    ring.points << RGis::Point.new(-10806397.8285826, 3874021.78511284) 
    ring.points << RGis::Point.new(-10806379.7528751, 3874097.95159776) 
    ring.points << RGis::Point.new(-10806357.9947532, 3874173.14899635) 
    ring.points << RGis::Point.new(-10806332.6056975, 3874247.19938783) 
    ring.points << RGis::Point.new(-10806303.64578, 3874319.9275653)
    ring.points << RGis::Point.new(-10806271.183521, 3874391.1614503)
    ring.points << RGis::Point.new(-10806235.2957281, 3874460.73249992) 
    ring.points << RGis::Point.new(-10806196.0673135, 3874528.47610559) 
    ring.points << RGis::Point.new(-10806153.5910935, 3874594.2319826)
    ring.points << RGis::Point.new(-10806107.967569, 3874657.84454927)
    ring.points << RGis::Point.new(-10806059.3046876, 3874719.16329512) 
    ring.points << RGis::Point.new(-10806007.7175879, 3874778.04313695) 
    ring.points << RGis::Point.new(-10805953.3283277, 3874834.34476215) 
    ring.points << RGis::Point.new(-10805896.2655946, 3874887.93495826) 
    ring.points << RGis::Point.new(-10805836.664402, 3874938.68692823)
    ring.points << RGis::Point.new(-10805774.665769, 3874986.48059039)
    ring.points << RGis::Point.new(-10805710.4163877, 3875031.20286255) 
    ring.points << RGis::Point.new(-10805644.0682753, 3875072.74792961) 
    ring.points << RGis::Point.new(-10805575.7784146, 3875111.01749386) 
    ring.points << RGis::Point.new(-10805505.7083828, 3875145.92100764) 
    ring.points << RGis::Point.new(-10805434.0239692, 3875177.37588748) 
    ring.points << RGis::Point.new(-10805360.8947825, 3875205.3077096)
    ring.points << RGis::Point.new(-10805286.4938502, 3875229.6503859)
    ring.points << RGis::Point.new(-10805210.9972084, 3875250.34632042) 
    ring.points << RGis::Point.new(-10805134.583486, 3875267.34654553)
    ring.points << RGis::Point.new(-10805057.4334816, 3875280.61083788) 
    ring.points << RGis::Point.new(-10804979.729736, 3875290.10781348)
    ring.points << RGis::Point.new(-10804901.6561001, 3875295.81500202) 
    ring.points << RGis::Point.new(-10804823.3973, 3875297.7189)
    ring.points << RGis::Point.new(-10804744.4693791, 3875295.78228608) 
    ring.points << RGis::Point.new(-10804665.7314145, 3875289.97710591) 
    ring.points << RGis::Point.new(-10804587.3729056, 3875280.31733087) 
    ring.points << RGis::Point.new(-10804509.5824383, 3875266.82620919) 
    ring.points << RGis::Point.new(-10804432.5472313, 3875249.53621005) 
    ring.points << RGis::Point.new(-10804356.452686, 3875228.48894543)
    ring.points << RGis::Point.new(-10804281.4819396, 3875203.7350699)
    ring.points << RGis::Point.new(-10804207.8154246, 3875175.33415881) 
    ring.points << RGis::Point.new(-10804135.6304349, 3875143.35456481) 
    ring.points << RGis::Point.new(-10804065.1006985, 3875107.87325343) 
    ring.points << RGis::Point.new(-10803996.3959598, 3875068.97561778) 
    ring.points << RGis::Point.new(-10803929.6815711, 3875026.75527308) 
    ring.points << RGis::Point.new(-10803865.1180942, 3874981.31383131) 
    ring.points << RGis::Point.new(-10803802.8609146, 3874932.76065672) 
    ring.points << RGis::Point.new(-10803743.059867, 3874881.21260257)
    ring.points << RGis::Point.new(-10803685.8588751, 3874826.79372991) 
    ring.points << RGis::Point.new(-10803631.3956049, 3874769.63500904) 
    ring.points << RGis::Point.new(-10803579.8011335, 3874709.87400424) 
    ring.points << RGis::Point.new(-10803531.1996337, 3874647.65454275) 
    ring.points << RGis::Point.new(-10803485.708075, 3874583.12636856)
    ring.points << RGis::Point.new(-10803443.4359423, 3874516.44478209) 
    ring.points << RGis::Point.new(-10803404.4849723, 3874447.77026638) 
    ring.points << RGis::Point.new(-10803368.9489084, 3874377.26810086) 
    ring.points << RGis::Point.new(-10803336.9132757, 3874305.10796359) 
    ring.points << RGis::Point.new(-10803308.4551745, 3874231.46352287) 
    ring.points << RGis::Point.new(-10803283.643095, 3874156.51201929)
    ring.points << RGis::Point.new(-10803262.5367528, 3874080.43383916) 
    ring.points << RGis::Point.new(-10803245.1869445, 3874003.41208036) 
    ring.points << RGis::Point.new(-10803231.6354261, 3873925.6321117)
    ring.points << RGis::Point.new(-10803221.9148122, 3873847.28112677) 
    ring.points << RGis::Point.new(-10803216.0484973, 3873768.54769344) 
    ring.points << RGis::Point.new(-10803214.0506, 3873689.6213)
    ring.points << RGis::Point.new(-10803209.8083736, 3873621.15701969) 
    ring.points << RGis::Point.new(-10803208.487507, 3873552.57415394)
    ring.points << RGis::Point.new(-10803210.0904, 3873483.9973)
    ring.points << RGis::Point.new(-10803203.2598902, 3873415.04448459) 
    ring.points << RGis::Point.new(-10803199.4037809, 3873345.86156012) 
    ring.points << RGis::Point.new(-10803198.5292203, 3873276.57677275) 
    ring.points << RGis::Point.new(-10803200.6378296, 3873207.31855746) 
    ring.points << RGis::Point.new(-10803205.7257, 3873138.2153)
    ring.points << RGis::Point.new(-10803202.141971, 3873058.88335357)
    ring.points << RGis::Point.new(-10803202.4760292, 3872979.47120561) 
    ring.points << RGis::Point.new(-10803206.7270611, 3872900.17221717) 
    ring.points << RGis::Point.new(-10803214.8847158, 3872821.17947379) 
    ring.points << RGis::Point.new(-10803226.9291302, 3872742.68531528) 
    ring.points << RGis::Point.new(-10803242.8309774, 3872664.88086751) 
    ring.points << RGis::Point.new(-10803262.5515379, 3872587.9555769)
    ring.points << RGis::Point.new(-10803286.0427939, 3872512.09674927) 
    ring.points << RGis::Point.new(-10803313.2475464, 3872437.48909365) 
    ring.points << RGis::Point.new(-10803344.0995546, 3872364.31427262) 
    ring.points << RGis::Point.new(-10803378.5236965, 3872292.75045992) 
    ring.points << RGis::Point.new(-10803416.4361529, 3872222.97190667) 
    ring.points << RGis::Point.new(-10803457.7446103, 3872155.14851702) 
    ring.points << RGis::Point.new(-10803502.3484866, 3872089.44543449) 
    ring.points << RGis::Point.new(-10803550.1391757, 3872026.02263987) 
    ring.points << RGis::Point.new(-10803601.0003117, 3871965.03456163) 
    ring.points << RGis::Point.new(-10803654.8080525, 3871906.62969998) 
    ring.points << RGis::Point.new(-10803711.4313815, 3871850.95026522) 
    ring.points << RGis::Point.new(-10803770.7324261, 3871798.13183148) 
    ring.points << RGis::Point.new(-10803832.566794, 3871748.30300665)
    ring.points << RGis::Point.new(-10803896.7839244, 3871701.58511919) 
    ring.points << RGis::Point.new(-10803963.2274545, 3871658.09192273) 
    ring.points << RGis::Point.new(-10804031.7356008, 3871617.92931907) 
    ring.points << RGis::Point.new(-10804102.1415523, 3871581.19510036) 
    ring.points << RGis::Point.new(-10804174.2738774, 3871547.97871093) 
    ring.points << RGis::Point.new(-10804247.9569405, 3871518.36102954) 
    ring.points << RGis::Point.new(-10804323.0113304, 3871492.41417244) 
    ring.points << RGis::Point.new(-10804399.2542968, 3871470.20131776) 
    ring.points << RGis::Point.new(-10804476.5001953, 3871451.7765517)
    ring.points << RGis::Point.new(-10804554.5609394, 3871437.18473682) 
    ring.points << RGis::Point.new(-10804633.2464587, 3871426.4614028)
    ring.points << RGis::Point.new(-10804712.3651614, 3871419.63265994) 
    ring.points << RGis::Point.new(-10804791.7244008, 3871416.71513559) 
    ring.points << RGis::Point.new(-10804871.1309449, 3871417.71593365) 
    ring.points << RGis::Point.new(-10804950.3914462, 3871422.63261726) 
    ring.points << RGis::Point.new(-10805029.3129128, 3871431.45321476) 
    ring.points << RGis::Point.new(-10805107.7031786, 3871444.15624884) 
    ring.points << RGis::Point.new(-10805185.3713705, 3871460.71078881) 
    ring.points << RGis::Point.new(-10805262.1283741, 3871481.07652594) 
    ring.points << RGis::Point.new(-10805337.7872931, 3871505.20387158) 
    ring.points << RGis::Point.new(-10805412.1639054, 3871533.03407795) 
    ring.points << RGis::Point.new(-10805485.0771109, 3871564.49938112) 
    ring.points << RGis::Point.new(-10805556.3493728, 3871599.52316607) 
    ring.points << RGis::Point.new(-10805625.8071501, 3871638.02015319) 
    ring.points << RGis::Point.new(-10805693.2813195, 3871679.89660598) 
    ring.points << RGis::Point.new(-10805758.6075879, 3871725.05055924) 
    ring.points << RGis::Point.new(-10805821.626892, 3871773.37206737)
    ring.points << RGis::Point.new(-10805882.1857858, 3871824.7434721)
    ring.points << RGis::Point.new(-10805940.1368141, 3871879.0396889)
    ring.points << RGis::Point.new(-10805995.3388716, 3871936.12851166) 
    ring.points << RGis::Point.new(-10806047.6575466, 3871995.87093448) 
    ring.points << RGis::Point.new(-10806096.9654481, 3872058.12149025) 
    ring.points << RGis::Point.new(-10806143.1425159, 3872122.72860475) 
    ring.points << RGis::Point.new(-10806186.0763133, 3872189.53496578) 
    ring.points << RGis::Point.new(-10806225.6623007, 3872258.3779062)
    ring.points << RGis::Point.new(-10806261.8040898, 3872329.08979997) 
    ring.points << RGis::Point.new(-10806294.4136788, 3872401.49847033) 
    ring.points << RGis::Point.new(-10806323.4116664, 3872475.42760903) 
    ring.points << RGis::Point.new(-10806348.7274454, 3872550.69720563) 
    ring.points << RGis::Point.new(-10806370.2993742, 3872627.1239858)
    ring.points << RGis::Point.new(-10806388.0749272, 3872704.52185757) 
    ring.points << RGis::Point.new(-10806402.0108226, 3872782.70236446) 
    ring.points << RGis::Point.new(-10806412.0731278, 3872861.47514436) 
    ring.points << RGis::Point.new(-10806418.2373421, 3872940.648393)
    ring.points << RGis::Point.new(-10806420.4884561, 3873020.02933104) 
    ring.points << RGis::Point.new(-10806418.8209887, 3873099.42467342) 
    ring.points << RGis::Point.new(-10806413.239, 3873178.6411)
    polygon.rings << ring
    
    VCR.use_cassette('multipoint_buffer', :record => :new_episodes) do
      @multipoint.buffer(:input_spatial_reference => 4326,
                         :output_spatial_reference => 102100,
                         :buffer_spatial_reference => 102100,
                         :distances => 1,
                         :distance_units => RGis::Helper::UNIT_TYPES[:survey_mile],
                         :union_results => false).should == polygon
    end
    
  end
  
end