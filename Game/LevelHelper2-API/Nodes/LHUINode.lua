
local LHUINode = {}
function LHUINode:nodeWithDictionary(dict, prnt)

	if (nil == dict) then
		print("Invalid LHUINode initialization!")
	end
				
	local object = display.newGroup();
	
	--add all LevelHelper 2 valid properties to the object
	object.nodeType = "LHUINode"
		
	local LHNodeProtocol = require('LevelHelper2-API.Protocols.LHNodeProtocol')
	LHNodeProtocol.initNodeProtocolWithDictionary(dict, object);
	LHNodeProtocol.loadChildrenForNodeFromDictionary(object, dict);

    prnt:insert( object )
	
	return object
end
--------------------------------------------------------------------------------
return LHUINode;
