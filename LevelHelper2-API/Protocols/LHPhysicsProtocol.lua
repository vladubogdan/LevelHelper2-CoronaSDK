-----------------------------------------------------------------------------------------
--
-- LHPhysicsProtocol.lua
--
--!@docBegin
--!LevelHelper 2 nodes that can have physics conforms to this protocol.
--!
--!@docEnd
-----------------------------------------------------------------------------------------
module (..., package.seeall)

require("LevelHelper2-API.Protocols.LHBodyShape")



--------------------------------------------------------------------------------
function initPhysicsProtocolWithDictionary(dict, node, scene)

	
    local LHUtils = require("LevelHelper2-API.Utilities.LHUtils");

	node.protocolName = "LHPhysicsProtocol";
    node._isPhysicsProtocol = true;

	if(dict == nil)then return end;
	
	local physics = require("physics")
	if(nil == physics)then	return end

	physics.start();

	local shapeType = dict["shape"];
    local type  	= dict["type"];
 
  	if(type == 3) then
		return
	end

	local physicType = "static";
	if(type == 1)then
		physicType = "kinematic";
	elseif(type == 2)then
		physicType = "dynamic";
	end

	local sizet = {width = node.width, height = node.height}
	if(node.width == 0 and node.height == 0)then
		--some corona nodes have width/height properties as read only - we retreive needed info from a lh variable
		sizet = node.lhContentSize;
	end
	
	local genFixture = dict["genericFixture"];

	local allBodyFixtures = {};
	node.lhBodyShapes = {};
	
	if(shapeType == 0)then --RECTANGLE

		local minFixId = #allBodyFixtures;
		local bodyShape = LHBodyShape:createRectangleWithDictionary(genFixture, node, scene, sizet, allBodyFixtures);
			
		bodyShape._minFixtureIdForThisObject = minFixId +1;
 		bodyShape._maxFixtureIdForThisObject = #allBodyFixtures;
 		 		
		node.lhBodyShapes[#node.lhBodyShapes +1] = bodyShape;	
		
	elseif(shapeType == 1)then --CIRCLE

		local minFixId = #allBodyFixtures;
		local bodyShape = LHBodyShape:createCircleWithDictionary(genFixture, node, scene, sizet, allBodyFixtures);
			
		bodyShape._minFixtureIdForThisObject = minFixId +1;
 		bodyShape._maxFixtureIdForThisObject = #allBodyFixtures;
 		 		
		node.lhBodyShapes[#node.lhBodyShapes +1] = bodyShape;	
 		
	elseif(shapeType == 2)then --POLYGON
	
		if node.nodeType == "LHShape" then

			local triangles = node:trianglePoints();

			local minFixId = #allBodyFixtures;
			local bodyShape = LHBodyShape:createTrianglesWithDictionary(genFixture, triangles, node, scene, allBodyFixtures);
			
			bodyShape._minFixtureIdForThisObject = minFixId +1;
 			bodyShape._maxFixtureIdForThisObject = #allBodyFixtures;
 		 		
			node.lhBodyShapes[#node.lhBodyShapes +1] = bodyShape;	
 		
		end

	elseif(shapeType == 4)then--OVAL

		local shapeFixturesInfo = dict["ovalShape"];
		
		local minFixId = #allBodyFixtures;
		local bodyShape = LHBodyShape:createShapeFixturesWithDictionary(genFixture, shapeFixturesInfo, node, scene, allBodyFixtures);
		
		bodyShape._minFixtureIdForThisObject = minFixId +1;
 		bodyShape._maxFixtureIdForThisObject = #allBodyFixtures;
 	 		
		node.lhBodyShapes[#node.lhBodyShapes +1] = bodyShape;
			
	elseif(shapeType == 3)then--CHAIN
	
		if node.nodeType == "LHBezier" then
	
			local points = node:linePoints();
			
			local minFixId = #allBodyFixtures;
			local bodyShape = LHBodyShape:createChainWithDictionary(genFixture, points, false, node, scene, allBodyFixtures)
			
			bodyShape._minFixtureIdForThisObject = minFixId +1;
 			bodyShape._maxFixtureIdForThisObject = #allBodyFixtures;
 		 		
			node.lhBodyShapes[#node.lhBodyShapes +1] = bodyShape;
		
		elseif(node.nodeType == "LHShape") then
			
			local points = node:outlinePoints();
			
			local minFixId = #allBodyFixtures;
			local bodyShape = LHBodyShape:createChainWithDictionary(genFixture, points, true, node, scene, allBodyFixtures)
			
			bodyShape._minFixtureIdForThisObject = minFixId +1;
 			bodyShape._maxFixtureIdForThisObject = #allBodyFixtures;
 		 		
			node.lhBodyShapes[#node.lhBodyShapes +1] = bodyShape;
		
		else
			
			local chainPoints = {}
			chainPoints[#chainPoints+1] = {x = -sizet.width*0.5, y = -sizet.height*0.5}
			chainPoints[#chainPoints+1] = {x = sizet.width*0.5, y = -sizet.height*0.5}
			chainPoints[#chainPoints+1] = {x = sizet.width*0.5, y= sizet.height*0.5}
			chainPoints[#chainPoints+1] = { x= -sizet.width*0.5, y = sizet.height*0.5}
			

			local minFixId = #allBodyFixtures;
			local bodyShape = LHBodyShape:createChainWithDictionary(genFixture, chainPoints, true, node, scene, allBodyFixtures)
			
			bodyShape._minFixtureIdForThisObject = minFixId +1;
 			bodyShape._maxFixtureIdForThisObject = #allBodyFixtures;
 		 		
			node.lhBodyShapes[#node.lhBodyShapes +1] = bodyShape;
		
		end

	elseif(shapeType == 5)then --TRACED
		
		local fixUUID = dict["fixtureUUID"];
		local shapeFixturesInfo = scene:tracedFixturesWithUUID(fixUUID);        
		
		if shapeFixturesInfo == nil then
            -- local asset = this->assetParent();
            -- if(asset){
            --     shapeFixturesInfo = (LHArray*)asset->tracedFixturesWithUUID(fixUUID);
            -- }
		end
		
		local minFixId = #allBodyFixtures;
		local bodyShape = LHBodyShape:createShapeFixturesWithDictionary(genFixture, shapeFixturesInfo, node, scene, allBodyFixtures);
		
		bodyShape._minFixtureIdForThisObject = minFixId +1;
 		bodyShape._maxFixtureIdForThisObject = #allBodyFixtures;
 	 		
		node.lhBodyShapes[#node.lhBodyShapes +1] = bodyShape;
			
	elseif(shapeType == 6)then -- editor
	
		--this shapey type is available only on sprites
		
		local spriteFrameName = node:getSpriteFrameName();
		local spriteSheetPath = node:getSpriteSheetPath();
		
		-- require the sprite sheet information file
		local sheetInfo = require(spriteSheetPath); 
		
		local bodyInfo = sheetInfo.getPhysicsData()[spriteFrameName];
		
		local shapesInfo = bodyInfo["shapes"];
		if(shapesInfo ~= nil)then
			
			for i=1, #shapesInfo do
					
				local shapeInfo = shapesInfo[i];
			
				local minFixId = #allBodyFixtures;
				local bodyShape = LHBodyShape:createComplexShapeWithDictionary(shapeInfo, node, scene, allBodyFixtures);
				bodyShape._minFixtureIdForThisObject = minFixId +1;
	 			bodyShape._maxFixtureIdForThisObject = #allBodyFixtures;
	 	 		
				node.lhBodyShapes[#node.lhBodyShapes +1] = bodyShape;
				
        	end
        end
        
	end

	physics.addBody(node, 
					physicType,
					unpack(allBodyFixtures))
			
			
	node.isFixedRotation	= dict["fixedRotation"];
	node.isBullet 			= dict["bullet"];
	node.isSleepingAllowe	= dict["allowSleep"];
	node.gravityScale		= dict["gravityScale"];
	node.linearDamping 		= dict["linearDamping"];
	node.angularVelocity 	= dict["angularVelocity"];
	node.angularDamping 	= dict["angularDamping"];
	
	
	--LevelHelper 2 node physics protocol functions
	----------------------------------------------------------------------------
	
end
