-----------------------------------------------------------------------------------------
--
-- LHPhysicsProtocol.lua
--
-----------------------------------------------------------------------------------------
module (..., package.seeall)

function LHDot(a, b)
	return a.x * b.x + a.y * b.y
end

function LHDistanceSquared(a, b)
	local c = {x = a.x - b.x, y = a.y - b.y}
	return LHDot(c, c);
end

function LHValidateCentroid(vs)

	local count = #vs;
	
	if(count < 3 or count > 8)then
		return false;
	end

	local n = math.min(count, 8);

	local ps = {};
	local tempCount = 0;
	for i = 1, n do
		local v = vs[i];
		
		local unique = true;
		if(tempCount > 0)then
			
			for j = 1, tempCount do
				local curPs = ps[j];
				local squared = LHDistanceSquared(v, curPs);
				
				if squared < 0.5 * 0.005 then
					unique = false;
					break;
				end
			end
		end
		
		if (unique)then
			ps[tempCount+1] = v;
			tempCount = tempCount+1;
		end
	end
    
	n = tempCount;
	if (n < 3)then
        return false;
	end
    
    return true;
end

--------------------------------------------------------------------------------
function initPhysicsProtocolWithDictionary(dict, node, scene)

	
    local LHUtils = require("LevelHelper2-API.Utilities.LHUtils");


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
	
	local scaleX = node.xScale;
	local scaleY = node.yScale;
	
	sizet.width  = sizet.width*scaleX;
	sizet.height = sizet.height*scaleY;

	local shapeFixturesInfo = nil;

	local genFixture = dict["genericFixture"];

	local fixtureInfo = {	friction=genFixture["friction"],
						 	bounce	=genFixture["restitution"], 
							density =genFixture["density"],
							filter  ={	
										categoryBits = genFixture["category"],
										maskBits = genFixture["mask"]
									}
						}
	
	if(shapeType == 0)then --RECTANGLE

		fixtureInfo.box = {halfWidth = sizet.width*0.5, halfHeight=sizet.height*0.5};

		physics.addBody( node, physicType, fixtureInfo )

	elseif(shapeType == 1)then --CIRCLE

		fixtureInfo.radius = sizet.width*0.5;

		physics.addBody( node, physicType, fixtureInfo )
	
	elseif(shapeType == 2)then --POLYGON
	
		if node.nodeType == "LHShape" then
	
			local bodyShapes = {}
	
			local triangles = node:trianglePoints();
			
			local i = 1;
			while triangles[i] do
				
				local ptA = triangles[i];
				ptA.x = ptA.x * scaleX;
				ptA.y = ptA.y * scaleY;
				
				i = i+1;
				local ptB = triangles[i];
				ptB.x = ptB.x * scaleX;
				ptB.y = ptB.y * scaleY;
				
				i = i+1;
				local ptC = triangles[i];
				ptC.x = ptC.x * scaleX;
				ptC.y = ptC.y * scaleY;
				
				i = i+1;
				
				local shapePoints = {};
				
				shapePoints[#shapePoints+1] = ptA.x;
				shapePoints[#shapePoints+1] = ptA.y;
				
				shapePoints[#shapePoints+1] = ptB.x;
				shapePoints[#shapePoints+1] = ptB.y;
				
				shapePoints[#shapePoints+1] = ptC.x;
				shapePoints[#shapePoints+1] = ptC.y;
				
				-- chainPoints[#chainPoints+1] = pt.x;
				-- chainPoints[#chainPoints+1] = pt.y;
				-- fixtureInfo.chain = chainPoints;
				-- fixtureInfo.connectFirstAndLastChainVertex = false;
			
				local curShapeProperties = LHUtils.LHDeepCopy(fixtureInfo);
				curShapeProperties.shape = shapePoints;
					
				bodyShapes[#bodyShapes+1] = curShapeProperties;
				
			
			end
		
			physics.addBody( node, physicType, unpack(bodyShapes));
		
		end
		    

	elseif(shapeType == 4)then--OVAL

		shapeFixturesInfo = dict["ovalShape"];

	elseif(shapeType == 3)then--CHAIN
	
		if node.nodeType == "LHBezier" then
	
			local points = node:linePoints();
			
			local chainPoints = {}
			
			for i = 1, #points do
				
				local pt = points[i];
				
				pt.x = pt.x * scaleX;
				pt.y = pt.y * scaleY;
				
				chainPoints[#chainPoints+1] = pt.x;
				chainPoints[#chainPoints+1] = pt.y;
				
			end
			fixtureInfo.chain = chainPoints;
			fixtureInfo.connectFirstAndLastChainVertex = false;
			
			physics.addBody( node, physicType, fixtureInfo);
			
		elseif(node.nodeType == "LHShape") then
			
			local points = node:outlinePoints();
			
			local chainPoints = {}
			
			for i = 1, #points do
				
				local pt = points[i];
				
				pt.x = pt.x * scaleX;
				pt.y = pt.y * scaleY;
				
				chainPoints[#chainPoints+1] = pt.x;
				chainPoints[#chainPoints+1] = pt.y;
				
			end
			fixtureInfo.chain = chainPoints;
			fixtureInfo.connectFirstAndLastChainVertex = true;
			
			physics.addBody( node, physicType, fixtureInfo);
			
		else
			
			local chainPoints = {}
			chainPoints[#chainPoints+1] = -sizet.width*0.5;
			chainPoints[#chainPoints+1] = -sizet.height*0.5;
			
			chainPoints[#chainPoints+1] =  sizet.width*0.5;
			chainPoints[#chainPoints+1] = -sizet.height*0.5;
			
			chainPoints[#chainPoints+1] =  sizet.width*0.5;
			chainPoints[#chainPoints+1] =  sizet.height*0.5;
			
			chainPoints[#chainPoints+1] = -sizet.width*0.5;
			chainPoints[#chainPoints+1] =  sizet.height*0.5;
			

			fixtureInfo.chain = chainPoints;
			fixtureInfo.connectFirstAndLastChainVertex = true;
			
			physics.addBody( node, physicType, fixtureInfo )
		
		end

	elseif(shapeType == 5)then --TRACED
		
		local fixUUID = dict["fixtureUUID"];
		shapeFixturesInfo = scene:tracedFixturesWithUUID(fixUUID);        
		
		if shapeFixturesInfo == nil then
            -- local asset = this->assetParent();
            -- if(asset){
            --     shapeFixturesInfo = (LHArray*)asset->tracedFixturesWithUUID(fixUUID);
            -- }
		end
	end

	node.isFixedRotation	= dict["fixedRotation"];
	node.isBullet 			= dict["bullet"];
	node.isSleepingAllowe	= dict["allowSleep"];
	node.gravityScale		= dict["gravityScale"];
	
	node.isSensor 			= genFixture["sensor"];

	node.linearDamping 		= dict["linearDamping"];
	node.angularVelocity 	= dict["angularVelocity"];
	node.angularDamping 	= dict["angularDamping"];
	
	
	if (shapeFixturesInfo ~= nil) then
		
		local bodyShapes = {}
		
		for i=1, #shapeFixturesInfo do
			local curShapeInfo = shapeFixturesInfo[i];
			
			local count = #curShapeInfo

			if(count > 2)then
		
				local shapePoints = {}
				
				local centroidTest = {};
				
				for j = 1, #curShapeInfo do
					
					local pointStr = curShapeInfo[j];
					local pt = LHUtils.pointFromString(pointStr);
					
					pt.x = pt.x * scaleX;
					pt.y = pt.y * scaleY;
				
					shapePoints[#shapePoints+1] = pt.x;
					shapePoints[#shapePoints+1] = pt.y;
					
					centroidTest[#centroidTest+1] = pt;
				end
				
				if(LHValidateCentroid(centroidTest))then
				
					local curShapeProperties = LHUtils.LHDeepCopy(fixtureInfo);
					curShapeProperties.shape = shapePoints;
					
					bodyShapes[#bodyShapes+1] = curShapeProperties;
				end
			end
		end
		
		physics.addBody( node, physicType,unpack(bodyShapes));
			
	end
	
	--LevelHelper 2 node physics protocol functions
	----------------------------------------------------------------------------
	
	
end
