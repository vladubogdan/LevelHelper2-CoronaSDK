--------------------------------------------------------------------------------
--
-- LHParallaxLayer.lua
--
--!@docBegin
--!LHParallaxLayer class is used to load a parallax layer object from a level file.
--!
--!@docEnd
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--!@docBegin
--!Returns the x ratio that is used to calculate the children position.
local function getXRatio(selfNode)
--!@docEnd	
	return selfNode._xRatio;
end
--------------------------------------------------------------------------------
--!@docBegin
--!Returns the y ratio that is used to calculate the children position.
local function getYRatio(selfNode)
--!@docEnd	
	return selfNode._yRatio;
end
--------------------------------------------------------------------------------
local function getInitialPosition(selfNode)
	return selfNode._initialPosition;
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local LHParallaxLayer = {}
function LHParallaxLayer:nodeWithDictionary(dict, prnt)

	if (nil == dict) then
		print("Invalid LHParallaxLayer initialization!")
	end
				
	local LHUtils = require("LevelHelper2-API.Utilities.LHUtils");
	local LHNodeProtocol = require('LevelHelper2-API.Protocols.LHNodeProtocol')
	local LHAnimationsProtocol = require('LevelHelper2-API.Protocols.LHAnimationsProtocol');
	
	local object = display.newGroup();
	
	--add all LevelHelper 2 valid properties to the object
	object.nodeType = "LHParallaxLayer"
	
	--add LevelHelper methods
	prnt:addChild(object);
	
	LHNodeProtocol.initNodeProtocolWithDictionary(dict, object, prnt);
	LHNodeProtocol.loadChildrenForNodeFromDictionary(object, dict);

	LHAnimationsProtocol.initAnimationsProtocolWithDictionary(dict, object, prnt:getScene());
	
	object._xRatio = dict["xRatio"];
	object._yRatio = dict["yRatio"];

	object._initialPosition = object:getPosition();

	--Functions
	----------------------------------------------------------------------------
	object.getXRatio = getXRatio;
	object.getYRatio = getYRatio;
	object.getInitialPosition = getInitialPosition;
	
	
	return object
end
--------------------------------------------------------------------------------
return LHParallaxLayer;
