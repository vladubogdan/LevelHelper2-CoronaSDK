--------------------------------------------------------------------------------
--
-- LHFrame.lua
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local function setWasShot(selfObject, value)
    selfObject.wasShot = value;
end
--------------------------------------------------------------------------------
local function wasShot(selfObject)
    return selfObject.wasShot;
end
--------------------------------------------------------------------------------
local function frameNumber(selfObject)
    return selfObject._frameNumber;
end
--------------------------------------------------------------------------------
local function property(selfObject)
    return selfObject._property;
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local LHFrame = {}
function LHFrame:frameWithDictionary(dict, prop)

	if (nil == dict) then
		print("Invalid LHFrame initialization!")
	end
	
	local object = {_frameNumber = dict["frameIndex"],
					_property = prop,
					wasShot = false
				}
	setmetatable(object, { __index = LHFrame })  -- Inheritance

	--add methods
	object.setWasShot	= setWasShot;
	object.wasSho		= wasShot;
	object.frameNumber 	= frameNumber;
	object.property 	= property;
	
	
	return object
end
--------------------------------------------------------------------------------
return LHFrame;
