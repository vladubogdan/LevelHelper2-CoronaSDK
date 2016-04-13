--------------------------------------------------------------------------------
--
-- LHWeldJointNode.lua
--
--!@docBegin
--!LHWeldJointNode class is used to load a LevelHelper weld joint.
--!
--!Conforms to:
--!
--!LHNodeProtocol
--!
--!LHJointsProtocol
--!
--!@docEnd
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--!@docBegin
--!Returns the frequency on this joint node. A number value.
local function getFrequency(selfNode)
--!@docEnd	
	if(selfNode.lhCoronaJoint ~= nil)then
		return selfNode.lhCoronaJoint.frequency;
	end
	return selfNode.lhJointFrequency;
end
--------------------------------------------------------------------------------
--!@docBegin
--!Set the frequency of this joint node.
--!@param value A number value.
local function setFrequency(selfNode, value)
--!@docEnd	
	if(selfNode.lhCoronaJoint ~= nil)then
 		selfNode.lhCoronaJoint.frequency = value;
 	end
end
--------------------------------------------------------------------------------
--!@docBegin
--!Returns the damping ratio on this joint node. A number value.
local function getDampingRatio(selfNode)
--!@docEnd	
	if(selfNode.lhCoronaJoint ~= nil)then
		return selfNode.lhCoronaJoint.dampingRatio;
	end
	return selfNode.lhJointDamping;
end
--------------------------------------------------------------------------------
--!@docBegin
--!Set the damping ratio of this joint node.
--!@param value A number value.
local function setDampingRatio(selfNode, value)
--!@docEnd	
	if(selfNode.lhCoronaJoint ~= nil)then
 		selfNode.lhCoronaJoint.dampingRatio = value;
 	end
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local function lateLoading(selfNode)
	
	selfNode:findConnectedNodes();
	
    local nodeA = selfNode:getConnectedNodeA();
	local nodeB = selfNode:getConnectedNodeB();
    
    local anchorA = selfNode:getContentAnchorA();
    
    if(nodeA and nodeB)then
    
    	local physics = require("physics")
		if(nil == physics)then	return end
		physics.start();


    	local coronaJoint = physics.newJoint(	"weld", 
                                             	nodeA,
                                              	nodeB,
												anchorA.x,
                                                anchorA.y)
                                                
		coronaJoint.frequency = selfNode:getFrequency();
        coronaJoint.dampingRatio = selfNode:getDampingRatio();
                                                
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
local LHWeldJointNode = {}
function LHWeldJointNode:nodeWithDictionary(dict, prnt)

	if (nil == dict) then
		print("Invalid LHWeldJointNode initialization!")
	end
				
	local LHUtils = require("LevelHelper2-API.Utilities.LHUtils");
    local LHNodeProtocol = require('LevelHelper2-API.Protocols.LHNodeProtocol');
    local LHJointsProtocol = require('LevelHelper2-API.Protocols.LHJointsProtocol');
    
    
    local object = display.newGroup();
    
    --add all LevelHelper 2 valid properties to the object
	object.nodeType = "LHWeldJointNode"
	
    prnt:addChild(object);
	
    local actualRemoveSelf = object.removeSelf;
    
	LHNodeProtocol.initNodeProtocolWithDictionary(dict, object, prnt);
	LHJointsProtocol.initJointsProtocolWithDictionary(dict, object, prnt:getScene());

    object.lhJointFrequency = dict["frequency"];
    object.lhJointDamping 	= dict["dampingRatio"];
	
    --add LevelHelper methods
    object.lateLoading 		= lateLoading;
    
    --add LevelHelper joint info methods
    object.setFrequency		= setFrequency;
    object.getFrequency		= getFrequency;
    object.setDampingRatio 	= setDampingRatio;
    object.getDampingRatio 	= getDampingRatio;
    
    --method overloading
    object.nodeProtocolEnterFrame 	= object.enterFrame;
    object.enterFrame = visit;
    
    object._superRemoveSelf = actualRemoveSelf;--object.removeSelf;
    object.removeSelf 		= removeSelf;   
    object.nodeProtocolRemoveSelf = nil; 
    
	return object
end
--------------------------------------------------------------------------------
return LHWeldJointNode;

