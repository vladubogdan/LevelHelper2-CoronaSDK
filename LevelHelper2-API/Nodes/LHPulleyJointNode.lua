--------------------------------------------------------------------------------
--
-- LHPulleyJointNode.lua
--
--!@docBegin
--!LHPulleyJointNode class is used to load a LevelHelper pulley joint.
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
--!Returns the ratio of this joint node. A number value.
local function getRatio(selfNode)
--!@docEnd	
	return selfNode.lhJointRatio;
end
--------------------------------------------------------------------------------
--!@docBegin
--!Returns the first ground anchor point. In scene coordinates. A point value, e.g {x=100, y=100}
local function getGroundAnchorA(selfNode)
--!@docEnd	
	return selfNode.lhJointGroundAnchorA;
end
--------------------------------------------------------------------------------
--!@docBegin
--!Returns the second ground anchor point. In scene coordinates. A point value, e.g {x=100, y=100}
local function getGroundAnchorB(selfNode)
--!@docEnd	
	return selfNode.lhJointGroundAnchorB;
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

		local groundAnchorA = selfNode:getGroundAnchorA();
		local groundAnchorB = selfNode:getGroundAnchorB();

		local ratio = selfNode:getRatio();
		
    	local coronaJoint = physics.newJoint(	"pulley", 
                                             	nodeA,
                                              	nodeB,
                        						groundAnchorA.x,
                        						groundAnchorA.y,
                        						groundAnchorB.x,
                        						groundAnchorB.y,
												anchorA.x,
                                                anchorA.y,
                                                anchorB.x,
                                                anchorB.y,
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
local LHPulleyJointNode = {}
function LHPulleyJointNode:nodeWithDictionary(dict, prnt)

	if (nil == dict) then
		print("Invalid LHPulleyJointNode initialization!")
	end
				
	local LHUtils = require("LevelHelper2-API.Utilities.LHUtils");
    local LHNodeProtocol = require('LevelHelper2-API.Protocols.LHNodeProtocol');
    local LHJointsProtocol = require('LevelHelper2-API.Protocols.LHJointsProtocol');
    
    
    local object = display.newGroup();
    
    --add all LevelHelper 2 valid properties to the object
	object.nodeType = "LHPulleyJointNode"
	
    prnt:addChild(object);
    
    local actualRemoveSelf = object.removeSelf;
	
	LHNodeProtocol.initNodeProtocolWithDictionary(dict, object, prnt);
	LHJointsProtocol.initJointsProtocolWithDictionary(dict, object, prnt:getScene());

    object.lhJointGroundAnchorA = LHUtils.pointFromString(dict["groundAnchorA"]);
    object.lhJointGroundAnchorB = LHUtils.pointFromString(dict["groundAnchorB"]);
    object.lhJointRatio = dict["ratio"];
    
    --add LevelHelper methods
    object.lateLoading 		= lateLoading;
    
    --add LevelHelper joint info methods
    object.getRatio			= getRatio;
    object.getGroundAnchorA	= getGroundAnchorA;
    object.getGroundAnchorB = getGroundAnchorB;
    
    --method overloading
    object.nodeProtocolEnterFrame 	= object.enterFrame;
    object.enterFrame = visit;
    
    object._superRemoveSelf = actualRemoveSelf;--object.removeSelf;
    object.removeSelf 		= removeSelf;   
    object.nodeProtocolRemoveSelf = nil; 
    
	return object
end
--------------------------------------------------------------------------------
return LHPulleyJointNode;

