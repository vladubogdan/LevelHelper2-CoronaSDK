--------------------------------------------------------------------------------
--
-- LHJointsProtocol.lua
--
--!@docBegin
--!LevelHelper 2 joint nodes conform to this protocol.
--!
--!@docEnd
--------------------------------------------------------------------------------
module (..., package.seeall)
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--!@docBegin
--!Get the first node that this joint connect. May return nil if findConnectedNodes has not been called yet.
local function getConnectedNodeA(selfNode)
--!@docEnd	
	return selfNode.lhJointConnectedNodeA;
end
--------------------------------------------------------------------------------
--!@docBegin
--!Get the second node that this joint connect. May return nil if findConnectedNodes has not been called yet.
local function getConnectedNodeB(selfNode)
--!@docEnd	
	return selfNode.lhJointConnectedNodeB;
end
--------------------------------------------------------------------------------
--!@docBegin
--!Get the actual corona joint object from the LevelHelper joint node.
local function getCoronaJoint(selfNode)
--!@docEnd	
	if(selfNode.lhCoronaJoint == nil)then
		selfNode:lateLoading();
	end

	return selfNode.lhCoronaJoint;
end
--------------------------------------------------------------------------------
--!@docBegin
--!Get the first joint local anchor.
local function getLocalAnchorA(selfNode)
--!@docEnd	
	return  {	x = selfNode.lhJointRelativePosA.x * selfNode.xScale,
				y = selfNode.lhJointRelativePosA.y * selfNode.yScale};
end
--------------------------------------------------------------------------------
--!@docBegin
--!Get the second joint local anchor.
local function getLocalAnchorB(selfNode)
--!@docEnd	
	return  {	x = selfNode.lhJointRelativePosB.x * selfNode.xScale,
				y = selfNode.lhJointRelativePosB.y * selfNode.yScale};
end
--------------------------------------------------------------------------------
--!@docBegin
--!Get the joint collide connected state
local function getCollideConnected(selfNode)
--!@docEnd	
	return  selfNode.lhJointCollideConnected
end
--------------------------------------------------------------------------------
--!@docBegin
--!Get the joint anchor A in content space
local function getContentAnchorA(selfNode)
--!@docEnd
	
	local object = selfNode:getConnectedNodeA();
	local pt = selfNode:getLocalAnchorA();
	
	local contentX, contentY = object:localToContent( pt.x, pt.y );
	
	return {x = contentX, y = contentY};
end
--------------------------------------------------------------------------------
--!@docBegin
--!Get the joint anchor B in content space
local function getContentAnchorB(selfNode)
--!@docEnd
	
	local object = selfNode:getConnectedNodeB();
	local pt = selfNode:getLocalAnchorB();
	
	local contentX, contentY = object:localToContent( pt.x, pt.y );
	
	return {x = contentX, y = contentY};
end
--------------------------------------------------------------------------------
--!@docBegin
--!Find the nodes connected by this joint based on the uuid of the nodes.
local function findConnectedNodes(selfNode)
--!@docEnd	
	
	if(selfNode.lhJointNodeAUUID == nil)then
		return
	end
	
	if(selfNode.lhJointNodeBUUID == nil)then
		return
	end
	
	local scene = selfNode:getScene();
	
	if(selfNode:getParent()._isNodeProtocol == true)then
		selfNode.lhJointConnectedNodeA = selfNode:getParent():getChildNodeWithUUID(selfNode.lhJointNodeAUUID);
		selfNode.lhJointConnectedNodeB = selfNode:getParent():getChildNodeWithUUID(selfNode.lhJointNodeBUUID);
	end
	
	if(selfNode.lhJointConnectedNodeA == nil)then
		selfNode.lhJointConnectedNodeA = scene:getChildNodeWithUUID(selfNode.lhJointNodeAUUID);
	end
	
	if(selfNode.lhJointConnectedNodeB == nil)then
		selfNode.lhJointConnectedNodeB = scene:getChildNodeWithUUID(selfNode.lhJointNodeBUUID);
	end
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
function initJointsProtocolWithDictionary(dict, node, scene)

	
    local LHUtils = require("LevelHelper2-API.Utilities.LHUtils");

    node._isJointsProtocol = true;
	node.protocolName = "LHJointsProtocol";

	if(dict == nil)then return end;
	
	local value = dict["relativePosA"];
    if(value)then
    	--certain joints do not have an anchor (e.g. gear joint)
    	node.lhJointRelativePosA = LHUtils.pointFromString(value);
    end
	
	value = dict["relativePosB"];
    if(value)then
    	--certain joints do not have a second anchor
    	node.lhJointRelativePosB = LHUtils.pointFromString(value);
    end
	
	value = dict["spriteAUUID"];
    if(value)then
    	--maybe its a dummy joint (not connected to anything)
    	node.lhJointNodeAUUID = value;
    else
    	print("WARNING: Joint " .. node.lhUniqueName .. " is not connected to a node");
    end
	
	value = dict["spriteBUUID"];
    if(value)then
    	--maybe its a dummy joint (not connected to anything)
    	node.lhJointNodeBUUID = value;
    else
    	print("WARNING: Joint " .. node.lhUniqueName .. " is not connected to a node");
    end
	
	node.lhJointCollideConnected = false;
	value = dict["collideConnected"];
    if(value)then
    	node.lhJointCollideConnected = value;
    end

	--LevelHelper 2 node joints protocol functions
	----------------------------------------------------------------------------
	node.getConnectedNodeA 	= getConnectedNodeA;
	node.getConnectedNodeB 	= getConnectedNodeB;
	node.findConnectedNodes	= findConnectedNodes;
	node.getLocalAnchorA 	= getLocalAnchorA;
	node.getLocalAnchorB 	= getLocalAnchorB;
	node.getCollideConnected= getCollideConnected;
	node.getContentAnchorA  = getContentAnchorA;
	node.getContentAnchorB  = getContentAnchorB;
	node.getCoronaJoint 	= getCoronaJoint;
	
end
