--------------------------------------------------------------------------------
--
-- LHBone.lua
--
--!@docBegin
--!LHBone class is used to load a skeletal structure.
--!
--!@docEnd
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
require("LevelHelper2-API.Nodes.LHBoneConnection")

local function visit(selfNode, event)

	selfNode:animationProtocolEnterFrame(event);
	selfNode:nodeProtocolEnterFrame(event);
	
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--!@docBegin
--!Find if bone is the root bone or not.
local function isRoot(selfNode)
--!@docEnd
	local prnt = selfNode:getParent();
	if(prnt and prnt.nodeType == "LHBone")then
		return false;
	end
	if(prnt == false)then
		return false;
	end

	return true;
end
--------------------------------------------------------------------------------
--!@docBegin
--!Get the root bone. Will return self if bone is already the root or the root bone if bone is in hierarchy.
local function getRootBone(selfNode)
--!@docEnd

	if(selfNode:isRoot() == true)then
		return selfNode;
	end
	
	local prnt = selfNode:getParent();
	if(prnt ~= nil)then
		if prnt.nodeType == "LHBone" then
			return prnt:getRootBone();
		end
	end
	return nil;
end
--------------------------------------------------------------------------------
--!@docBegin
--!Get the root bone "Nodes" object. This is where sprites are kept. Search this node for sprites of certain name or type.
--!Sprites inside root bone "Nodes" do not have unique names inside scene hierarchy. They have unique names only inside "Nodes".
--!So if two skeletal structures are inside the scene. You must first find the root bone you deside. 
--!Then use this method to get the "Nodes" and search for the child sprite you need.
local function getRootBoneNodes(selfNode)
--!@docEnd
	local rBone = selfNode:getRootBone();
	
	if(rBone ~= nil)then
    
		local sprStruct = rBone:getChildrenOfType("LHBoneNodes");
		
	    if(nil ~= sprStruct and #sprStruct > 0)then
            return sprStruct[1];
        end
    end
    return nil;
end
--------------------------------------------------------------------------------
--!@docBegin
--!Get the bone max angle.
local function getMaxAngle(selfNode)
--!@docEnd
	return selfNode._maxAngle;	
end
--------------------------------------------------------------------------------
--!@docBegin
--!Get the bone min angle.
local function getMinAngle(selfNode)
--!@docEnd
	return selfNode._minAngle;	
end
--------------------------------------------------------------------------------
--!@docBegin
--!Get the bone rigid state.
local function getRigid(selfNode)
--!@docEnd
	return selfNode._rigid;	
end
--------------------------------------------------------------------------------
--!@docBegin
--!Get the bone connections.
local function getConnections(selfNode)
--!@docEnd
	return selfNode._connections;	
end
--------------------------------------------------------------------------------	
	
-- -(LHBone*)boneInHierarchyConnectedToNode:(LHNode*)node
-- {
--     if(!node)return nil;
    
--     for(LHBoneConnection* con in connections){
--         if([con connectedNode] == node){
--             return self;
--         }
--     }
    
--     for(LHBone* b in children){
--         if([b isBone]){
--             LHBone* bone = [b boneInHierarchyConnectedToNode:node];
--             if(bone){
--                 return bone;
--             }
--         }
--     }
--     return nil;
-- }

-- -(BOOL)containsConnectionWithNode:(LHNode*)node searchChildren:(BOOL)search
-- {
--     for(LHBoneConnection* con in connections){
--         if([con connectedNode] == node)
--         {
--             return YES;
--         }
--     }
    
--     if(search){
        
--         for(LHBone* b in children){
--             if([b isBone])
--             {
--                 BOOL val = [b containsConnectionWithNode:node searchChildren:search];
--                 if(val){
--                     return YES;
--                 }
--             }
--         }
        
--     }
    
--     return NO;
-- }

local function transformConnectedSprites(selfNode)

    local curWorldAngle = selfNode:getParent():convertToWorldAngle(selfNode.rotation);
    
    local curWorldPos = selfNode:getParent():convertToWorldSpace(selfNode:getPosition());
    
    for i=1, #selfNode._connections do
    	
    	local con = selfNode._connections[i];
    	local sprite = con:getConnectedNode();
    	if(sprite ~= nil)then
    		
    		local unit = sprite:unitForGlobalPosition(curWorldPos);
    		
    		local newSpriteAngle = sprite:getParent():convertToNodeAngle(curWorldAngle) + con:getAngleDelta();
    		
    		local prevAnchor = sprite:getAnchor();
  			
			sprite:setAnchorByKeepingPosition(unit.x, unit.y);
			
    		sprite:setRotation(newSpriteAngle);
    		
    		sprite:setAnchorByKeepingPosition(prevAnchor.x, prevAnchor.y);
    		
    		-- print("bone");
    		
    		local posDif = con:getPositionDelta();

    		local deltaWorldPos = selfNode:convertToWorldSpace(posDif);
    		local newSpritePos = sprite:getParent():convertToNodeSpace(deltaWorldPos);
    		
    		sprite:setPosition(newSpritePos);
    	end
	end

 	for j=1, selfNode:getNumberOfChildren() do
		local b = selfNode:getChildAtIndex(j);
		if(b and b.nodeType == "LHBone")then
			b:transformConnectedSprites();
		end
	end
end
--------------------------------------------------------------------------------
--!@docBegin
--!Set the node position
--!@param value The new position value. A table like {x =100, y = 200}
local function setPosition(selfNode, value)
--!@docEnd	
	selfNode:nodeProtocolSetPosition(value);
	selfNode:transformConnectedSprites();
end
--------------------------------------------------------------------------------
--!@docBegin
--!Set the node rotation
--!@param angle The new rotation value
local function setRotation(selfNode, angle)
--!@docEnd	
	selfNode:nodeProtocolSetRotation(angle);
	selfNode:transformConnectedSprites();
end

local LHBone = {}
function LHBone:nodeWithDictionary(dict, prnt)

	if (nil == dict) then
		print("Invalid LHBone initialization!")
	end
				
	local LHUtils 				= require("LevelHelper2-API.Utilities.LHUtils");
	local LHNodeProtocol 		= require('LevelHelper2-API.Protocols.LHNodeProtocol')
	local LHAnimationsProtocol 	= require('LevelHelper2-API.Protocols.LHAnimationsProtocol');

	local object = display.newGroup();
	
	--add all LevelHelper 2 valid properties to the object
	object.nodeType = "LHBone"
	
	print("create bone");
	
	--add LevelHelper methods
	prnt:addChild(object);
	
	LHNodeProtocol.initNodeProtocolWithDictionary(dict, object, prnt);
	LHNodeProtocol.loadChildrenForNodeFromDictionary(object, dict);


	object._maxAngle = dict["maxAngle"];
	object._minAngle = dict["minAngle"];
	object._rigid = dict["rigid"];
	object._connections = {};
	
	local connectionsInfo = dict["connections"];
	if connectionsInfo then    	
		for i = 1, #connectionsInfo do    	
			local conInfo = connectionsInfo[i];
			
			local con = LHBoneConnection:createConnectionWithDictionary(conInfo, object);
			object._connections[#object._connections +1] = con;
		end
	end

	LHAnimationsProtocol.initAnimationsProtocolWithDictionary(dict, object, prnt:getScene());
	
	object.nodeProtocolEnterFrame 	= object.enterFrame;
	object.enterFrame = visit;
	
	object.nodeProtocolSetPosition 	= object.setPosition;
	object.setPosition = setPosition;
	
	object.nodeProtocolSetRotation 	= object.setRotation;
	object.setRotation = setRotation;
	
	
	--Functions
	----------------------------------------------------------------------------
	object.isRoot = isRoot;
	object.getRootBone = getRootBone;
	object.getRootBoneNodes = getRootBoneNodes;
	object.getMaxAngle = getMaxAngle;
	object.getMinAngle = getMinAngle;
	object.getRigid = getRigid;
	object.getConnections = getConnections;
	object.transformConnectedSprites = transformConnectedSprites;
	
	
	local line = display.newLine( object, 
								object.lhContentSize.width*0.5, 0,
								object.lhContentSize.width*0.5, -object.lhContentSize.height );
  	line:setStrokeColor(1, 0, 0);
                    
                    
	return object
end
--------------------------------------------------------------------------------
return LHBone;
