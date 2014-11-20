--------------------------------------------------------------------------------
--
-- LHOpacityProperty.lua
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
	
	local LHOpacityFrame = require('LevelHelper2-API.Animations.AnimationFrames.LHOpacityFrame');
	
	for i=1, #framesInfo do
		local frmInfo = framesInfo[i];
		
		local frm = LHOpacityFrame:frameWithDictionary(frmInfo, selfObject);
		selfObject:addKeyFrame(frm);
		
	end
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local LHOpacityProperty = {}
function LHOpacityProperty:initAnimationPropertyWithDictionary(dict, anim)

	-- if (nil == dict) then
	-- 	print("Invalid LHOpacityProperty initialization!")
	-- end
	local LHAnimationProperty = require('LevelHelper2-API.Animations.AnimationProperties.LHAnimationProperty');

	local object = LHAnimationProperty:initAnimationPropertyWithDictionary(dict, anim);
	
	object.superLoadDictionary = object.loadDictionary;
	object.loadDictionary = loadDictionary;
	
	object.isAnimationOpacityProperty = true;
	
	return object
end
--------------------------------------------------------------------------------
return LHOpacityProperty;
