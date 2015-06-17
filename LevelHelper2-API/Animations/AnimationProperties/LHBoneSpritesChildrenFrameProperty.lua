--------------------------------------------------------------------------------
--
-- LHBoneSpritesChildrenFrameProperty.lua
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local LHUtils = require("LevelHelper2-API.Utilities.LHUtils");
--------------------------------------------------------------------------------
local function newSubpropertyForNode(selfObject, node)
	
	local LHSpriteFrameProperty = require('LevelHelper2-API.Animations.AnimationProperties.LHSpriteFrameProperty');

	local prop = LHSpriteFrameProperty:initAnimationPropertyWithDictionary(nil, selfObject:getAnimation());
	prop:setSubpropertyNode(node);
	return prop;
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local LHBoneSpritesChildrenFrameProperty = {}
function LHBoneSpritesChildrenFrameProperty:initAnimationPropertyWithDictionary(dict, anim)

	if (nil == dict) then
		print("Invalid LHBoneSpritesChildrenFrameProperty initialization!")
	end
	
	local LHSpriteFrameProperty = require('LevelHelper2-API.Animations.AnimationProperties.LHSpriteFrameProperty');

	local object = LHSpriteFrameProperty:initAnimationPropertyWithDictionary(dict, anim);
	object.newSubpropertyForNode = newSubpropertyForNode;
	
	object.isAnimationBoneSpritesChildrenFrameProperty = true;
	
	return object
end
--------------------------------------------------------------------------------
return LHBoneSpritesChildrenFrameProperty;
