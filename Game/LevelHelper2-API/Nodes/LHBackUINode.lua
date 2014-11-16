--------------------------------------------------------------------------------
--
-- LHBackUINode.lua
--
--------------------------------------------------------------------------------
local LHBackUINode = {}
function LHBackUINode:nodeWithDictionary(dict, prnt)

	if (nil == dict) then
		print("Invalid LHBackUINode initialization!")
	end
				
	local object = display.newGroup();
	
	--add all LevelHelper 2 valid properties to the object
	object.nodeType = "LHBackUINode"
	
	prnt:addChild(object);
	
	local LHNodeProtocol = require('LevelHelper2-API.Protocols.LHNodeProtocol')
	LHNodeProtocol.initNodeProtocolWithDictionary(dict, object);
	LHNodeProtocol.loadChildrenForNodeFromDictionary(object, dict);

	return object
end
--------------------------------------------------------------------------------
return LHBackUINode;
