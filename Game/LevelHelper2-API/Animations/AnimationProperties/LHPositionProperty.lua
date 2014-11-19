--------------------------------------------------------------------------------
--
-- LHPositionProperty.lua
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
	
	local LHPositionFrame = require('LevelHelper2-API.Animations.AnimationFrames.LHPositionFrame');
	
	for i=1, #framesInfo do
		local frmInfo = framesInfo[i];
		
		local frm = LHPositionFrame:frameWithDictionary(frmInfo, selfObject);
		selfObject:addKeyFrame(frm);
		
	end
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local LHPositionProperty = {}
function LHPositionProperty:initAnimationPropertyWithDictionary(dict, anim)

	if (nil == dict) then
		print("Invalid LHPositionProperty initialization!")
	end
	local LHAnimationProperty = require('LevelHelper2-API.Animations.AnimationProperties.LHAnimationProperty');

	local object = LHAnimationProperty:initAnimationPropertyWithDictionary(dict, anim);
	
	object.superLoadDictionary = object.loadDictionary;
	object.loadDictionary = loadDictionary;
	
	return object
end
--------------------------------------------------------------------------------
return LHPositionProperty;
