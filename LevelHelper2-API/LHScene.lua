--------------------------------------------------------------------------------
--
-- LHScene.lua
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--!@docBegin
--!LHScene is used to load a level file into Corona SDK engine.
--!End users will have to use this class in order to load a level done with LevelHelper 2 into Corona SDK.
--!@code
--!    local LHScene =  require("LevelHelper2-API.LHScene");
--!    local lhScene = LHScene:initWithContentOfFile("publishFolder/level01.json");
--!@endcode
--!
--!@docEnd

local LHUtils = require("LevelHelper2-API.Utilities.LHUtils");
local LHNodeProtocol = require("LevelHelper2-API.Protocols.LHNodeProtocol")
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local function getDesignResolutionSize()
	return {width =display.contentWidth, height=display.contentHeight};
end
--------------------------------------------------------------------------------
local function getDeviceSize()
	return {width = display.pixelWidth, height = display.pixelHeight}
end
--------------------------------------------------------------------------------
--!@docBegin
--!Get the back ui node from the scene.
local function getBackUINode(_sceneObj)
--!@docEnd
	if(_sceneObj._backUINode == nil)then
		for i = 1, _sceneObj.numChildren do
			local node = _sceneObj[i]

			if node.nodeType == "LHBackUINode" then
				_sceneObj._backUINode = node;
			end
		end
	end
	return _sceneObj._backUINode;
	
end
--------------------------------------------------------------------------------
--!@docBegin
--!Get the game world node from the scene.
local function getGameWorldNode(_sceneObj)
--!@docEnd
	if(_sceneObj._gwNode == nil)then
		for i = 1, _sceneObj.numChildren do
			local node = _sceneObj[i]

			if node.nodeType == "LHGameWorldNode" then
				_sceneObj._gwNode = node;
			end
		end
	end
	return _sceneObj._gwNode;
	
end
--------------------------------------------------------------------------------
--!@docBegin
--!Get the front ui node from the scene.
local function getUINode(_sceneObj)
--!@docEnd
	if(_sceneObj._uiNode == nil)then
		for i = 1, _sceneObj.numChildren do
			local node = _sceneObj[i]

			if node.nodeType == "LHUINode" then
				_sceneObj._uiNode = node;
			end
		end
	end
	return _sceneObj._uiNode;
end
--------------------------------------------------------------------------------
--!@docBegin
--!Get the physical shape fixture information with a specific unique identifier.
--!@param uuid The shape fixture unique identifier
local function tracedFixturesWithUUID(_sceneObj, uuid)
--!@docEnd
	return _sceneObj._tracedFixtures[uuid];
end
--------------------------------------------------------------------------------
--!@docBegin
--!Returns the game world rectangle or nil if it was not specified. A table of format {origin={x = 10, y = 10}, size={width=100, height=100}};
local function getGameWorldRect(_sceneObj)
--!@docEnd
	return _sceneObj._gameWorldRect;
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local function removeSelf(_sceneObj)
	
	Runtime:removeEventListener( "enterFrame", _sceneObj )
	_sceneObj:_superRemoveSelf();
	
end
--------------------------------------------------------------------------------
local function assetInfoForFile(selfObject, assetFileName)

	if(selfObject._loadedAssetsInformations == nil)then
		selfObject._loadedAssetsInformations = {};
	end
	
	local info = selfObject._loadedAssetsInformations[assetFileName];
	if(nil == info)then
		
		-- print(selfObject._relativePath);
		-- print(assetFileName);
		
		local path = selfObject._relativePath .. assetFileName .. ".json";
		
		if(path)then
		
			if not base then base = system.ResourceDirectory; end
			local jsonContent = LHUtils.jsonFileContent(path, base)    
			if(jsonContent)then
				local json = require "json"
				info = json.decode( jsonContent )
				
				if(info)then
					selfObject._loadedAssetsInformations[assetFileName] = info;
				end
			end
		end
	end
	
	return info;
end
--------------------------------------------------------------------------------
local function loadGlobalGravityFromDictionary(selfObject, dict)

	if(dict["useGlobalGravity"])then
		--more or less the same as box2d
		local LHUtils = require("LevelHelper2-API.Utilities.LHUtils");
		
		local gravityVector = LHUtils.pointFromString(dict["globalGravityDirection"]);
		local gravityForce = dict["globalGravityForce"];
			
		local gravity = {x = gravityVector.x*gravityForce,
						y = gravityVector.y*gravityForce};
					
		local physics = require( "physics" )
		physics.start();
		physics.setGravity( gravity.x, -gravity.y );
		
	end
