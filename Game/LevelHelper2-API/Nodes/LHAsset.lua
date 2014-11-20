--------------------------------------------------------------------------------
--
-- LHAsset.lua
--
--------------------------------------------------------------------------------
local function visit(selfNode, event)

	selfNode:animationProtocolEnterFrame(event);
	selfNode:nodeProtocolEnterFrame(event);
	
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local LHAsset = {}
function LHAsset:nodeWithDictionary(dict, prnt)

	if (nil == dict) then
		print("Invalid LHAsset initialization!")
	end
				
	local LHUtils = require("LevelHelper2-API.Utilities.LHUtils");
    local LHNodeProtocol = require('LevelHelper2-API.Protocols.LHNodeProtocol')
    local LHAnimationsProtocol = require('LevelHelper2-API.Protocols.LHAnimationsProtocol');
    local LHPhysicsProtocol = require('LevelHelper2-API.Protocols.LHPhysicsProtocol')
    
    local object = display.newGroup();
    
    --add all LevelHelper 2 valid properties to the object
	object.nodeType = "LHAsset"
	
	--add LevelHelper methods
    
    prnt:addChild(object);
	
	local scene = prnt:getScene();
	
	LHNodeProtocol.initNodeProtocolWithDictionary(dict, object, prnt);
	LHPhysicsProtocol.initPhysicsProtocolWithDictionary(dict["nodePhysics"], object, prnt:getScene());
	local LHUtils = require("LevelHelper2-API.Utilities.LHUtils");
	
	local fileExists = false;
	if(dict["assetFile"])then

		local assetInfo = scene:assetInfoForFile(dict["assetFile"]);

		if(assetInfo)then
			
			fileExists = true;
			local tracedFix = assetInfo["tracedFixtures"];
			if(tracedFix)then
				object._tracedFixtures = LHUtils.LHDeepCopy(tracedFix);
			end

			LHNodeProtocol.loadChildrenForNodeFromDictionary(object, assetInfo);
		end
	end
	if(false == fileExists)then
		print("WARNING: COULD NOT FIND INFORMATION FOR ASSET " ..  object:getUniqueName() ..". This usually means that the asset was created but not saved. Check your level and in the Scene Navigator, click on the lock icon next to the asset name.");
		LHNodeProtocol.loadChildrenForNodeFromDictionary(object, dict);
	end

	LHAnimationsProtocol.initAnimationsProtocolWithDictionary(dict, object, prnt:getScene());
	
	object.nodeProtocolEnterFrame 	= object.enterFrame;
	object.enterFrame = visit;
	
	--Functions
	----------------------------------------------------------------------------
	
	
	return object
end
--------------------------------------------------------------------------------
return LHAsset;
