--------------------------------------------------------------------------------
--
-- LHDistanceJointNode.lua
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--!@docBegin
--!Get the distance joint damping ratio. A number value.
local function getDamping(selfNode)
--!@docEnd	
	return selfNode.lhJointDampingRatio;
end
--------------------------------------------------------------------------------
--!@docBegin
--!Get the distance joint frequency. A number value.
local function getFrequency(selfNode)
--!@docEnd	
	return selfNode.lhJointFrequency;
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

	print("remove self joint");

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
	
	LHNodeProtocol.initNodeProtocolWithDictionary(dict, object);
	LHJointsProtocol.initJointsProtocolWithDictionary(dict, object, prnt:getScene());

    object.lhJointDampingRatio = dict["dampingRatio"];
    object.lhJointFrequency    = dict["frequency"];
	
	--add LevelHelper methods
    object.getDamping 		= getDamping;
    object.getFrequency 	= getFrequency;
    object.lateLoading 		= lateLoading;
    
    
    --method overloading
    object.nodeProtocolEnterFrame 	= object.enterFrame;
    object.enterFrame = visit;
    
    object._superRemoveSelf = object.removeSelf;
    object.removeSelf 		= removeSelf;
    
	return object
end
--------------------------------------------------------------------------------
return LHDistanceJointNode;

