--------------------------------------------------------------------------------
--
-- LHUINode.lua
--
--!@docBegin
--!LHUINode class is used to load the front UI elements. Game elements that won't move with the camera.
--!
--!Conforms to:
--!
--!LHNodeProtocol
--!
--!@docEnd
--------------------------------------------------------------------------------
local LHUINode = {}
function LHUINode:nodeWithDictionary(dict, prnt)

	if (nil == dict) then
		print("Invalid LHUINode initialization!")
	end
				
	local object = display.newGroup();
	
	--add all LevelHelper 2 valid properties to the object
	object.nodeType = "LHUINode"

	prnt:addChild(object);
	
	local LHNodeProtocol = require('LevelHelper2-API.Protocols.LHNodeProtocol')
	LHNodeProtocol.initNodeProtocolWithDictionary(dict, object, prnt);
	LHNodeProtocol.loadChildrenForNodeFromDictionary(object, dict);

	return object
end
--------------------------------------------------------------------------------
return LHUINode;
