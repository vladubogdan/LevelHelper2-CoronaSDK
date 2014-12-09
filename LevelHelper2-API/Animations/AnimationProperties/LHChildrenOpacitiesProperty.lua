--------------------------------------------------------------------------------
--
-- LHChildrenOpacitiesProperty.lua
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local LHUtils = require("LevelHelper2-API.Utilities.LHUtils");
--------------------------------------------------------------------------------
local function newSubpropertyForNode(selfObject, node)
	
	local LHOpacityProperty = require('LevelHelper2-API.Animations.AnimationProperties.LHOpacityProperty');

	local prop = LHOpacityProperty:initAnimationPropertyWithDictionary(nil, selfObject:getAnimation());
	prop:setSubpropertyNode(node);
	return prop;
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local LHChildrenOpacitiesProperty = {}
function LHChildrenOpacitiesProperty:initAnimationPropertyWithDictionary(dict, anim)

	if (nil == dict) then
		print("Invalid LHChildrenOpacitiesProperty initialization!")
	end
	local LHOpacityProperty = require('LevelHelper2-API.Animations.AnimationProperties.LHOpacityProperty');

	local object = LHOpacityProperty:initAnimationPropertyWithDictionary(dict, anim);
	object.newSubpropertyForNode = newSubpropertyForNode;
	
	object.isAnimationChildrenOpacitiesProperty = true;
	
	return object
end
--------------------------------------------------------------------------------
return LHChildrenOpacitiesProperty;
