--------------------------------------------------------------------------------
--
-- LHGearJointNode.lua
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--!@docBegin
--!Get the joint ratio. A number value.
local function getRatio(selfNode)
--!@docEnd	
	if(selfNode.lhCoronaJoint ~= nil)then
 		return selfNode.lhCoronaJoint.ratio;
 	end
	return selfNode.lhJointRatio;
end
--------------------------------------------------------------------------------
--!@docBegin
--!Set the joint ratio.
--!@param value A number value.
local function setRatio(selfNode, value)
--!@docEnd	
	if(selfNode.lhCoronaJoint ~= nil)then
 		selfNode.lhCoronaJoint.ratio = value;
 	end
end
--------------------------------------------------------------------------------
--!@docBegin
--!Get the first joint connected to this gear joint.
local function getConnectedJointA(selfNode)
--!@docEnd	
	return selfNode.lhJointConnectedJointA;
end
--------------------------------------------------------------------------------
--!@docBegin
--!Get the second joint connected to this gear joint.
local function getConnectedJointB(selfNode)
--!@docEnd	
	return selfNode.lhJointConnectedJointB;
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local function findConnectedJoints(selfNode)

	if(selfNode.lhJointConnectedJointAUUID == nil)then
		return
	end
	
	if(selfNode.lhJointConnectedJointBUUID == nil)then
		return
	end
	
    local scene = selfNode:getScene();
	
	if(selfNode:getParent()._isNodeProtocol == true)then
		selfNode.lhJointConnectedJointA = selfNode:getParent():getChildNodeWithUUID(selfNode.lhJointConnectedJointAUUID);
		selfNode.lhJointConnectedJointB = selfNode:getParent():getChildNodeWithUUID(selfNode.lhJointConnectedJointBUUID);
	end
	
	if(selfNode.lhJointConnectedJointA == nil)then
		selfNode.lhJointConnectedJointA = scene:getChildNodeWithUUID(selfNode.lhJointConnectedJointAUUID);
	end
	
	if(selfNode.lhJointConnectedJointB == nil)then
		selfNode.lhJointConnectedJointB = scene:getChildNodeWithUUID(selfNode.lhJointConnectedJointBUUID);
	end
end

local function lateLoading(selfNode)
	
	selfNode:findConnectedNodes();
	selfNode:findConnectedJoints();
	
    local nodeA = selfNode:getConnectedNodeA();
	local nodeB = selfNode:getConnectedNodeB();
    
    local jointA = selfNode:getConnectedJointA();
	local jointB = selfNode:getConnectedJointB();
    
    if(nodeA and nodeB and jointA and jointB)then
    
    	local physics = require("physics")
		if(nil == physics)then	return end
		physics.start();

		local ratio = selfNode:getRatio();
		
		local coronaJoint = physics.newJoint(	"gear", 
                                             	nodeA,
                                              	nodeB,
												jointA.lhCoronaJoint,
                                                jointB.lhCoronaJoint,
                                                ratio);
                                                
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
local LHGearJointNode = {}
function LHGearJointNode:nodeWithDictionary(dict, prnt)

	if (nil == dict) then
		print("Invalid LHGearJointNode initialization!")
	end
				
	local LHUtils = require("LevelHelper2-API.Utilities.LHUtils");
    local LHNodeProtocol = require('LevelHelper2-API.Protocols.LHNodeProtocol');
    local LHJointsProtocol = require('LevelHelper2-API.Protocols.LHJointsProtocol');
    
    
    local object = display.newGroup();
    
    --add all LevelHelper 2 valid properties to the object
	object.nodeType = "LHGearJointNode"
	
    prnt:addChild(object);
	
	LHNodeProtocol.initNodeProtocolWithDictionary(dict, object);
	LHJointsProtocol.initJointsProtocolWithDictionary(dict, object, prnt:getScene());

 	object.lhJointRatio 	= dict["gearRatio"];
 
	local value = dict["jointAUUID"];
	if(value ~= nil)then
		object.lhJointConnectedJointAUUID = value;
	end
	
	value = dict["jointBUUID"];
	if(value ~= nil)then
		object.lhJointConnectedJointBUUID = value;
	end
        
    --add LevelHelper methods
    object.lateLoading 			= lateLoading;
    object.findConnectedJoints 	= findConnectedJoints;
    
    --add LevelHelper joint info methods
    object.getRatio= getRatio;
    object.setRatio= setRatio;
    object.getConnectedJointA = getConnectedJointA;
    object.getConnectedJointB = getConnectedJointB;
    
    --method overloading
    object.nodeProtocolEnterFrame 	= object.enterFrame;
    object.enterFrame = visit;
    
    object._superRemoveSelf = object.removeSelf;
    object.removeSelf 		= removeSelf;
    
	return object
end
--------------------------------------------------------------------------------
return LHGearJointNode;

