--------------------------------------------------------------------------------
--
-- LHScaleProperty.lua
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
	
	local LHScaleFrame = require('LevelHelper2-API.Animations.AnimationFrames.LHScaleFrame');
	
	for i=1, #framesInfo do
		local frmInfo = framesInfo[i];
		
		local frm = LHScaleFrame:frameWithDictionary(frmInfo, selfObject);
		selfObject:addKeyFrame(frm);
		
	end
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local LHScaleProperty = {}
function LHScaleProperty:initAnimationPropertyWithDictionary(dict, anim)

	-- if (nil == dict) then
	-- 	print("Invalid LHScaleProperty initialization!")
	-- end
	local LHAnimationProperty = require('LevelHelper2-API.Animations.AnimationProperties.LHAnimationProperty');

	local object = LHAnimationProperty:initAnimationPropertyWithDictionary(dict, anim);
	
	object.superLoadDictionary = object.loadDictionary;
	object.loadDictionary = loadDictionary;
	
	object.isAnimationScaleProperty = true;
	
	return object
end
--------------------------------------------------------------------------------
return LHScaleProperty;
