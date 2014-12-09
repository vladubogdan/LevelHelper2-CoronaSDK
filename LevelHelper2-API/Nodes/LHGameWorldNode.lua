--------------------------------------------------------------------------------
--
-- LHGameWorldNode.lua
--
--------------------------------------------------------------------------------
local LHGameWorldNode = {}
function LHGameWorldNode:nodeWithDictionary(dict, prnt)

	if (nil == dict) then
		print("Invalid LHGameWorldNode initialization!")
	end
				
	local object = display.newGroup();
	
	--add all LevelHelper 2 valid properties to the object
	object.nodeType = "LHGameWorldNode"
	
	prnt:addChild(object);
	
	local LHNodeProtocol = require('LevelHelper2-API.Protocols.LHNodeProtocol')
	LHNodeProtocol.initNodeProtocolWithDictionary(dict, object, prnt);
	LHNodeProtocol.loadChildrenForNodeFromDictionary(object, dict);
	
	return object
end
--------------------------------------------------------------------------------
return LHGameWorldNode;
