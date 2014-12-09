--------------------------------------------------------------------------------
--
-- LHChildrenScalesProperty.lua
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local LHUtils = require("LevelHelper2-API.Utilities.LHUtils");
--------------------------------------------------------------------------------
local function newSubpropertyForNode(selfObject, node)
	
	local LHScaleProperty = require('LevelHelper2-API.Animations.AnimationProperties.LHScaleProperty');

	local prop = LHScaleProperty:initAnimationPropertyWithDictionary(nil, selfObject:getAnimation());
	prop:setSubpropertyNode(node);
	return prop;
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local LHChildrenScalesProperty = {}
function LHChildrenScalesProperty:initAnimationPropertyWithDictionary(dict, anim)

	if (nil == dict) then
		print("Invalid LHChildrenScalesProperty initialization!")
	end
	local LHScaleProperty = require('LevelHelper2-API.Animations.AnimationProperties.LHScaleProperty');

	local object = LHScaleProperty:initAnimationPropertyWithDictionary(dict, anim);
	object.newSubpropertyForNode = newSubpropertyForNode;
	
	object.isAnimationChildrenScalesProperty = true;
	
	return object
end
--------------------------------------------------------------------------------
return LHChildrenScalesProperty;
