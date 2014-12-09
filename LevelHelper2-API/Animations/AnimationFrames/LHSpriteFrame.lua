--------------------------------------------------------------------------------
--
-- LHSpriteFrame.lua
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local function spriteFrameName(selfObject)
	return selfObject._spriteFrameName;
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local LHSpriteFrame = {}
function LHSpriteFrame:frameWithDictionary(dict, prop)

	if (nil == dict) then
		print("Invalid LHSpriteFrame initialization!")
	end
	
	local LHFrame = require('LevelHelper2-API.Animations.AnimationFrames.LHFrame');
	local LHUtils = require("LevelHelper2-API.Utilities.LHUtils");

	
	local object = LHFrame:frameWithDictionary(dict, prop);
	
	object._spriteFrameName = dict["spriteSheetName"];
	
	--add methods
	object.spriteFrameName	= spriteFrameName;
	
	return object
end
--------------------------------------------------------------------------------
return LHSpriteFrame;