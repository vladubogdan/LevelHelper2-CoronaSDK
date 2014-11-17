--------------------------------------------------------------------------------
--
-- LHRevoluteJointNode.lua
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--!@docBegin
--!Returns whether or not the limit is emabled on this revolute joint node. A boolean value.
local function getIsLimitEnabled(selfNode)
--!@docEnd	
	if(selfNode.lhCoronaJoint ~= nil)then
		return selfNode.lhCoronaJoint.isLimitEnabled;
	end
	return selfNode.lhJointEnableLimit;
end
--------------------------------------------------------------------------------
--!@docBegin
--!Enable or disable the limit on this revolute joint node.
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
--!Returns the maximum motor torque. A number value.
local function getMaxMotorTorque(selfNode)
--!@docEnd	
	if(selfNode.lhCoronaJoint ~= nil)then
		return selfNode.lhCoronaJoint.maxMotorTorque;
	end
	return selfNode.lhJointMaxMotorTorque;
end
--------------------------------------------------------------------------------
--!@docBegin
--!sets the max. motor torque on the joint.
--!@param value A number value.
local function setMaxMotorTorque(selfNode, value)
--!@docEnd	
 	if(selfNode.lhCoronaJoint ~= nil)then
 		selfNode.lhCoronaJoint.maxMotorTorque = value;
 	end
end
--------------------------------------------------------------------------------
--!@docBegin
--!Returns the lower angle limit. A number value.
local function getLowerAngle(selfNode)
--!@docEnd	
	return selfNode.lhJointLowerAngle;
end
--------------------------------------------------------------------------------
--!@docBegin
--!Returns the upper angle limit. A number value.
local function getUpperAngle(selfNode)
--!@docEnd	
	return selfNode.lhJointUpperAngle;
end
--------------------------------------------------------------------------------
--!@docBegin
--!Sets the min. and max. rotation limits.
--!@param minValue A number value.
--!@param maxValue A number value.
local function setRotationLimits(selfNode, minValue, maxValue)
--!@docEnd	
	if(selfNode.lhCoronaJoint ~= nil)then
 		selfNode.lhCoronaJoint:setRotationLimits(minValue, maxValue);
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


    	local coronaJoint = physics.newJoint(	"pivot", 
                                             	nodeA,
                                              	nodeB,
												anchorA.x,
                                                anchorA.y)
                                                
		coronaJoint.isMotorEnabled 	= selfNode:getIsMotorEnabled();
		coronaJoint.motorSpeed 		= selfNode:getMotorSpeed();
		coronaJoint.isLimitEnabled 	= selfNode:getIsLimitEnabled();
		coronaJoint.maxMotorTorque 	= selfNode:getMaxMotorTorque();
		
		coronaJoint:setRotationLimits(selfNode:getLowerAngle(), selfNode:getUpperAngle());
			
		        
                -- self.coronaJoint.motorSpeed = (-1)*jointInfo:floatForKey("MotorSpeed") --for CORONA we inverse to be the same as 
                -- self.coronaJoint:setRotationLimits( jointInfo:floatForKey("LowerAngle"), jointInfo:floatForKey("UpperAngle") )
        
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
local LHRevoluteJointNode = {}
function LHRevoluteJointNode:nodeWithDictionary(dict, prnt)

	if (nil == dict) then
		print("Invalid LHRevoluteJointNode initialization!")
	end
				
	local LHUtils = require("LevelHelper2-API.Utilities.LHUtils");
    local LHNodeProtocol = require('LevelHelper2-API.Protocols.LHNodeProtocol');
    local LHJointsProtocol = require('LevelHelper2-API.Protocols.LHJointsProtocol');
    
    
    local object = display.newGroup();
    
    --add all LevelHelper 2 valid properties to the object
	object.nodeType = "LHRevoluteJointNode"
	
    prnt:addChild(object);
	
	LHNodeProtocol.initNodeProtocolWithDictionary(dict, object);
	LHJointsProtocol.initJointsProtocolWithDictionary(dict, object, prnt:getScene());

    object.lhJointEnableLimit 	= dict["enableLimit"];
    object.lhJointEnableMotor 	= dict["enableMotor"];
	
	object.lhJointLowerAngle 	= dict["lowerAngle"];
    object.lhJointUpperAngle 	= dict["upperAngle"];
	
	object.lhJointMaxMotorTorque= dict["maxMotorTorque"];
    object.lhJointMotorSpeed 	= 360.0*dict["motorSpeed"];
	    
    --add LevelHelper methods
    object.lateLoading 		= lateLoading;
    
    --add LevelHelper joint info methods
    object.setIsLimitEnabled= setIsLimitEnabled;
    object.getIsLimitEnabled= getIsLimitEnabled;
    object.getIsMotorEnabled= getIsMotorEnabled;
    object.setIsMotorEnabled= setIsMotorEnabled;
    object.getMaxMotorTorque= getMaxMotorTorque;
    object.setMaxMotorTorque= setMaxMotorTorque;
    object.getLowerAngle 	= getLowerAngle;
    object.getUpperAngle 	= getUpperAngle;
    object.getMotorSpeed 	= getMotorSpeed;
    object.setMotorSpeed 	= setMotorSpeed;
    object.setRotationLimits= setRotationLimits;
    
    --method overloading
    object.nodeProtocolEnterFrame 	= object.enterFrame;
    object.enterFrame = visit;
    
    object._superRemoveSelf = object.removeSelf;
    object.removeSelf 		= removeSelf;
    
	return object
end
--------------------------------------------------------------------------------
return LHRevoluteJointNode;

