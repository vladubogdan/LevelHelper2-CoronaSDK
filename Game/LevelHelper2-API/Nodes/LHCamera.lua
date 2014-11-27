--------------------------------------------------------------------------------
--
-- LHCamera.lua
--
--------------------------------------------------------------------------------
local function visit(selfNode, event)

	selfNode:animationProtocolEnterFrame(event);
	selfNode:nodeProtocolEnterFrame(event);
	
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local LHCamera = {}
function LHCamera:nodeWithDictionary(dict, prnt)

	if (nil == dict) then
		print("Invalid LHCamera initialization!")
	end
				
	local LHUtils = require("LevelHelper2-API.Utilities.LHUtils");
	local LHNodeProtocol = require('LevelHelper2-API.Protocols.LHNodeProtocol')
	local LHAnimationsProtocol = require('LevelHelper2-API.Protocols.LHAnimationsProtocol');
	
	local object = display.newGroup();
	
	--add all LevelHelper 2 valid properties to the object
	object.nodeType = "LHCamera"
	
	--add LevelHelper methods
	
	object._wasUpdated = false;
	
	object._followedNodeUUID= dict["followedNodeUUID"];
	object._active 			= dict["activeCamera"];
	object._restricted 		= dict["restrictToGameWorld"];



	prnt:addChild(object);
	
	LHNodeProtocol.initNodeProtocolWithDictionary(dict, object, prnt);
	LHAnimationsProtocol.initAnimationsProtocolWithDictionary(dict, object, prnt:getScene());
	
	object.nodeProtocolEnterFrame 	= object.enterFrame;
	object.enterFrame = visit;
	
	--Functions
	----------------------------------------------------------------------------
	
	return object
end
--------------------------------------------------------------------------------
return LHCamera;