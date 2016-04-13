--------------------------------------------------------------------------------
--
-- LHRopeJointNode.lua
--
--!@docBegin
--!LHRopeJointNode class is used to load a LevelHelper rope joint.
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
--!Get the rope joint length. A number value.
local function getMaxLength(selfNode)
--!@docEnd	
	if(selfNode.lhCoronaJoint ~= nil)then
 		return selfNode.lhCoronaJoint.maxLength;
 	end
	return selfNode.lhJointLength;
end
--------------------------------------------------------------------------------
--!@docBegin
--!Set the rope joint max length.
--!@param value A number value.
local function setMaxLength(selfNode, value)
--!@docEnd	
	if(selfNode.lhCoronaJoint ~= nil)then
 		selfNode.lhCoronaJoint.maxLength = value;
 	end
end
--------------------------------------------------------------------------------
--!@docBegin
--!Get the rope joint limit state. A string value. "inactive", "lower", "upper", or "equal".
local function getLimitState(selfNode)
--!@docEnd	
	if(selfNode.lhCoronaJoint ~= nil)then
 		return selfNode.lhCoronaJoint.limitState;
 	end
	return nil;
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local function lateLoading(selfNode)
	
	selfNode:findConnectedNodes();
	
    local nodeA = selfNode:getConnectedNodeA();
	local nodeB = selfNode:getConnectedNodeB();
    
    local anchorA = selfNode:getLocalAnchorA();
    local anchorB = selfNode:getLocalAnchorB();
    
    if(nodeA and nodeB)then
    
    	local physics = require("physics")
		if(nil == physics)then	return end
		physics.start();


    	local coronaJoint = physics.newJoint(	"rope", 
                                             	nodeA,
                                              	nodeB,
	                                            anchorA.x,
                                                anchorA.y,
                                                anchorB.x,
                                                anchorB.y)
                                                
        coronaJoint.maxLength 	= selfNode:getMaxLength();
        
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
local LHRopeJointNode = {}
function LHRopeJointNode:nodeWithDictionary(dict, prnt)

	if (nil == dict) then
		print("Invalid LHRopeJointNode initialization!")
	end
				
	local LHUtils = require("LevelHelper2-API.Utilities.LHUtils");
    local LHNodeProtocol = require('LevelHelper2-API.Protocols.LHNodeProtocol');
    local LHJointsProtocol = require('LevelHelper2-API.Protocols.LHJointsProtocol');
    
    
    local object = display.newGroup();
    
    --add all LevelHelper 2 valid properties to the object
	object.nodeType = "LHRopeJointNode"
	
    prnt:addChild(object);
	
    local actualRemoveSelf = object.removeSelf;
        
	LHNodeProtocol.initNodeProtocolWithDictionary(dict, object, prnt);
	LHJointsProtocol.initJointsProtocolWithDictionary(dict, object, prnt:getScene());


	object.lhJointThickness 	= dict["thickness"];
	object.lhJointSegments 		= dict["segments"];
	object.lhJointCanBeCut 		= dict["canBeCut"];
	object.lhJointFadeOutDelay 	= dict["fadeOutDelay"];
	object.lhJointRemoveAfterCut= dict["removeAfterCut"];
	object.lhJointLength		= dict["length"];

	local uvRep = LHUtils.pointFromString(dict["uvRepetitions"]);
	object.lhJointURepetitions 	= uvRep.x;
	object.lhJointVRepetitions 	= uvRep.y;
	
	object.lhJointColorInfo 	= LHUtils.colorFromString(dict["colorOverlay"]);
	object.lhJointAlpha 		= dict["alpha"];
	

--         if([dict boolForKey:@"shouldDraw"])
--         {
--             LHDrawNode* shape = [LHDrawNode node];
--             [self addChild:shape];
--             ropeShape = shape;
            
--             NSString* imgRelPath = [dict objectForKey:@"relativeImagePath"];
--             if(imgRelPath && [dict boolForKey:@"useTexture"]){
--                 LHScene* scene = (LHScene*)[prnt scene];
                
--                 NSString* filename = [imgRelPath lastPathComponent];
--                 NSString* foldername = [[imgRelPath stringByDeletingLastPathComponent] lastPathComponent];
                
--                 NSString* imagePath = [LHUtils imagePathWithFilename:filename
--                                                               folder:foldername
--                                                               suffix:[scene currentDeviceSuffix:NO]];
                
--                 CCTexture* texture = [scene textureWithImagePath:imagePath];
                
--                 ropeShape.texture = texture;
--                 ccTexParams texParams = { GL_NEAREST, GL_NEAREST, GL_REPEAT, GL_REPEAT };
--                 [texture setTexParameters: &texParams];
--             }
--         }

	--add LevelHelper methods
	object.lateLoading 		= lateLoading;
    
	--add LevelHelper joint info methods
    object.getMaxLength 	= getMaxLength;
    object.setMaxLength 	= setMaxLength;
    object.getLimitState 	= getLimitState;
    
    --method overloading
    object.nodeProtocolEnterFrame 	= object.enterFrame;
    object.enterFrame = visit;
    
    object._superRemoveSelf = actualRemoveSelf;--object.removeSelf;
    object.removeSelf 		= removeSelf;   
    object.nodeProtocolRemoveSelf = nil; 
    
    
	return object
end
--------------------------------------------------------------------------------
return LHRopeJointNode;

