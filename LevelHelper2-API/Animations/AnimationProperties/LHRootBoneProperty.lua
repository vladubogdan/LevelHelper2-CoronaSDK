--------------------------------------------------------------------------------
--
-- LHRootBoneProperty.lua
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
	
	local LHBoneFrame = require('LevelHelper2-API.Animations.AnimationFrames.LHBoneFrame');
	
	for i=1, #framesInfo do
		local frmInfo = framesInfo[i];
		
		local frm = LHBoneFrame:frameWithDictionary(frmInfo, selfObject);
		selfObject:addKeyFrame(frm);
		
	end
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local LHRootBoneProperty = {}
function LHRootBoneProperty:initAnimationPropertyWithDictionary(dict, anim)

	-- if (nil == dict) then
	-- 	print("Invalid LHPositionProperty initialization!")
	-- end
	
	local LHAnimationProperty = require('LevelHelper2-API.Animations.AnimationProperties.LHAnimationProperty');

	local object = LHAnimationProperty:initAnimationPropertyWithDictionary(dict, anim);
	
	object.superLoadDictionary = object.loadDictionary;
	object.loadDictionary = loadDictionary;
	
	object.isAnimationRootBoneProperty = true;
	
	return object
end
--------------------------------------------------------------------------------
return LHRootBoneProperty;
