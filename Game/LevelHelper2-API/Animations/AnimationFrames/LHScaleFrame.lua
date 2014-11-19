--------------------------------------------------------------------------------
--
-- LHScaleFrame.lua
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local function scaleForUUID(selfObject, uuid)
	return selfObject._scales[uuid];
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local LHScaleFrame = {}
function LHScaleFrame:frameWithDictionary(dict, prop)

	if (nil == dict) then
		print("Invalid LHScaleFrame initialization!")
	end
	
	local LHFrame = require('LevelHelper2-API.Animations.AnimationFrames.LHFrame');
	local LHUtils = require("LevelHelper2-API.Utilities.LHUtils");

	
	local object = LHFrame:frameWithDictionary(dict, prop);
	
	object._scales = {};
	
	local rotInfo = dict["scales"];
	for uuid, sclString in pairs(rotInfo)do
		local scl = LHUtils.sizeFromString(sclString);
		object._scales[uuid] = scl;
	end
	
	--add methods
	object.scaleForUUID	= scaleForUUID;
	
	return object
end
--------------------------------------------------------------------------------
return LHScaleFrame;