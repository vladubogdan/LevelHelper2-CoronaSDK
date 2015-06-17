--------------------------------------------------------------------------------
--
-- LHBoneSpritesChildrenOpacityProperty.lua
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
local LHBoneSpritesChildrenOpacityProperty = {}
function LHBoneSpritesChildrenOpacityProperty:initAnimationPropertyWithDictionary(dict, anim)

	if (nil == dict) then
		print("Invalid LHBoneSpritesChildrenOpacityProperty initialization!")
	end
	local LHOpacityProperty = require('LevelHelper2-API.Animations.AnimationProperties.LHOpacityProperty');

	local object = LHOpacityProperty:initAnimationPropertyWithDictionary(dict, anim);
	object.newSubpropertyForNode = newSubpropertyForNode;
	
	object.isAnimationBoneSpritesChildrenOpacityProperty = true;
	
	return object
end
--------------------------------------------------------------------------------
return LHBoneSpritesChildrenOpacityProperty;
