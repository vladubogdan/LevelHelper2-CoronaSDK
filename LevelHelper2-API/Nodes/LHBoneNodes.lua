--------------------------------------------------------------------------------
--
-- LHBoneNodes.lua
--
--!@docBegin
--!LHBoneNodes class is used to hold all sprites inside a skeletal structure.
--!
--!
--!Conforms to:
--!
--!LHNodeProtocol
--!
--!@docEnd
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local function visit(selfNode, event)

	selfNode:animationProtocolEnterFrame(event);
	selfNode:nodeProtocolEnterFrame(event);
	
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local LHBoneNodes = {}
function LHBoneNodes:nodeWithDictionary(dict, prnt)

	if (nil == dict) then
		print("Invalid LHBoneNodes initialization!")
	end
				
	local LHUtils = require("LevelHelper2-API.Utilities.LHUtils");
	local LHNodeProtocol = require('LevelHelper2-API.Protocols.LHNodeProtocol')
	local LHAnimationsProtocol = require('LevelHelper2-API.Protocols.LHAnimationsProtocol');

	local object = display.newGroup();
	
	--add all LevelHelper 2 valid properties to the object
	object.nodeType = "LHBoneNodes"
	
	--add LevelHelper methods
	prnt:addChild(object);
	
	LHNodeProtocol.initNodeProtocolWithDictionary(dict, object, prnt);
	LHNodeProtocol.loadChildrenForNodeFromDictionary(object, dict);

	
	LHAnimationsProtocol.initAnimationsProtocolWithDictionary(dict, object, prnt:getScene());
	
	object.nodeProtocolEnterFrame 	= object.enterFrame;
	object.enterFrame = visit;
	
	
	--Functions
	----------------------------------------------------------------------------
	
	
	
	return object
end
--------------------------------------------------------------------------------
return LHBoneNodes;
