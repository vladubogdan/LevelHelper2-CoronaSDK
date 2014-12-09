--------------------------------------------------------------------------------
--
-- LHChildrenPositionsProperty.lua
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local LHUtils = require("LevelHelper2-API.Utilities.LHUtils");
--------------------------------------------------------------------------------
local function newSubpropertyForNode(selfObject, node)
	
	local LHPositionProperty = require('LevelHelper2-API.Animations.AnimationProperties.LHPositionProperty');

	local prop = LHPositionProperty:initAnimationPropertyWithDictionary(nil, selfObject:getAnimation());
	prop:setSubpropertyNode(node);
	
	return prop;
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local LHChildrenPositionsProperty = {}
function LHChildrenPositionsProperty:initAnimationPropertyWithDictionary(dict, anim)

	if (nil == dict) then
		print("Invalid LHChildrenPositionsProperty initialization!")
	end
	local LHPositionProperty = require('LevelHelper2-API.Animations.AnimationProperties.LHPositionProperty');

	local object = LHPositionProperty:initAnimationPropertyWithDictionary(dict, anim);
	object.newSubpropertyForNode = newSubpropertyForNode;
	
	object.isAnimationChildrenPositionsProperty = true;
	
	return object
end
--------------------------------------------------------------------------------
return LHChildrenPositionsProperty;
