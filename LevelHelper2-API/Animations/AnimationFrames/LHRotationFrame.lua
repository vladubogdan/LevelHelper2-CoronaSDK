--------------------------------------------------------------------------------
--
-- LHRotationFrame.lua
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local function rotationForUUID(selfObject, uuid)
	local value =  selfObject._rotations[uuid];
	if(value == nil)then
		value = 0.0;
	end
	return value;
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local LHRotationFrame = {}
function LHRotationFrame:frameWithDictionary(dict, prop)

	if (nil == dict) then
		print("Invalid LHRotationFrame initialization!")
	end
	
	local LHFrame = require('LevelHelper2-API.Animations.AnimationFrames.LHFrame');
	local LHUtils = require("LevelHelper2-API.Utilities.LHUtils");

	
	local object = LHFrame:frameWithDictionary(dict, prop);
	
	object._rotations = {};
	
	local rotInfo = dict["rotations"];
	for uuid, value in pairs(rotInfo)do
		object._rotations[uuid] = value;
	end
	
	--add methods
	object.rotationForUUID	= rotationForUUID;
	
	return object
end
--------------------------------------------------------------------------------
return LHRotationFrame;