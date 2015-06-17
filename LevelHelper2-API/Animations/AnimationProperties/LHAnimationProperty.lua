--------------------------------------------------------------------------------
--
-- LHAnimationProperty.lua
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local function keyFrames(selfObject)
	return selfObject._frames;
end
--------------------------------------------------------------------------------
local function getAnimation(selfObject)
	return selfObject._animation;
end
--------------------------------------------------------------------------------
local function addKeyFrame(selfObject, frm)
	
	if(frm == nil)then
		return
	end
	selfObject._frames[#selfObject._frames +1] = frm;
	
end
--------------------------------------------------------------------------------
local function allSubproperties(selfObject)

	if(selfObject._subproperties ~= nil)then
		local allValues = {};
		for key, value in pairs(selfObject._subproperties) do
			allValues[#allValues+1] = value;
		end
		return allValues;
	end
	
	return nil;
end
--------------------------------------------------------------------------------
local function subpropertyForUUID(selfObject, nodeUuid)
	if(selfObject._subproperties ~= nil)then
		return selfObject._subproperties[nodeUuid];
	end
	return nil;
end
--------------------------------------------------------------------------------
local function isSubproperty(selfObject)
	return selfObject._parentProperty ~= nil;
end
--------------------------------------------------------------------------------
local function subpropertyNode(selfObject)
    return selfObject._subpropertyNode;
end
--------------------------------------------------------------------------------
local function setSubpropertyNode(selfObject, val)
	selfObject._subpropertyNode = val;
end
--------------------------------------------------------------------------------
local function parentProperty(selfObject)
	return selfObject._parentProperty;
end
--------------------------------------------------------------------------------
local function setParentProperty(selfObject, val)
	selfObject._parentProperty = val;
end
--------------------------------------------------------------------------------
local function loadDictionary(selfObject, dict)
	
	if(dict == nil)then
		return
	end
	
	local subsInfo = dict["subproperties"];
	
	if(subsInfo~=nil)then
		
		local parentNode = selfObject:getAnimation():getNode();
		
		--for key, value in pairs...
		for subUUID, subInfo in pairs(subsInfo) do 
			
			local child = parentNode:getChildNodeWithUUID(subUUID);
			
			if(child == nil)then
				child = parentNode:getChildNodeWithUniqueName(subUUID);
			end
			
			if( child ~= nil and subInfo ~= nil)then
				
				if(selfObject._subproperties == nil)then
					selfObject._subproperties = {};
				end
				
				local subProp = selfObject:newSubpropertyForNode(child);
			
				if(subProp~=nil)then
					
					subProp:setParentProperty(selfObject);
					subProp:setSubpropertyNode(child);
					subProp:loadDictionary(subInfo);
					
					selfObject._subproperties[child:getUUID()] = subProp;
				end
			end
		end
	end
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local LHAnimationProperty = {}
function LHAnimationProperty:animationPropertyWithDictionary(dict, animation)
	
	local propType = dict["type"];
	
	local animPropertyClass = require('LevelHelper2-API.Animations.AnimationProperties.' .. propType);
	local object =  animPropertyClass:initAnimationPropertyWithDictionary(dict, animation);
	
	object:loadDictionary(dict);
	
	return object;
	
end
--------------------------------------------------------------------------------
function LHAnimationProperty:initAnimationPropertyWithDictionary(dict, anim)

	-- if (nil == dict) then
	-- 	print("Invalid LHAnimationProperty initialization!")
	-- end
	
	local object = {_animation = anim,
					_frames = {}
				}
	setmetatable(object, { __index = LHAnimationProperty })  -- Inheritance

	--add methods
	object.keyFrames 		= keyFrames;
	object.getAnimation 	= getAnimation;
	object.loadDictionary 	= loadDictionary;
	object.addKeyFrame		= addKeyFrame;
	object.allSubproperties = allSubproperties;
	object.subpropertyForUUID = subpropertyForUUID;
	
	object.isSubproperty = isSubproperty;
	object.subpropertyNode = subpropertyNode;
	object.setSubpropertyNode = setSubpropertyNode;
	object.parentProperty = parentProperty;
	object.setParentProperty = setParentProperty;
	
	return object
end
--------------------------------------------------------------------------------
return LHAnimationProperty;
