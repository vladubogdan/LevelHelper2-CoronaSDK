--------------------------------------------------------------------------------
--
-- LHChildrenSpriteFramesProperty.lua
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
local LHChildrenSpriteFramesProperty = {}
function LHChildrenSpriteFramesProperty:initAnimationPropertyWithDictionary(dict, anim)

	if (nil == dict) then
		print("Invalid LHChildrenSpriteFramesProperty initialization!")
	end
	local LHSpriteFrameProperty = require('LevelHelper2-API.Animations.AnimationProperties.LHSpriteFrameProperty');

	local object = LHSpriteFrameProperty:initAnimationPropertyWithDictionary(dict, anim);
	object.newSubpropertyForNode = newSubpropertyForNode;
	
	object.isAnimationChildrenSpriteFramesProperty = true;
	
	return object
end
--------------------------------------------------------------------------------
return LHChildrenSpriteFramesProperty;
