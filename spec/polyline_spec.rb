require 'spec_helper'

describe 'Polyline Geometry' do
  
  before (:each) do
    RGis::Services::ServiceDirectory.uri = "http://sampleserver1.arcgisonline.com/ArcGIS/rest/services"
    @polyline = RGis::Polyline.new()
    @path = RGis::Path.new()
    @another_path = RGis::Path.new()
    @path.points << RGis::Point.new(-97.06138, 32.837)
    @path.points << RGis::Point.new(-97.06133, 32.836)
    @path.points << RGis::Point.new(-97.06124, 32.834)
    @path.points << RGis::Point.new(-97.06127, 32.832)
    @another_path.points << RGis::Point.new(-97.06326,32.759) 
    @another_path.points << RGis::Point.new(-97.06298,32.755)
    @polyline.paths << @path
    @polyline.paths << @another_path

    @cloned_polyline = RGis::Polyline.new()
    @cloned_path = RGis::Path.new()
    @another_cloned_path = RGis::Path.new()
    @cloned_path.points << RGis::Point.new(-97.06138, 32.837)
    @cloned_path.points << RGis::Point.new(-97.06133, 32.836)
    @cloned_path.points << RGis::Point.new(-97.06124, 32.834)
    @cloned_path.points << RGis::Point.new(-97.06127, 32.832)
    @another_cloned_path.points << RGis::Point.new(-97.06326,32.759) 
    @another_cloned_path.points << RGis::Point.new(-97.06298,32.755)
    @cloned_polyline.paths << @cloned_path
    @cloned_polyline.paths << @another_cloned_path
  end
  
  it "should compare equal polylines" do 
    @polyline.should == @cloned_polyline
  end
  
  it "should convert a polyline to a json representation expected by esri api" do
    json = '{"geometryType":"esriGeometryPolyline","geometries":[{"paths":[[[-97.06138,32.837],[-97.06133,32.836],[-97.06124,32.834],[-97.06127,32.832]],[[-97.06326,32.759],[-97.06298,32.755]]]}]}'    
    @polyline.to_json.should == json    
  end
  
  it "should project a polyline from one spatial reference to another and return a new polyline" do
    VCR.use_cassette('polyline_project', :record => :new_episodes) do
      projected_polyline = RGis::Polyline.new()
      projected_path = RGis::Path.new()
      another_projected_path = RGis::Path.new()
      
      projected_path.points << RGis::Point.new(-10804823.3972924, 3873688.37165364) 
      projected_path.points << RGis::Point.new(-10804817.8313179, 3873555.88336103) 
      projected_path.points << RGis::Point.new(-10804807.8125637, 3873290.91125252) 
      projected_path.points << RGis::Point.new(-10804811.1521484, 3873025.94511247)
      
      another_projected_path.points << RGis::Point.new(-10805032.6779351, 3863358.76046768)
      another_projected_path.points << RGis::Point.new(-10805001.5084777, 3862829.2809139)
      
      projected_polyline.paths << projected_path
      projected_polyline.paths << another_projected_path

      @polyline.project(:from => 4326, :to => 102100).should == projected_polyline    
    end
  end  
  
  it "should change points from a polyline when reprojected" do
    VCR.use_cassette('polyline_project_bang', :record => :new_episodes) do
      @polyline.project!(:from => 4326, :to => 102100)

      @polyline.paths[0].points[0].should == RGis::Point.new(-10804823.3972924, 3873688.37165364)
      @polyline.paths[0].points[1].should == RGis::Point.new(-10804817.8313179, 3873555.88336103)
      @polyline.paths[0].points[2].should == RGis::Point.new(-10804807.8125637, 3873290.91125252)
      @polyline.paths[0].points[3].should == RGis::Point.new(-10804811.1521484, 3873025.94511247)
      
      @polyline.paths[1].points[0].should == RGis::Point.new(-10805032.6779351, 3863358.76046768)
      @polyline.paths[1].points[1].should == RGis::Point.new(-10805001.5084777, 3862829.2809139)
    end
  end
  
  it "should simplify a polyline" do
    VCR.use_cassette('polyline_simplify', :record => :new_episodes) do
      simplified_polyline = RGis::Polyline.new()
      simplified_path = RGis::Path.new()
      another_simplified_path = RGis::Path.new()
      
      simplified_path.points << RGis::Point.new(-97.06138, 32.837) 
      simplified_path.points << RGis::Point.new(-97.06133, 32.836) 
      simplified_path.points << RGis::Point.new(-97.06124, 32.834) 
      simplified_path.points << RGis::Point.new(-97.06127, 32.832)
      
      another_simplified_path.points << RGis::Point.new(-97.06326, 32.759) 
      another_simplified_path.points << RGis::Point.new(-97.06298, 32.755)
    
      simplified_polyline.paths << simplified_path
      simplified_polyline.paths << another_simplified_path
    
      @polyline.simplify(:spatial_reference => 4326).should == simplified_polyline
    end
  end
  
  it "should calculate a buffer for a polyline" do
    VCR.use_cassette('polyline_buffer', :record => :new_episodes) do
      buffer_polygon = RGis::Polygon.new()
      buffer_ring = RGis::Ring.new()
      another_buffer_ring = RGis::Ring.new()
      
      buffer_ring.points << RGis::Point.new(-97.0632744318592, 32.7589992853445)
      buffer_ring.points << RGis::Point.new(-97.0632744264693, 32.7590007954728)
      buffer_ring.points << RGis::Point.new(-97.0632743330445, 32.7590015871758)
      buffer_ring.points << RGis::Point.new(-97.0632741794326, 32.7590023720799)
      buffer_ring.points << RGis::Point.new(-97.0632739647353, 32.7590031464078)
      buffer_ring.points << RGis::Point.new(-97.0632736898508, 32.7590039078931)
      buffer_ring.points << RGis::Point.new(-97.0632733565758, 32.7590046527588)
      buffer_ring.points << RGis::Point.new(-97.0632729658087, 32.7590053772275)
      buffer_ring.points << RGis::Point.new(-97.0632725202443, 32.7590060790329)
      buffer_ring.points << RGis::Point.new(-97.063272020781, 32.7590067543979)
      buffer_ring.points << RGis::Point.new(-97.0632714692154, 32.7590074010561)
      buffer_ring.points << RGis::Point.new(-97.0632708691408, 32.7590080159857)
      buffer_ring.points << RGis::Point.new(-97.0632702223538, 32.759008596165)
      buffer_ring.points << RGis::Point.new(-97.0632695324476, 32.759009140083)
      buffer_ring.points << RGis::Point.new(-97.063268801219, 32.7590096447181)
      buffer_ring.points << RGis::Point.new(-97.0632680322611, 32.7590101085594)
      buffer_ring.points << RGis::Point.new(-97.0632672282689, 32.759010528585)
      buffer_ring.points << RGis::Point.new(-97.0632663946324, 32.7590109032841)
      buffer_ring.points << RGis::Point.new(-97.063265533148, 32.7590112319013)
      buffer_ring.points << RGis::Point.new(-97.0632646474091, 32.7590115121702)
      buffer_ring.points << RGis::Point.new(-97.0632637419073, 32.7590117433354)
      buffer_ring.points << RGis::Point.new(-97.0632628211342, 32.759011923886)
      buffer_ring.points << RGis::Point.new(-97.0632618877846, 32.7590120530665)
      buffer_ring.points << RGis::Point.new(-97.0632609463501, 32.7590121316324)
      buffer_ring.points << RGis::Point.new(-97.0632600004242, 32.7590121573174)
      buffer_ring.points << RGis::Point.new(-97.0632590544982, 32.7590121316324)
      buffer_ring.points << RGis::Point.new(-97.0632581130638, 32.7590120530665)
      buffer_ring.points << RGis::Point.new(-97.0632571797142, 32.759011923886)
      buffer_ring.points << RGis::Point.new(-97.063256258941, 32.7590117433354)
      buffer_ring.points << RGis::Point.new(-97.0632553534392, 32.7590115121702)
      buffer_ring.points << RGis::Point.new(-97.0632544677003, 32.7590112319013)
      buffer_ring.points << RGis::Point.new(-97.063253606216, 32.7590109032841)
      buffer_ring.points << RGis::Point.new(-97.0632527716811, 32.759010528585)
      buffer_ring.points << RGis::Point.new(-97.0632519685872, 32.7590101085594)
      buffer_ring.points << RGis::Point.new(-97.0632511996293, 32.7590096447181)
      buffer_ring.points << RGis::Point.new(-97.0632504684007, 32.759009140083)
      buffer_ring.points << RGis::Point.new(-97.0632497784946, 32.759008596165)
      buffer_ring.points << RGis::Point.new(-97.0632491317076, 32.7590080159857)
      buffer_ring.points << RGis::Point.new(-97.0632485316329, 32.7590074010561)
      buffer_ring.points << RGis::Point.new(-97.0632479800673, 32.7590067543979)
      buffer_ring.points << RGis::Point.new(-97.063247480604, 32.7590060790329)
      buffer_ring.points << RGis::Point.new(-97.0632470350397, 32.7590053772275)
      buffer_ring.points << RGis::Point.new(-97.0632466442725, 32.7590046527588)
      buffer_ring.points << RGis::Point.new(-97.0632463109976, 32.7590039078931)
      buffer_ring.points << RGis::Point.new(-97.0632460361131, 32.7590031464078)
      buffer_ring.points << RGis::Point.new(-97.0632458214157, 32.7590023720799)
      buffer_ring.points << RGis::Point.new(-97.0632456678038, 32.7590015871758)
      buffer_ring.points << RGis::Point.new(-97.063245574379, 32.7590007954728)
      buffer_ring.points << RGis::Point.new(-97.0632455689891, 32.7590007146405)
      buffer_ring.points << RGis::Point.new(-97.0629655686067, 32.7550007143234)
      buffer_ring.points << RGis::Point.new(-97.0629655739965, 32.7549992041273)
      buffer_ring.points << RGis::Point.new(-97.0629656674213, 32.7549984123886)
      buffer_ring.points << RGis::Point.new(-97.0629658210332, 32.7549976274493)
      buffer_ring.points << RGis::Point.new(-97.0629660357306, 32.7549968530866)
      buffer_ring.points << RGis::Point.new(-97.0629663106151, 32.7549960915669)
      buffer_ring.points << RGis::Point.new(-97.06296664389, 32.7549953466678)
      buffer_ring.points << RGis::Point.new(-97.0629670346572, 32.7549946221664)
      buffer_ring.points << RGis::Point.new(-97.0629674802216, 32.7549939203294)
      buffer_ring.points << RGis::Point.new(-97.0629679796849, 32.754993244934)
      buffer_ring.points << RGis::Point.new(-97.0629685312504, 32.7549925982467)
      buffer_ring.points << RGis::Point.new(-97.062969131325, 32.7549919832893)
      buffer_ring.points << RGis::Point.new(-97.0629697781121, 32.7549914030838)
      buffer_ring.points << RGis::Point.new(-97.0629704680182, 32.7549908591412)
      buffer_ring.points << RGis::Point.new(-97.0629711992468, 32.7549903544833)
      buffer_ring.points << RGis::Point.new(-97.0629719682047, 32.7549898906212)
      buffer_ring.points << RGis::Point.new(-97.0629727712986, 32.7549894705766)
      buffer_ring.points << RGis::Point.new(-97.0629736058335, 32.7549890958605)
      buffer_ring.points << RGis::Point.new(-97.0629744673178, 32.7549887672285)
      buffer_ring.points << RGis::Point.new(-97.0629753530567, 32.754988486947)
      buffer_ring.points << RGis::Point.new(-97.0629762585585, 32.7549882557714)
      buffer_ring.points << RGis::Point.new(-97.0629771793317, 32.7549880752126)
      buffer_ring.points << RGis::Point.new(-97.0629781126813, 32.7549879460262)
      buffer_ring.points << RGis::Point.new(-97.0629790541157, 32.7549878674567)
      buffer_ring.points << RGis::Point.new(-97.0629800000417, 32.7549878417706)
      buffer_ring.points << RGis::Point.new(-97.0629809459677, 32.7549878674567)
      buffer_ring.points << RGis::Point.new(-97.0629818874021, 32.7549879460262)
      buffer_ring.points << RGis::Point.new(-97.0629828207517, 32.7549880752126)
      buffer_ring.points << RGis::Point.new(-97.0629837415248, 32.7549882557714)
      buffer_ring.points << RGis::Point.new(-97.0629846470267, 32.754988486947)
      buffer_ring.points << RGis::Point.new(-97.0629855327655, 32.7549887672285)
      buffer_ring.points << RGis::Point.new(-97.0629863942499, 32.7549890958605)
      buffer_ring.points << RGis::Point.new(-97.0629872278865, 32.7549894705766)
      buffer_ring.points << RGis::Point.new(-97.0629880318786, 32.7549898906212)
      buffer_ring.points << RGis::Point.new(-97.0629888008365, 32.7549903544833)
      buffer_ring.points << RGis::Point.new(-97.0629895320652, 32.7549908591412)
      buffer_ring.points << RGis::Point.new(-97.0629902219713, 32.7549914030838)
      buffer_ring.points << RGis::Point.new(-97.0629908687583, 32.7549919832893)
      buffer_ring.points << RGis::Point.new(-97.0629914688329, 32.7549925982467)
      buffer_ring.points << RGis::Point.new(-97.0629920203985, 32.754993244934)
      buffer_ring.points << RGis::Point.new(-97.0629925198618, 32.7549939210849)
      buffer_ring.points << RGis::Point.new(-97.0629929654262, 32.7549946221664)
      buffer_ring.points << RGis::Point.new(-97.0629933561933, 32.7549953466678)
      buffer_ring.points << RGis::Point.new(-97.0629936894683, 32.7549960915669)
      buffer_ring.points << RGis::Point.new(-97.0629939643528, 32.7549968530866)
      buffer_ring.points << RGis::Point.new(-97.0629941790501, 32.7549976274493)
      buffer_ring.points << RGis::Point.new(-97.062994332662, 32.7549984123886)
      buffer_ring.points << RGis::Point.new(-97.0629944260868, 32.7549992041273)
      buffer_ring.points << RGis::Point.new(-97.0629944314767, 32.7549992849632)
      buffer_ring.points << RGis::Point.new(-97.0632744318592, 32.7589992853445)
      
      another_buffer_ring.points << RGis::Point.new(-97.0612700003045, 32.8319878523043)
      another_buffer_ring.points << RGis::Point.new(-97.0612709462305, 32.8319878779683)
      another_buffer_ring.points << RGis::Point.new(-97.0612718876649, 32.8319879557149)
      another_buffer_ring.points << RGis::Point.new(-97.0612728210145, 32.8319880855443)
      another_buffer_ring.points << RGis::Point.new(-97.0612737417877, 32.8319882659468)
      another_buffer_ring.points << RGis::Point.new(-97.0612746472895, 32.8319884969223)
      another_buffer_ring.points << RGis::Point.new(-97.0612755330283, 32.8319887769613)
      another_buffer_ring.points << RGis::Point.new(-97.0612763945127, 32.831989104554)
      another_buffer_ring.points << RGis::Point.new(-97.0612772290476, 32.8319894797006)
      another_buffer_ring.points << RGis::Point.new(-97.0612780321414, 32.8319898993816)
      another_buffer_ring.points << RGis::Point.new(-97.0612788010993, 32.8319903620875)
      another_buffer_ring.points << RGis::Point.new(-97.061279532328, 32.8319908663086)
      another_buffer_ring.points << RGis::Point.new(-97.0612802231324, 32.8319914097805)
      another_buffer_ring.points << RGis::Point.new(-97.0612808699194, 32.8319919902386)
      another_buffer_ring.points << RGis::Point.new(-97.061281469994, 32.8319926046637)
      another_buffer_ring.points << RGis::Point.new(-97.0612820206613, 32.8319932507913)
      another_buffer_ring.points << RGis::Point.new(-97.0612825201246, 32.8319939256022)
      another_buffer_ring.points << RGis::Point.new(-97.0612829665873, 32.8319946268318)
      another_buffer_ring.points << RGis::Point.new(-97.0612833564561, 32.831995350706)
      another_buffer_ring.points << RGis::Point.new(-97.0612836897311, 32.8319960949605)
      another_buffer_ring.points << RGis::Point.new(-97.0612839646156, 32.831996855821)
      another_buffer_ring.points << RGis::Point.new(-97.0612841793129, 32.8319976295135)
      another_buffer_ring.points << RGis::Point.new(-97.0612843338232, 32.8319984137735)
      another_buffer_ring.points << RGis::Point.new(-97.0612844263496, 32.8319992048269)
      another_buffer_ring.points << RGis::Point.new(-97.0612844568924, 32.8319999996544)
      another_buffer_ring.points << RGis::Point.new(-97.061284455994, 32.8320001528832)
      another_buffer_ring.points << RGis::Point.new(-97.0612544603484, 32.8339998438623)
      another_buffer_ring.points << RGis::Point.new(-97.061344446387, 32.8359995411316)
      another_buffer_ring.points << RGis::Point.new(-97.0613944439208, 32.8369994906224)
      another_buffer_ring.points << RGis::Point.new(-97.0613944259545, 32.8370007948812)
      another_buffer_ring.points << RGis::Point.new(-97.0613943325297, 32.83700158589)
      another_buffer_ring.points << RGis::Point.new(-97.0613941789178, 32.8370023701058)
      another_buffer_ring.points << RGis::Point.new(-97.0613939642204, 32.8370031437547)
      another_buffer_ring.points << RGis::Point.new(-97.061393689336, 32.8370039045723)
      another_buffer_ring.points << RGis::Point.new(-97.061393356061, 32.8370046487848)
      another_buffer_ring.points << RGis::Point.new(-97.0613929661922, 32.8370053726183)
      another_buffer_ring.points << RGis::Point.new(-97.0613925197295, 32.8370060738083)
      another_buffer_ring.points << RGis::Point.new(-97.0613920202662, 32.837006748581)
      another_buffer_ring.points << RGis::Point.new(-97.0613914695989, 32.8370073946722)
      another_buffer_ring.points << RGis::Point.new(-97.061390868626, 32.8370080090626)
      another_buffer_ring.points << RGis::Point.new(-97.0613902227373, 32.8370085894879)
      another_buffer_ring.points << RGis::Point.new(-97.0613895319328, 32.8370091321742)
      another_buffer_ring.points << RGis::Point.new(-97.0613888007042, 32.8370096371216)
      another_buffer_ring.points << RGis::Point.new(-97.0613880317463, 32.8370100998013)
      another_buffer_ring.points << RGis::Point.new(-97.0613872286524, 32.8370105194587)
      another_buffer_ring.points << RGis::Point.new(-97.0613863941176, 32.837010894584)
      another_buffer_ring.points << RGis::Point.new(-97.0613855326332, 32.8370112221582)
      another_buffer_ring.points << RGis::Point.new(-97.0613846468943, 32.8370115021813)
      another_buffer_ring.points << RGis::Point.new(-97.0613837413925, 32.8370117331438)
      another_buffer_ring.points << RGis::Point.new(-97.0613828206194, 32.8370119135361)
      another_buffer_ring.points << RGis::Point.new(-97.0613818872698, 32.8370120426033)
      another_buffer_ring.points << RGis::Point.new(-97.0613809458353, 32.8370121211004)
      another_buffer_ring.points << RGis::Point.new(-97.0613799999093, 32.8370121467629)
      another_buffer_ring.points << RGis::Point.new(-97.0613790539833, 32.8370121211004)
      another_buffer_ring.points << RGis::Point.new(-97.061378112549, 32.8370120426033)
      another_buffer_ring.points << RGis::Point.new(-97.0613771791994, 32.8370119135361)
      another_buffer_ring.points << RGis::Point.new(-97.0613762584262, 32.8370117331438)
      another_buffer_ring.points << RGis::Point.new(-97.0613753529244, 32.8370115021813)
      another_buffer_ring.points << RGis::Point.new(-97.0613744671855, 32.8370112221582)
      another_buffer_ring.points << RGis::Point.new(-97.0613736057012, 32.837010894584)
      another_buffer_ring.points << RGis::Point.new(-97.0613727711663, 32.8370105194587)
      another_buffer_ring.points << RGis::Point.new(-97.0613719680724, 32.8370100998013)
      another_buffer_ring.points << RGis::Point.new(-97.0613711991145, 32.8370096371216)
      another_buffer_ring.points << RGis::Point.new(-97.0613704678859, 32.8370091321742)
      another_buffer_ring.points << RGis::Point.new(-97.0613697770814, 32.8370085894879)
      another_buffer_ring.points << RGis::Point.new(-97.0613691311927, 32.8370080090626)
      another_buffer_ring.points << RGis::Point.new(-97.0613685302198, 32.8370073946722)
      another_buffer_ring.points << RGis::Point.new(-97.0613679795525, 32.837006748581)
      another_buffer_ring.points << RGis::Point.new(-97.0613674800892, 32.8370060738083)
      another_buffer_ring.points << RGis::Point.new(-97.0613670336265, 32.8370053726183)
      another_buffer_ring.points << RGis::Point.new(-97.0613666437577, 32.8370046487848)
      another_buffer_ring.points << RGis::Point.new(-97.0613663104827, 32.8370039045723)
      another_buffer_ring.points << RGis::Point.new(-97.0613660355983, 32.8370031437547)
      another_buffer_ring.points << RGis::Point.new(-97.0613658209009, 32.8370023701058)
      another_buffer_ring.points << RGis::Point.new(-97.061365667289, 32.83700158589)
      another_buffer_ring.points << RGis::Point.new(-97.0613655738642, 32.8370007948812)
      another_buffer_ring.points << RGis::Point.new(-97.0613655558979, 32.8370005095746)
      another_buffer_ring.points << RGis::Point.new(-97.0613155556692, 32.8360005095245)
      another_buffer_ring.points << RGis::Point.new(-97.0613155529743, 32.8360004589537)
      another_buffer_ring.points << RGis::Point.new(-97.0612255534609, 32.8340004590283)
      another_buffer_ring.points << RGis::Point.new(-97.0612255435794, 32.8340000001069)
      another_buffer_ring.points << RGis::Point.new(-97.0612255444777, 32.8339998468815)
      another_buffer_ring.points << RGis::Point.new(-97.061255544615, 32.8319998464256)
      another_buffer_ring.points << RGis::Point.new(-97.0612555742593, 32.8319992048269)
      another_buffer_ring.points << RGis::Point.new(-97.0612556676841, 32.8319984137735)
      another_buffer_ring.points << RGis::Point.new(-97.061255821296, 32.8319976295135)
      another_buffer_ring.points << RGis::Point.new(-97.0612560359934, 32.831996855821)
      another_buffer_ring.points << RGis::Point.new(-97.0612563108779, 32.8319960949605)
      another_buffer_ring.points << RGis::Point.new(-97.0612566441528, 32.831995350706)
      another_buffer_ring.points << RGis::Point.new(-97.06125703492, 32.8319946268318)
      another_buffer_ring.points << RGis::Point.new(-97.0612574804844, 32.831993926357)
      another_buffer_ring.points << RGis::Point.new(-97.0612579799477, 32.8319932507913)
      another_buffer_ring.points << RGis::Point.new(-97.0612585315133, 32.8319926046637)
      another_buffer_ring.points << RGis::Point.new(-97.0612591315879, 32.8319919902386)
      another_buffer_ring.points << RGis::Point.new(-97.0612597783749, 32.8319914105353)
      another_buffer_ring.points << RGis::Point.new(-97.061260468281, 32.8319908670634)
      another_buffer_ring.points << RGis::Point.new(-97.0612611995096, 32.8319903628423)
      another_buffer_ring.points << RGis::Point.new(-97.0612619684675, 32.8319898993816)
      another_buffer_ring.points << RGis::Point.new(-97.0612627715614, 32.8319894797006)
      another_buffer_ring.points << RGis::Point.new(-97.0612636060963, 32.8319891053089)
      another_buffer_ring.points << RGis::Point.new(-97.0612644675807, 32.8319887769613)
      another_buffer_ring.points << RGis::Point.new(-97.0612653533195, 32.8319884969223)
      another_buffer_ring.points << RGis::Point.new(-97.0612662588213, 32.8319882659468)
      another_buffer_ring.points << RGis::Point.new(-97.0612671795945, 32.8319880855443)
      another_buffer_ring.points << RGis::Point.new(-97.0612681129441, 32.8319879564697)
      another_buffer_ring.points << RGis::Point.new(-97.0612690543785, 32.8319878779683)
      another_buffer_ring.points << RGis::Point.new(-97.0612700003045, 32.8319878523043)
      
      buffer_polygon.rings << buffer_ring
      buffer_polygon.rings << another_buffer_ring

      @polyline.buffer(:input_spatial_reference => 4326,
                       :output_spatial_reference => 4326,
                       :buffer_spatial_reference => 102113,
                       :distances => 0.001,
                       :distance_units => RGis::Helper::UNIT_TYPES[:survey_mile],
                       :union_results => false).should == buffer_polygon
    end
  end
  
  it "should calculate length for polyline" do
    VCR.use_cassette('polyline_lengths', :record => :new_episodes) do
      @polyline.lengths(:spatial_reference => 4326,
                        :length_unit => RGis::Helper::UNIT_TYPES[:survey_mile],
                        :geodesic => true)[0].should == 0.620847999321685
      
    end
  end
  
  it "should raise an exception when area_and_perimeter method is called" do
    lambda{@polyline.area_and_perimeter(nil)}.should raise_error(TypeError, "Area and perimeter operation is allowed only for polygon type")
  end
  
  it "should raise an exception when label_points method is called" do
    lambda{@polyline.label_points(nil)}.should raise_error(TypeError, "Label points operation is allowed only for polygon type")
  end
  
end