end
--------------------------------------------------------------------------------
local function loadGameWorldInfoFromDictionary(selfObject, dict)
	
	local gameWorldInfo = dict["gameWorld"];
	if(gameWorldInfo)then

		local scr = selfObject:getDeviceSize();
		local key = tostring(scr.width) .. "x" .. tostring(scr.height);
		
		local rectInf = gameWorldInfo[key];
		if(nil == rectInf)then
			rectInf = gameWorldInfo["general"];
		end
		
		if(rectInf)then
			local LHUtils = require("LevelHelper2-API.Utilities.LHUtils");
			local bRect = LHUtils.rectFromString(rectInf);
			
			local designSize = selfObject:getDesignResolutionSize();

			selfObject._gameWorldRect = {origin = { x = bRect.origin.x*designSize.width,
													y = (bRect.origin.y)*designSize.height 
													},
										size = {width = bRect.size.width*designSize.width,
												height = (bRect.size.height)*designSize.height}};
			
			local skBRect = selfObject._gameWorldRect;
			
			local from = {x = skBRect.origin.x, y = skBRect.origin.y};
			local to = {x = skBRect.origin.x + skBRect.size.width,
						y = skBRect.origin.y};
			
			local borderLine = display.newLine( from.x,from.y, to.x,to.y );
			borderLine:setStrokeColor( 1, 0, 0, 1 )
			borderLine.strokeWidth = 8
			selfObject:getGameWorldNode():addChild(borderLine);
			
			from = 	{x = skBRect.origin.x + skBRect.size.width,
					y = skBRect.origin.y};
			to = 	{x = skBRect.origin.x + skBRect.size.width,
					y = skBRect.origin.y + skBRect.size.height};
					
			borderLine = display.newLine( from.x,from.y, to.x,to.y );
			borderLine:setStrokeColor( 1, 0, 0, 1 )
			borderLine.strokeWidth = 8
			selfObject:getGameWorldNode():addChild(borderLine);

			from = 	{x = skBRect.origin.x + skBRect.size.width,
					y = skBRect.origin.y + skBRect.size.height};
			to = 	{x = skBRect.origin.x,
					y = skBRect.origin.y + skBRect.size.height};
					
			borderLine = display.newLine( from.x,from.y, to.x,to.y );
			borderLine:setStrokeColor( 1, 0, 0, 1 )
			borderLine.strokeWidth = 8
			selfObject:getGameWorldNode():addChild(borderLine);
			
			from = 	{x = skBRect.origin.x,
					y = skBRect.origin.y + skBRect.size.height};
			to = 	{x = skBRect.origin.x,
					y = skBRect.origin.y};
				
			borderLine = display.newLine( from.x,from.y, to.x,to.y );
			borderLine:setStrokeColor( 1, 0, 0, 1 )
			borderLine.strokeWidth = 8
			selfObject:getGameWorldNode():addChild(borderLine);
			
		end
	end
end
--------------------------------------------------------------------------------
local function loadPhysicsBoundariesFromDictionary(selfObject, dict)
	
	local phyBoundInfo = dict["physicsBoundaries"];
	if(phyBoundInfo)then
		
		local scr = {width = display.pixelWidth, height = display.pixelHeight}
		
		local key = tostring(scr.width) .. "x" .. tostring(scr.height);
		local rectInf = phyBoundInfo[key];
		if(rectInf==nil)then
			rectInf = phyBoundInfo["general"];
		end
		
		if(rectInf~= nil)then
			
			local LHUtils = require("LevelHelper2-API.Utilities.LHUtils");
			
			local bRect = LHUtils.rectFromString(rectInf);
			
			local designSize = {width =display.contentWidth, 
								height=display.contentHeight};
							
			local skBRect = {origin = { x = bRect.origin.x*designSize.width,
										y = bRect.origin.y*designSize.height 
										},
							size = {width = bRect.size.width*designSize.width,
									height = bRect.size.height*designSize.height}};

			local from = {x = skBRect.origin.x, y = skBRect.origin.y};
			local to = {x = skBRect.origin.x + skBRect.size.width,
						y = skBRect.origin.y};
					
			selfObject:createPhysicsBoundarySection(from, to, "LHPhysicsBottomBoundary");
			
			from = 	{x = skBRect.origin.x + skBRect.size.width,
					y = skBRect.origin.y};
			to = 	{x = skBRect.origin.x + skBRect.size.width,
					y = skBRect.origin.y + skBRect.size.height};
					
			selfObject:createPhysicsBoundarySection(from, to, "LHPhysicsRightBoundary");
			
			
			from = 	{x = skBRect.origin.x + skBRect.size.width,
					y = skBRect.origin.y + skBRect.size.height};
			to = 	{x = skBRect.origin.x,
					y = skBRect.origin.y + skBRect.size.height};
					
			selfObject:createPhysicsBoundarySection(from, to, "LHPhysicsTopBoundary");
			
			
			from = 	{x = skBRect.origin.x,
					y = skBRect.origin.y + skBRect.size.height};
			to = 	{x = skBRect.origin.x,
					y = skBRect.origin.y};
					
			selfObject:createPhysicsBoundarySection(from, to, "LHPhysicsLeftBoundary");
		end
	end
