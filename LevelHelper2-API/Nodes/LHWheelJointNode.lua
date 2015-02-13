--------------------------------------------------------------------------------
--
-- LHWheelJointNode.lua
--
--!@docBegin
--!LHWheelJointNode class is used to load a LevelHelper wheel joint.
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
--!Returns the joint movement axis. A point value. Table with "x" and "y" keys.
local function getAxis(selfNode)
--!@docEnd	
	return selfNode.lhJointAxis;
end
--------------------------------------------------------------------------------
--!@docBegin
--!Get the joint damping ratio. A number value.
local function getSpringDampingRatio(selfNode)
--!@docEnd	
	if(selfNode.lhCoronaJoint ~= nil)then
 		return selfNode.lhCoronaJoint.springDampingRatio;
 	end
	return selfNode.lhJointDampingRatio;
end
--------------------------------------------------------------------------------
--!@docBegin
--!Set the joint damping ratio.
--!@param value A number value.
local function setSpringDampingRatio(selfNode, value)
--!@docEnd	
	if(selfNode.lhCoronaJoint ~= nil)then
 		selfNode.lhCoronaJoint.springDampingRatio = value;
 	end
end
--------------------------------------------------------------------------------
--!@docBegin
--!Get the joint frequency. A number value.
local function getSpringFrequency(selfNode)
--!@docEnd	
	if(selfNode.lhCoronaJoint ~= nil)then
		return selfNode.lhCoronaJoint.springFrequency;
	end
	return selfNode.lhJointFrequency;
end
--------------------------------------------------------------------------------
--!@docBegin
--!Set the joint frequency.
--!@param value A number value.
local function setSpringFrequency(selfNode, value)
--!@docEnd	
	if(selfNode.lhCoronaJoint ~= nil)then
 		selfNode.lhCoronaJoint.springFrequency = value;
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

		local axis = selfNode:getAxis();

    	local coronaJoint = physics.newJoint(	"wheel", 
                                             	nodeA,
                                              	nodeB,
												anchorA.x,
                                                anchorA.y,
                                                axis.x,
                                                axis.y);
                                                
		coronaJoint.isMotorEnabled 		= selfNode:getIsMotorEnabled();
		coronaJoint.motorSpeed 			= selfNode:getMotorSpeed();
		coronaJoint.maxMotorTorque 		= selfNode:getMaxMotorTorque();
		coronaJoint.springFrequency 	= selfNode:getSpringFrequency();
		coronaJoint.springDampingRatio 	= selfNode:getSpringDampingRatio();
		
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
local LHWheelJointNode = {}
function LHWheelJointNode:nodeWithDictionary(dict, prnt)

	if (nil == dict) then
		print("Invalid LHWheelJointNode initialization!")
	end
				
	local LHUtils = require("LevelHelper2-API.Utilities.LHUtils");
    local LHNodeProtocol = require('LevelHelper2-API.Protocols.LHNodeProtocol');
    local LHJointsProtocol = require('LevelHelper2-API.Protocols.LHJointsProtocol');
    
    
    local object = display.newGroup();
    
    --add all LevelHelper 2 valid properties to the object
	object.nodeType = "LHWheelJointNode"
	
    prnt:addChild(object);
	
	LHNodeProtocol.initNodeProtocolWithDictionary(dict, object, prnt);
	LHJointsProtocol.initJointsProtocolWithDictionary(dict, object, prnt:getScene());

    object.lhJointEnableMotor 	= dict["enableWheelMotor"];
	
	object.lhJointDampingRatio 	= dict["wheelDampingRatio"];
    object.lhJointFrequency    	= dict["wheelFrequencyHz"];
	
	object.lhJointMaxMotorTorque= dict["wheelMaxMotorForce"];
    object.lhJointMotorSpeed 	= 360.0*dict["wheelMotorSpeed"];
	
	object.lhJointAxis 			= LHUtils.pointFromString(dict["axis"]);
    
    --add LevelHelper methods
    object.lateLoading 		= lateLoading;
    
    --add LevelHelper joint info methods
    object.getIsMotorEnabled	= getIsMotorEnabled;
    object.setIsMotorEnabled	= setIsMotorEnabled;
    object.getSpringDampingRatio= getSpringDampingRatio;
    object.setSpringDampingRatio= setSpringDampingRatio;
    object.getSpringFrequency 	= getSpringFrequency;
    object.setSpringFrequency	= setSpringFrequency;
    object.getMotorSpeed 		= getMotorSpeed;
    object.setMotorSpeed 		= setMotorSpeed;
    object.getMaxMotorTorque	= getMaxMotorTorque;
    object.setMaxMotorTorque	= setMaxMotorTorque;
    object.getAxis				= getAxis;
     
    --method overloading
    object.nodeProtocolEnterFrame 	= object.enterFrame;
    object.enterFrame = visit;
    
    object._superRemoveSelf = object.removeSelf;
    object.removeSelf 		= removeSelf;
    
	return object
end
--------------------------------------------------------------------------------
return LHWheelJointNode;

