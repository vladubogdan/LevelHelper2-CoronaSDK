--------------------------------------------------------------------------------
--
-- LHBoneFrame.lua
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local function frameInfoForBoneNamed(selfObject, nm)
	return selfObject._bonesInfo[nm];
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local LHBoneFrame = {}
function LHBoneFrame:frameWithDictionary(dict, prop)

	if (nil == dict) then
		print("Invalid LHBoneFrame initialization!")
	end
	
	local LHFrame = require('LevelHelper2-API.Animations.AnimationFrames.LHFrame');
	local LHUtils = require("LevelHelper2-API.Utilities.LHUtils");
	
	local LHBoneFrameInfo = require('LevelHelper2-API.Animations.AnimationFrames.LHBoneFrameInfo');
	
	local object = LHFrame:frameWithDictionary(dict, prop);
	
	object._bonesInfo = {};
	
	local savedBonesInfo = dict["bonesInfo"];
	
	for conName, conDict in pairs(savedBonesInfo)do
		local frmInfo = LHBoneFrameInfo:frameInfoWithDictionary(conDict);
		object._bonesInfo[conName] = frmInfo;
	end
	
	--add methods
	object.frameInfoForBoneNamed	= frameInfoForBoneNamed;
	
	return object
end
--------------------------------------------------------------------------------
return LHBoneFrame;