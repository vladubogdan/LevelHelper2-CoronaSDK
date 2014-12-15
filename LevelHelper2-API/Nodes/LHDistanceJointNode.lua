--------------------------------------------------------------------------------
--
-- LHDistanceJointNode.lua
--
--!@docBegin
--!LHDistanceJointNode class is used to load a LevelHelper 2 distance joint node.
--!
--!@docEnd
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--!@docBegin
--!Get the distance joint damping ratio. A number value.
local function getDamping(selfNode)
--!@docEnd	
	if(selfNode.lhCoronaJoint ~= nil)then
 		return selfNode.lhCoronaJoint.dampingRatio;
 	end
	return selfNode.lhJointDampingRatio;
end
--------------------------------------------------------------------------------
--!@docBegin
--!Set the distance joint damping ratio.
--!@param value A number value.
local function setDamping(selfNode, value)
--!@docEnd	
	if(selfNode.lhCoronaJoint ~= nil)then
 		selfNode.lhCoronaJoint.dampingRatio = value;
 	end
end
--------------------------------------------------------------------------------
--!@docBegin
--!Get the distance joint frequency. A number value.
local function getFrequency(selfNode)
--!@docEnd	
	if(selfNode.lhCoronaJoint ~= nil)then
		return selfNode.lhCoronaJoint.frequency;
	end
	return selfNode.lhJointFrequency;
end
--------------------------------------------------------------------------------
--!@docBegin
--!Set the distance joint frequency.
--!@param value A number value.
local function setFrequency(selfNode, value)
--!@docEnd	
	if(selfNode.lhCoronaJoint ~= nil)then
 		selfNode.lhCoronaJoint.frequency = value;
 	end
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local function lateLoading(selfNode)
	
	selfNode:findConnectedNodes();
	
    local nodeA = selfNode:getConnectedNodeA();
	local nodeB = selfNode:getConnectedNodeB();
    
    local anchorA = selfNode:getContentAnchorA();
    local anchorB = selfNode:getContentAnchorB();
    
    if(nodeA and nodeB)then
    
    	local physics = require("physics")
		if(nil == physics)then	return end
		physics.start();

		-- print("creating distance joint");
		-- print(anchorA.x);
		-- print(anchorA.y);
		-- print(anchorB.x);
		-- print(anchorB.y);
		
-- 2014-11-21 08:01:50.584 Corona Simulator[21403:5109592] 38.984874725342
-- 2014-11-21 08:01:50.584 Corona Simulator[21403:5109592] 32.306484222412
-- 2014-11-21 08:01:50.584 Corona Simulator[21403:5109592] 32.360450744629
-- 2014-11-21 08:01:50.584 Corona Simulator[21403:5109592] 95.120918273926

--with asset
-- 2014-11-21 08:02:39.957 Corona Simulator[21403:5109592] 38.984874725342
-- 2014-11-21 08:02:39.957 Corona Simulator[21403:5109592] 32.306484222412
-- 2014-11-21 08:02:39.957 Corona Simulator[21403:5109592] 32.360450744629
-- 2014-11-21 08:02:39.957 Corona Simulator[21403:5109592] 95.120910644531
		
    	local coronaJoint = physics.newJoint(	"distance", 
                                             	nodeA,
                                              	nodeB,
	                                            anchorA.x,
                                                anchorA.y,
                                                anchorB.x,
                                                anchorB.y)
                                                
        coronaJoint.frequency 	= selfNode:getFrequency();
        coronaJoint.dampingRatio= selfNode:getDamping();
        
        selfNode.lhCoronaJoint = coronaJoint;
        
    end
end
--------------------------------------------------------------------------------
local function visit(selfNode, event)

	if(	selfNode:getConnectedNodeA() == nil or
		selfNode:getConnectedNodeB() == nil) then
	
		selfNode:lateLoading();	
	end
		
	
	selfNode:nodeProtocolEnterFrame(event);
end
--------------------------------------------------------------------------------
local function removeSelf(selfNode)

	if(selfNode.lhCoronaJoint ~= nil)then
		selfNode.lhCoronaJoint:removeSelf();
		selfNode.lhCoronaJoint = nil;
	end
	
	selfNode:_superRemoveSelf();
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local LHDistanceJointNode = {}
function LHDistanceJointNode:nodeWithDictionary(dict, prnt)

	if (nil == dict) then
		print("Invalid LHDistanceJointNode initialization!")
	end
				
	local LHUtils = require("LevelHelper2-API.Utilities.LHUtils");
    local LHNodeProtocol = require('LevelHelper2-API.Protocols.LHNodeProtocol');
    local LHJointsProtocol = require('LevelHelper2-API.Protocols.LHJointsProtocol');
    
    
    local object = display.newGroup();
    
    --add all LevelHelper 2 valid properties to the object
	object.nodeType = "LHDistanceJointNode"
	
    prnt:addChild(object);
	
	LHNodeProtocol.initNodeProtocolWithDictionary(dict, object, prnt);
	LHJointsProtocol.initJointsProtocolWithDictionary(dict, object, prnt:getScene());

    object.lhJointDampingRatio = dict["dampingRatio"];
    object.lhJointFrequency    = dict["frequency"];
	
	--add LevelHelper methods
	object.lateLoading 		= lateLoading;
    
	--add LevelHelper joint info methods
    object.getDamping 	= getDamping;
    object.setDamping 	= setDamping;
    object.getFrequency = getFrequency;
    object.setFrequency	= setFrequency;
    
    --method overloading
    object.nodeProtocolEnterFrame 	= object.enterFrame;
    object.enterFrame = visit;
    
    object._superRemoveSelf = object.removeSelf;
    object.removeSelf 		= removeSelf;
    
	return object
end
--------------------------------------------------------------------------------
return LHDistanceJointNode;

