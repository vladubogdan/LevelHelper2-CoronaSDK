--------------------------------------------------------------------------------
--
-- LHOpacityFrame.lua
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local function opacityForUUID(selfObject, uuid)
	local value =  selfObject._opacities[uuid];
	if(value == nil)then
		value = 0.0;
	end
	return value;
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local LHOpacityFrame = {}
function LHOpacityFrame:frameWithDictionary(dict, prop)

	if (nil == dict) then
		print("Invalid LHOpacityFrame initialization!")
	end
	
	local LHFrame = require('LevelHelper2-API.Animations.AnimationFrames.LHFrame');
	local LHUtils = require("LevelHelper2-API.Utilities.LHUtils");

	
	local object = LHFrame:frameWithDictionary(dict, prop);
	
	object._opacities = {};
	
	local rotInfo = dict["opacities"];
	for uuid, value in pairs(rotInfo)do
		object._opacities[uuid] = value;
	end
	
	--add methods
	object.opacityForUUID	= opacityForUUID;
	
	return object
end
--------------------------------------------------------------------------------
return LHOpacityFrame;