--------------------------------------------------------------------------------
--
-- LHPrismaticJointNode.lua
--
--!@docBegin
--!LHPrismaticJointNode class is used to load a LevelHelper prismatic joint or as they are called in Corona SDK, piston joints.
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
--!Returns whether or not the limit is emabled on this joint node. A boolean value.
local function getIsLimitEnabled(selfNode)
--!@docEnd	
	if(selfNode.lhCoronaJoint ~= nil)then
		return selfNode.lhCoronaJoint.isLimitEnabled;
	end
	return selfNode.lhJointEnableLimit;
end
--------------------------------------------------------------------------------
--!@docBegin
--!Enable or disable the limit on this joint node.
--!@param value A boolean value.
local function setIsLimitEnabled(selfNode, value)
--!@docEnd	
	if(selfNode.lhCoronaJoint ~= nil)then
 		selfNode.lhCoronaJoint.isLimitEnabled = value;
 	end
end
--------------------------------------------------------------------------------
--!@docBegin
--!Returns whether or not the motor is enabled on the joint. A boolean value.
local function getIsMotorEnabled(selfNode)
--!@docEnd
	if(selfNode.lhCoronaJoint ~= nil)then
		return selfNode.lhCoronaJoint.isMotorEnabled;
	end
	return selfNode.lhJointEnableMotor;
end
--------------------------------------------------------------------------------
--!@docBegin
--!Enable or disable motor on the joint.
--!@param value A boolean value.
local function setIsMotorEnabled(selfNode, value)
--!@docEnd	
 	if(selfNode.lhCoronaJoint ~= nil)then
 		selfNode.lhCoronaJoint.isMotorEnabled = value;
 	end
end
--------------------------------------------------------------------------------
--!@docBegin
--!Returns the maximum motor force. A number value.
local function getMaxMotorForce(selfNode)
--!@docEnd	
	if(selfNode.lhCoronaJoint ~= nil)then
		return selfNode.lhCoronaJoint.maxMotorForce;
	end
	return selfNode.lhJointMaxMotorForce;
end
--------------------------------------------------------------------------------
--!@docBegin
--!sets the max. motor force on the joint.
--!@param value A number value.
local function setMaxMotorForce(selfNode, value)
--!@docEnd	
 	if(selfNode.lhCoronaJoint ~= nil)then
 		selfNode.lhCoronaJoint.maxMotorForce = value;
 	end
end
--------------------------------------------------------------------------------
--!@docBegin
--!Returns the motor speed. A number value.
local function getMotorSpeed(selfNode)
--!@docEnd	
	if(selfNode.lhCoronaJoint ~= nil)then
		return selfNode.lhCoronaJoint.motorSpeed;
	end
	return selfNode.lhJointMotorSpeed;
end
--------------------------------------------------------------------------------
--!@docBegin
--!Sets the motor speed
--!@param value A number value.
local function setMotorSpeed(selfNode, value)
--!@docEnd	

	if(selfNode.lhCoronaJoint ~= nil)then
 		selfNode.lhCoronaJoint.motorSpeed = value;
 	end
end
--------------------------------------------------------------------------------
--!@docBegin
--!Returns the lower joint translation limit. A number value.
local function getLowerTranslation(selfNode)
--!@docEnd	
	return selfNode.lhJointLowerTranslation;
end
--------------------------------------------------------------------------------
--!@docBegin
--!Returns the upper joint translation limit. A number value.
local function getUpperTranslation(selfNode)
--!@docEnd	
	return selfNode.lhJointUpperTranslation;
end
--------------------------------------------------------------------------------
--!@docBegin
--!Sets the lower and upper translation limits.
--!@param lowerValue A number value.
--!@param upperValue A number value.
local function setLimits(selfNode, lowerValue, upperValue)
--!@docEnd	
	if(selfNode.lhCoronaJoint ~= nil)then
 		selfNode.lhCoronaJoint:setLimits(minValue, maxValue);
 	end