end
--------------------------------------------------------------------------------
local function createPhysicsBoundarySection(selfObject, from, to, sectionName)

	local fixtureInfo = {}
	
	local chainPoints = {}
			
	chainPoints[#chainPoints+1] = from.x;
	chainPoints[#chainPoints+1] = from.y;
	
	chainPoints[#chainPoints+1] = to.x;
	chainPoints[#chainPoints+1] = to.y;
	
	fixtureInfo.chain = chainPoints;
	fixtureInfo.connectFirstAndLastChainVertex = false;
			
	local borderLine = display.newLine( 0,0, 0,0 )

	physics.addBody( borderLine, "static", fixtureInfo);
	
end
--------------------------------------------------------------------------------
local function getInfoForCollisionEvent(event)
	
	local info = {}
	
	info.nodeA = event.object1;
	info.nodeB = event.object2;
	
	if(info.nodeA)then
		
		local aShapes = info.nodeA.lhBodyShapes;
		if(aShapes)then
			for i = 1, #aShapes do
				local fixture = aShapes[i];
				if(fixture)then
					if(	event.element1 >= fixture._minFixtureIdForThisObject and 
	 					event.element1 <= fixture._maxFixtureIdForThisObject)then
	
					   	info.nodeAShapeName = fixture._shapeName;
			   			info.nodeAShapeID 	= fixture._shapeID;
		   				break;
	 				end
				end
			end
		end
 	end
 
 	if(info.nodeB)then
		
		local aShapes = info.nodeB.lhBodyShapes;
		if(aShapes)then
			for i = 1, #aShapes do
				local fixture = aShapes[i];
				if(fixture)then
					if(	event.element2 >= fixture._minFixtureIdForThisObject and 
	 					event.element2 <= fixture._maxFixtureIdForThisObject)then
	
					   	info.nodeBShapeName = fixture._shapeName;
			   			info.nodeBShapeID 	= fixture._shapeID;
		   				break;
	 				end
				end
			end
		end
 	end
 
 	
 	return info;
end
--------------------------------------------------------------------------------
--!@docBegin
--!Enable the use of LevelHelper API collision handling
--|The following events will be available once you register to them
--!<yourLHSceneObject>:addEventListener("didBeginContact", <yourCoronaSceneObject>);
--!<yourLHSceneObject>:addEventListener("didEndContact", <yourCoronaSceneObject>);
--!@code
--!   lhScene:addEventListener("didBeginContact", scene);
--!   lhScene:addEventListener("didEndContact", scene);
--!
--!
--!function scene:didBeginContact(event)
--!	
--!	local contactInfo = event.object;
--!	
--!	print("did BEGIN contact with info......................................................");
--!	print("Node A: " .. tostring(contactInfo.nodeA));
--!	print("Node A Shape name: " .. contactInfo.nodeAShapeName);
--!	print("Node A Shape id: " .. contactInfo.nodeAShapeID);
--!	print("Node B: " .. tostring(contactInfo.nodeB));
--!	print("Node B Shape name: " .. contactInfo.nodeBShapeName);
--!	print("Node B Shape id: " .. contactInfo.nodeBShapeID);
--!	
--!end
--!function scene:didEndContact(event)
--!	
--!	local contactInfo = event.object;
--!	
--!	print("did END contact with info......................................................");
--!	print("Node A: " .. tostring(contactInfo.nodeA));
--!	print("Node A Shape name: " .. contactInfo.nodeAShapeName);
--!	print("Node A Shape id: " .. contactInfo.nodeAShapeID);
--!	print("Node B: " .. tostring(contactInfo.nodeB));
--!	print("Node B Shape name: " .. contactInfo.nodeBShapeName);
--!	print("Node B Shape id: " .. contactInfo.nodeBShapeID);
--!	
--!end
--!@endcode
--!
local function enableCollisionHandling(selfNode)
--!@docEnd
	Runtime:addEventListener( "collision", selfNode);
	Runtime:addEventListener( "postCollision", selfNode );
	Runtime:addEventListener( "preCollision", selfNode );
end
--------------------------------------------------------------------------------
--!@docBegin
--!Disable the use of LevelHelper API collision handling
local function disableCollisionHandling(selfNode)
--!@docEnd
	Runtime:removeEventListener( "collision", selfNode);
	Runtime:removeEventListener( "postCollision", selfNode );
	Runtime:removeEventListener( "preCollision", selfNode );
end
--------------------------------------------------------------------------------
local function collision(selfNode, event)
	if ( event.phase == "began" ) then	
		
		local collisionEvent = { 	name="didBeginContact", 
								  		object= getInfoForCollisionEvent(event) };
		selfNode:dispatchEvent(collisionEvent);
			
	elseif ( event.phase == "ended" ) then
	
		local collisionEvent = { 	name="didEndContact", 
								  		object= getInfoForCollisionEvent(event) };
		selfNode:dispatchEvent(collisionEvent);
    end
end
--------------------------------------------------------------------------------
local function postCollision(selfNode, event)
	-- print("postCollision " .. tostring(selfNode) .. " event: " .. tostring(event));
end
--------------------------------------------------------------------------------
local function preCollision(selfNode, event)

	-- print("preCollision " .. tostring(selfNode) .. " event: " .. tostring(event));
	
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local LHScene = {}

--!@docBegin
--!This functions creates the LHScene object that loads the level file from a json specified by the path.
--!@param jsonFile The path to the json file.
function LHScene:initWithContentOfFile(jsonFile)
--!@docEnd

	if (nil == jsonFile) then
		print("Invalid Json file.")
	end
				
	local _scene = display.newGroup();
	
	--add all LevelHelper 2 valid properties to the object
	_scene.nodeType = "LHScene"
	
	--functions
	_scene.getBackUINode 						= getBackUINode;
	_scene.getGameWorldNode 					= getGameWorldNode;
	_scene.getUINode 		 					= getUINode;
	_scene.getDeviceSize						= getDeviceSize;
	_scene.getDesignResolutionSize				= getDesignResolutionSize;
	
	_scene.tracedFixturesWithUUID 				= tracedFixturesWithUUID;
	_scene.loadPhysicsBoundariesFromDictionary 	= loadPhysicsBoundariesFromDictionary;
	_scene.createPhysicsBoundarySection 		= createPhysicsBoundarySection;
	_scene.loadGameWorldInfoFromDictionary 		= loadGameWorldInfoFromDictionary;
	_scene.loadGlobalGravityFromDictionary 		= loadGlobalGravityFromDictionary;
	
	_scene.assetInfoForFile 					= assetInfoForFile;
	
	_scene.getGameWorldRect 					= getGameWorldRect;
	
	_scene._superRemoveSelf 					= _scene.removeSelf;
	_scene.removeSelf 							= removeSelf;
	
	local dict = nil;
	if not base then base = system.ResourceDirectory; end
	local jsonContent = LHUtils.jsonFileContent(jsonFile, base)    
	if(jsonContent)then
		local json = require "json"
		dict = json.decode( jsonContent )
	end

	_scene._relativePath = LHUtils.getPathFromFilename(jsonFile);

	local bkgrColor = LHUtils.colorFromString(dict["backgroundColor"]);
	display.setDefault( "background", bkgrColor.red, bkgrColor.green, bkgrColor.blue);
	
	

	local tracedFixInfo = dict["tracedFixtures"];
	if(tracedFixInfo ~= nil)then
		_scene._tracedFixtures = LHUtils.LHDeepCopy(tracedFixInfo);
	end
	
	
	local LHNodeProtocol = require('LevelHelper2-API.Protocols.LHNodeProtocol')
	LHNodeProtocol.initNodeProtocolWithDictionary(dict, _scene, nil);
	LHNodeProtocol.loadChildrenForNodeFromDictionary(_scene, dict);
	
	_scene:loadGameWorldInfoFromDictionary(dict);
	
	_scene:loadPhysicsBoundariesFromDictionary(dict);
	_scene:loadGlobalGravityFromDictionary(dict);
	
	_scene.lhUniqueName = jsonFile;
	
	_scene.collision 			= collision;
	_scene.postCollision 		= postCollision;
	_scene.preCollision 		= preCollision;
	_scene.enableCollisionHandling = enableCollisionHandling;
	_scene.disableCollisionHandling = disableCollisionHandling;
	
	Runtime:addEventListener( "enterFrame", _scene )
	
	return _scene
end
--------------------------------------------------------------------------------
return LHScene;
