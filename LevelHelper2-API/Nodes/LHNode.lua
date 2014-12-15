--------------------------------------------------------------------------------
--
-- LHNode.lua
--
--!@docBegin
--!LHNode class is used to load a node object from a level file.
--!
--!@docEnd
--------------------------------------------------------------------------------
local function visit(selfNode, event)

	selfNode:animationProtocolEnterFrame(event);
	selfNode:nodeProtocolEnterFrame(event);
	
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local LHNode = {}
function LHNode:nodeWithDictionary(dict, prnt)

	if (nil == dict) then
		print("Invalid LHNode initialization!")
	end
				
	local LHUtils = require("LevelHelper2-API.Utilities.LHUtils");
    local LHNodeProtocol = require('LevelHelper2-API.Protocols.LHNodeProtocol')
    local LHAnimationsProtocol = require('LevelHelper2-API.Protocols.LHAnimationsProtocol');
    local LHPhysicsProtocol = require('LevelHelper2-API.Protocols.LHPhysicsProtocol')
    
    local object = display.newGroup();
    
    --add all LevelHelper 2 valid properties to the object
	object.nodeType = "LHNode"
	
	--add LevelHelper methods
    
    prnt:addChild(object);
	
	LHNodeProtocol.initNodeProtocolWithDictionary(dict, object, prnt);
	LHPhysicsProtocol.initPhysicsProtocolWithDictionary(dict["nodePhysics"], object, prnt:getScene());
	LHNodeProtocol.loadChildrenForNodeFromDictionary(object, dict);

	LHAnimationsProtocol.initAnimationsProtocolWithDictionary(dict, object, prnt:getScene());
	
	object.nodeProtocolEnterFrame 	= object.enterFrame;
	object.enterFrame = visit;
	
	--Functions
	----------------------------------------------------------------------------
	
	
	return object
end
--------------------------------------------------------------------------------
return LHNode;