end
--------------------------------------------------------------------------------
--!@docBegin
--!Returns the joint movement axis. A point value. Table with "x" and "y" keys.
local function getAxis(selfNode)
--!@docEnd	
	return selfNode.lhJointAxis;
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local function lateLoading(selfNode)
	
	selfNode:findConnectedNodes();
	
    local nodeA = selfNode:getConnectedNodeA();
	local nodeB = selfNode:getConnectedNodeB();
    
    local anchorA = selfNode:getContentAnchorA();
    
    if(nodeA and nodeB)then
    	
    	--reset nodes to original position as they may be on top of each other and box2d has snapped them outside of each other
		--as the joints do not exist yet
	    nodeA:setPosition(nodeA.lhOriginalPosition);
		nodeB:setPosition(nodeB.lhOriginalPosition);

		local anchorA = selfNode:getContentAnchorA();
    
    
    	local physics = require("physics")
		if(nil == physics)then	return end
		physics.start();

		local axis = selfNode:getAxis();

    	local coronaJoint = physics.newJoint(	"piston", 
                                             	nodeA,
                                              	nodeB,
												anchorA.x,
                                                anchorA.y,
                                                axis.x,
                                                axis.y)
	
		coronaJoint.isMotorEnabled 	= selfNode:getIsMotorEnabled();
		coronaJoint.motorSpeed 		= selfNode:getMotorSpeed();
		coronaJoint.maxMotorForce 	= selfNode:getMaxMotorForce();
		coronaJoint.isLimitEnabled 	= selfNode:getIsLimitEnabled();
	    coronaJoint:setLimits(selfNode:getLowerTranslation(), selfNode:getUpperTranslation());           

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
local LHPrismaticJointNode = {}
function LHPrismaticJointNode:nodeWithDictionary(dict, prnt)

	if (nil == dict) then
		print("Invalid LHPrismaticJointNode initialization!")
	end
				
	local LHUtils = require("LevelHelper2-API.Utilities.LHUtils");
    local LHNodeProtocol = require('LevelHelper2-API.Protocols.LHNodeProtocol');
    local LHJointsProtocol = require('LevelHelper2-API.Protocols.LHJointsProtocol');
    
    
    local object = display.newGroup();
    
    --add all LevelHelper 2 valid properties to the object
	object.nodeType = "LHPrismaticJointNode"
	
    prnt:addChild(object);
	
    local actualRemoveSelf = object.removeSelf;
    
	LHNodeProtocol.initNodeProtocolWithDictionary(dict, object, prnt);
	LHJointsProtocol.initJointsProtocolWithDictionary(dict, object, prnt:getScene());

    object.lhJointEnableLimit 		= dict["enablePrismaticLimit"];
    object.lhJointEnableMotor 		= dict["enablePrismaticMotor"];
	object.lhJointLowerTranslation 	= dict["lowerTranslation"];
    object.lhJointUpperTranslation 	= dict["upperTranslation"];
	object.lhJointMaxMotorForce 	= dict["maxMotorForce"];
    object.lhJointMotorSpeed 		= 360.0*dict["prismaticMotorSpeed"];
	object.lhJointAxis 				= LHUtils.pointFromString(dict["axis"]);
        
    --add LevelHelper methods
    object.lateLoading 		= lateLoading;
    
    --add LevelHelper joint info methods
    object.setIsLimitEnabled	= setIsLimitEnabled;
    object.getIsLimitEnabled	= getIsLimitEnabled;
    object.getIsMotorEnabled	= getIsMotorEnabled;
    object.setIsMotorEnabled	= setIsMotorEnabled;
    object.getMaxMotorForce 	= getMaxMotorForce;
    object.setMaxMotorForce 	= setMaxMotorForce;
    object.getMotorSpeed 		= getMotorSpeed;
    object.setMotorSpeed 		= setMotorSpeed;
    object.getLowerTranslation 	= getLowerTranslation;
    object.getUpperTranslation 	= getUpperTranslation;
    object.setLimits			= setLimits;
    object.getAxis				= getAxis;
    
    --method overloading
    object.nodeProtocolEnterFrame 	= object.enterFrame;
    object.enterFrame = visit;
    
    object._superRemoveSelf = actualRemoveSelf;--object.removeSelf;
    object.removeSelf 		= removeSelf;   
    object.nodeProtocolRemoveSelf = nil; 
    
	return object
end
--------------------------------------------------------------------------------
return LHPrismaticJointNode;

