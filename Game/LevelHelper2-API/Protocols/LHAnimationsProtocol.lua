--------------------------------------------------------------------------------
--
-- LHAnimationsProtocol.lua
--
--------------------------------------------------------------------------------
module (..., package.seeall)
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--!@docBegin
--!Set the active animation on a node.
--!@param animObj The animation object that is about to get activated.
local function setActiveAnimation(selfNode, animObj)
--!@docEnd	
	selfNode.lhActiveAnimation = animObj;
	if(animObj)then
		animObj:setAnimating(true);
	end
end
--------------------------------------------------------------------------------
--!@docBegin
--!Returns the active animation on a node or nil if no active animation. A LHAnimation object.
--!@param animObj The animation object that is about to get activated.
local function getActiveAnimation(selfNode)
--!@docEnd	
	return  selfNode.lhActiveAnimation;
end
--------------------------------------------------------------------------------
--!@docBegin
--!Returns the animation with a given name or nil if no animation with the specified name is found on the node. A LHAnimation object.
--!@param animName The name of the animation that you want returned.
local function getAnimationWithName(selfNode, animName)
--!@docEnd	
	for i=1, #selfNode.lhAnimations do
		local anim = selfNode.lhAnimations[i];
		if(anim:getName() == animName)then
			return anim;
		end
	end
	return nil;
end
--------------------------------------------------------------------------------
local function animationProtocolEnterFrame(selfNode, event)
	
	local thisTime = event.time;
	local dt = (thisTime - selfNode._animProtocolLastTime)/1000.0;

	-- print("delta " .. tostring(dt));
	
	if(selfNode.lhActiveAnimation~=nil)then
		
		--check if game play is paused
		
		selfNode.lhActiveAnimation:updateTimeWithDelta(dt);
	end

	selfNode._animProtocolLastTime = thisTime;
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
function initAnimationsProtocolWithDictionary(dict, node, scene)

	
    local LHUtils = require("LevelHelper2-API.Utilities.LHUtils");

    node._isAnimationsProtocol = true;
    node.protocolName = "LHAnimationsProtocol";

	if(dict == nil)then return end;
	
	node.lhActiveAnimation = nil;
        
    local animsInfo = dict["animations"];
	
	if(animsInfo ~= nil)then
		
		local LHAnimation = require('LevelHelper2-API.Animations.LHAnimation');
		
	    for i = 1, #animsInfo do
	    	local anim = animsInfo[i];
	    	
	    	if(node.lhAnimations == nil)then
	    		node.lhAnimations = {};
	    	end
	    	
	    	local newAnim = LHAnimation:animationWithDictionary(anim, node);
	    	if(newAnim:isActive())then
	    		node.lhActiveAnimation = newAnim;
	    	end
	    	
	    	node.lhAnimations[#node.lhAnimations+1] = newAnim;
	    end
	    
    end
	--LevelHelper 2 animations protocol functions
	----------------------------------------------------------------------------
	node.setActiveAnimation 	= setActiveAnimation;
	node.getActiveAnimation 	= getActiveAnimation;
	node.getAnimationWithName 	= getAnimationWithName;
	
	--LevelHelper 2 animation protocol private functions
	----------------------------------------------------------------------------
	node._animProtocolLastTime = 0.0;
	node.animationProtocolEnterFrame = animationProtocolEnterFrame;
	
end
