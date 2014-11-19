--------------------------------------------------------------------------------
--
-- LHPositionFrame.lua
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local function positionForUUID(selfObject, uuid)
	return selfObject._positions[uuid];
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local LHPositionFrame = {}
function LHPositionFrame:frameWithDictionary(dict, prop)

	if (nil == dict) then
		print("Invalid LHPositionFrame initialization!")
	end
	
	local LHFrame = require('LevelHelper2-API.Animations.AnimationFrames.LHFrame');
	local LHUtils = require("LevelHelper2-API.Utilities.LHUtils");

	
	local object = LHFrame:frameWithDictionary(dict, prop);
	
	object._positions = {};
	
	local positionsInfo = dict["positions"];
	for uuid, ptString in pairs(positionsInfo)do
		local pos = LHUtils.pointFromString(ptString);
		object._positions[uuid] = pos;
	end
	
	--add methods
	object.positionForUUID	= positionForUUID;
	
	return object
end
--------------------------------------------------------------------------------
return LHPositionFrame;