--------------------------------------------------------------------------------
--
-- LHScene.lua
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local LHUtils = require("LevelHelper2-API.Utilities.LHUtils");
local LHNodeProtocol = require("LevelHelper2-API.Protocols.LHNodeProtocol")

--------------------------------------------------------------------------------
--!@docBegin
--!Get the back ui node from the scene.
local function getBackUINode(_sceneObj)
--!@docEnd
end
--------------------------------------------------------------------------------
--!@docBegin
--!Get the game world node from the scene.
local function getGameWorldNode(_sceneObj)
--!@docEnd
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
	return selfObject._gameWorldRect;
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local function removeSelf(_sceneObj)
	
	Runtime:removeEventListener( "enterFrame", _sceneObj )
	_sceneObj:_superRemoveSelf();
	
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
		physics.setGravity( gravity.x, -gravity.y );
		
	end
end
--------------------------------------------------------------------------------
local function loadGameWorldInfoFromDictionary(selfObject, dict)
	
	local gameWorldInfo = dict["gameWorld"];
	if(gameWorldInfo)then

		local scr = {width = display.pixelWidth, height = display.pixelHeight}
		local key = tostring(scr.width) .. "x" .. tostring(scr.height);
		
		local rectInf = gameWorldInfo[key];
		if(nil == rectInf)then
			rectInf = gameWorldInfo["general"];
		end
		
		if(rectInf)then
			local LHUtils = require("LevelHelper2-API.Utilities.LHUtils");
			local bRect = LHUtils.rectFromString(rectInf);
			
			local designSize = {width =display.contentWidth, 
								height=display.contentHeight};
							

			selfObject._gameWorldRect = {origin = { x = bRect.origin.x*designSize.width,
													y = (1.0 - bRect.origin.y)*designSize.height 
													},
										size = {width = bRect.size.width*designSize.width,
										height = bRect.size.height*designSize.height}};
			
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
										y = designSize.height - bRect.origin.y*designSize.height 
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
--------------------------------------------------------------------------------
local LHScene = {}
function LHScene:initWithContentOfFile(jsonFile)

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
	_scene.tracedFixturesWithUUID 				= tracedFixturesWithUUID;
	_scene.loadPhysicsBoundariesFromDictionary 	= loadPhysicsBoundariesFromDictionary;
	_scene.createPhysicsBoundarySection 		= createPhysicsBoundarySection;
	_scene.loadGameWorldInfoFromDictionary 		= loadGameWorldInfoFromDictionary;
	_scene.loadGlobalGravityFromDictionary 		= loadGlobalGravityFromDictionary;
	
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


	local tracedFixInfo = dict["tracedFixtures"];
	if(tracedFixInfo ~= nil)then
		_scene._tracedFixtures = LHUtils.LHDeepCopy(tracedFixInfo);
	end
	
	_scene:loadGameWorldInfoFromDictionary(dict);
	
	local LHNodeProtocol = require('LevelHelper2-API.Protocols.LHNodeProtocol')
	LHNodeProtocol.initNodeProtocolWithDictionary(dict, _scene, nil);
	LHNodeProtocol.loadChildrenForNodeFromDictionary(_scene, dict);
	
	_scene:loadPhysicsBoundariesFromDictionary(dict);
	_scene:loadGlobalGravityFromDictionary(dict);
	
	Runtime:addEventListener( "enterFrame", _scene )
	
	return _scene
end
--------------------------------------------------------------------------------
return LHScene;
