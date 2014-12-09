--------------------------------------------------------------------------------
--
-- LHChildrenRotationsProperty.lua
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local LHUtils = require("LevelHelper2-API.Utilities.LHUtils");
--------------------------------------------------------------------------------
local function newSubpropertyForNode(selfObject, node)
	
	local LHRotationProperty = require('LevelHelper2-API.Animations.AnimationProperties.LHRotationProperty');

	local prop = LHRotationProperty:initAnimationPropertyWithDictionary(nil, selfObject:getAnimation());
	prop:setSubpropertyNode(node);
	return prop;
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local LHChildrenRotationsProperty = {}
function LHChildrenRotationsProperty:initAnimationPropertyWithDictionary(dict, anim)

	if (nil == dict) then
		print("Invalid LHChildrenRotationsProperty initialization!")
	end
	local LHRotationProperty = require('LevelHelper2-API.Animations.AnimationProperties.LHRotationProperty');

	local object = LHRotationProperty:initAnimationPropertyWithDictionary(dict, anim);
	object.newSubpropertyForNode = newSubpropertyForNode;
	
	object.isAnimationChildrenRotationsProperty = true;
	
	return object
end
--------------------------------------------------------------------------------
return LHChildrenRotationsProperty;
