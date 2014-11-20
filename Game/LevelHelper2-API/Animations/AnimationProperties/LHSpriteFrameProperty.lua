--------------------------------------------------------------------------------
--
-- LHSpriteFrameProperty.lua
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local LHUtils = require("LevelHelper2-API.Utilities.LHUtils");

local function loadDictionary(selfObject, dict)
	
	if(dict == nil)then
		return
	end
	
	selfObject:superLoadDictionary(dict);
	
	local framesInfo = dict["Frames"];
	
	local LHSpriteFrame = require('LevelHelper2-API.Animations.AnimationFrames.LHSpriteFrame');
	
	for i=1, #framesInfo do
		local frmInfo = framesInfo[i];
		
		local frm = LHSpriteFrame:frameWithDictionary(frmInfo, selfObject);
		selfObject:addKeyFrame(frm);
		
	end
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local LHSpriteFrameProperty = {}
function LHSpriteFrameProperty:initAnimationPropertyWithDictionary(dict, anim)

	if (nil == dict) then
		print("Invalid LHSpriteFrameProperty initialization!")
	end
	local LHAnimationProperty = require('LevelHelper2-API.Animations.AnimationProperties.LHAnimationProperty');

	local object = LHAnimationProperty:initAnimationPropertyWithDictionary(dict, anim);
	
	object.superLoadDictionary = object.loadDictionary;
	object.loadDictionary = loadDictionary;
	
	object.isAnimationSpriteFrameProperty = true;
	
	return object
end
--------------------------------------------------------------------------------
return LHSpriteFrameProperty;
