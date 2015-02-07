--------------------------------------------------------------------------------
--
-- LHBoneFrameInfo.lua
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local function getRotation(selfObject)
    return selfObject._rotation;
end
local function getPosition(selfObject)
    return selfObject._position;
end
--------------------------------------------------------------------------------
local LHBoneFrameInfo = {}
function LHBoneFrameInfo:frameInfoWithDictionary(dict)

	if (nil == dict) then
		print("Invalid LHBoneFrameInfo initialization!")
	end
	
	local LHUtils = require("LevelHelper2-API.Utilities.LHUtils");
	
	local object = {_rotation = dict["rot"],
					_position = LHUtils.pointFromString(dict["pos"]),
				}
				
	setmetatable(object, { __index = LHBoneFrameInfo })  -- Inheritance	
	
	--add methods
	object.getRotation	= getRotation;
	object.getPosition	= getPosition;
	
	return object;
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------	
return LHBoneFrameInfo;