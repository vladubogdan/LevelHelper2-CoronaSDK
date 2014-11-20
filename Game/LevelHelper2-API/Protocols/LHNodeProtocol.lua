-----------------------------------------------------------------------------------------
--
-- LHNodeProtocol.lua
--
-----------------------------------------------------------------------------------------
module (..., package.seeall)

local LHGameWorldNode = require('LevelHelper2-API.Nodes.LHGameWorldNode');
local LHUINode = require('LevelHelper2-API.Nodes.LHUINode');
local LHBackUINode = require('LevelHelper2-API.Nodes.LHBackUINode');
local LHSprite = require('LevelHelper2-API.Nodes.LHSprite');
local LHBezier = require('LevelHelper2-API.Nodes.LHBezier');
local LHNode = require('LevelHelper2-API.Nodes.LHNode');
local LHShape = require('LevelHelper2-API.Nodes.LHShape');
local LHDistanceJoint = require('LevelHelper2-API.Nodes.LHDistanceJointNode');
local LHRevoluteJoint = require('LevelHelper2-API.Nodes.LHRevoluteJointNode');
local LHWeldJoint = require('LevelHelper2-API.Nodes.LHWeldJointNode');
local LHPrismaticJoint = require('LevelHelper2-API.Nodes.LHPrismaticJointNode');
local LHPulleyJoint = require('LevelHelper2-API.Nodes.LHPulleyJointNode');
local LHWheelJoint	= require('LevelHelper2-API.Nodes.LHWheelJointNode');
local LHGearJoint	= require('LevelHelper2-API.Nodes.LHGearJointNode');
local LHRopeJoint	= require('LevelHelper2-API.Nodes.LHRopeJointNode');


local LHUtils = require("LevelHelper2-API.Utilities.LHUtils");
local LHUserProperties = require("LevelHelper2-API.Protocols.LHUserProperties");
--------------------------------------------------------------------------------
--!@docBegin
--!Loads json file and returns contents as a string.
--!@param filename The path to the json file.
--!@param base Optional parametter. Where it should look for the file. Default is system.ResourceDirectory.
function loadChildrenForNodeFromDictionary( prntNode, dict )
--!@docEnd

	local childrenInfo = dict["children"];
	if childrenInfo then    	
		for i = 1, #childrenInfo do    	
			local childInfo = childrenInfo[i];    			
			local node = createLHNodeWithDictionaryWithParent(childInfo, prntNode);	    	
		end
	end

end
--------------------------------------------------------------------------------
--!@docBegin
--!Get the node with the unique name inside the current node.
--!@param name The node unique name to look for inside the children of the current node.
local function getChildNodeWithUniqueName(selfNode, name)
--!@docEnd	

	for i = 1, selfNode:getNumberOfChildren() do
		local node = selfNode:getChildrenAtIndex(i);
		if node._isNodeProtocol == true then
			local uName = node.lhUniqueName

			if(uName ~= nil)then
				if(uName == name)then
					return node;
				end
			end

			local childNode = node:getChildNodeWithUniqueName(name);
			if childNode ~= nil then
				return childNode;
			end
		end
	end
	return nil;
end
--------------------------------------------------------------------------------
--!@docBegin
--!Get the node with the unique identifier inside the current node.
--!@param _uuid_ The node unique identifier to look for inside the children of the current node.
local function getChildNodeWithUUID(selfNode, _uuid_)
--!@docEnd	

	for i = 1, selfNode:getNumberOfChildren() do
		local node = selfNode:getChildrenAtIndex(i);
		if node._isNodeProtocol == true then
			local uid = node.lhUuid

			if(uid ~= nil)then
				if(uid == _uuid_)then
					return node;
				end
			end

			local childNode = node:getChildNodeWithUUID(_uuid_);
			if childNode ~= nil then
				return childNode;
			end
		end
	end
	return nil;
end
--------------------------------------------------------------------------------
--!@docBegin
--!Returns all children nodes that are of specified class type. A table with objects.
--!@param objType A class type. A string value with the name of the type e.g "LHSprite", "LHNode"
local function getChildrenOfType(selfNode, objType)
--!@docEnd	
	local temp = {};
	
	for i = 1, selfNode:getNumberOfChildren() do
		local node = selfNode:getChildrenAtIndex(i);
		if node._isNodeProtocol == true then
			if(node:getType() == objType)then
				temp[#temp+1] = node;
			end
			
			local childArray = node:getChildrenOfType(objType);
			if(childArray)then
				for j=1, #childArray do
					temp[#temp+1] = childArray[j];
				end
			end
		end
	end
	return temp;
end
--------------------------------------------------------------------------------
--!@docBegin
--!Returns all children nodes that are of specified class type. A table with objects.
--!@param protocolType A protocol class type. A string value with the name of one of the available protocols "LHNodeProtocol", "LHAnimationsProtocol", "LHJointsProtocol", "LHPhysicsProtocol"
local function getChildrenOfProtocol(selfNode, protocolType)
--!@docEnd	
	local temp = {};
	
	for i = 1, selfNode:getNumberOfChildren() do
		local node = selfNode:getChildrenAtIndex(i);
		
		if node._isNodeProtocol == true then
			if(node:getProtocolName() == protocolType)then
				temp[#temp+1] = node;
			end
			
			local childArray = node:getChildrenOfProtocol(protocolType);
			if(childArray)then
				for j=1, #childArray do
					temp[#temp+1] = childArray[j];
				end
			end
		end
	end
	return temp;
end



--------------------------------------------------------------------------------
--!@docBegin
--!Get the node LHScene object
local function getScene(selfNode)
--!@docEnd	
	if(selfNode.nodeType == "LHScene")then
		return selfNode;
	end

	local prnt = selfNode.parent;
	if(prnt ~= nil)then
		if prnt._isNodeProtocol == true then
			return prnt:getScene();
		end
	end
	return nil;
end
--------------------------------------------------------------------------------
--!@docBegin
--!Get the node parent object
local function getParent(selfNode)
--!@docEnd	
	return selfNode.parent;
end

function simulateModernObjectHierarchy(parent, child)
	child.lhChildren = display.newGroup();
	if(parent.lhChildren ~= nil)then
		parent.lhChildren:insert( child.lhChildren);
	else
		parent:insert( child.lhChildren);
	end
end
--------------------------------------------------------------------------------
--!@docBegin
--!Get the node unique identifier. A string value.
local function getUUID(selfNode)
--!@docEnd	
	return selfNode.lhUuid;
end
--------------------------------------------------------------------------------
--!@docBegin
--!Get the node type. A string value. e.g "LHSprite", "LHNode", "LHBezier" ...
local function getType(selfNode)
--!@docEnd	
	return selfNode.nodeType;
end
--------------------------------------------------------------------------------
--!@docBegin
--!Get the node protocol type. A string value. e.g "LHNodeProtocol", "LHAnimationsProtocol", "LHJointsProtocol", "LHPhysicsProtocol"
local function getProtocolName(selfNode)
--!@docEnd	
	return selfNode.protocolName;
end
--------------------------------------------------------------------------------
--!@docBegin
--!Get the node unique name. A string value.
local function getUniqueName(selfNode)
--!@docEnd	
	return selfNode.lhUniqueName;
end
--------------------------------------------------------------------------------
--!@docBegin
--!Add a child node.
--!@param child The node that will be added as child.
local function addChild(selfNode, child)
--!@docEnd	
	if(selfNode.lhChildren)then
		selfNode.lhChildren:insert(child);
	else
		selfNode:insert(child);
	end
end
--------------------------------------------------------------------------------
--!@docBegin
--!Removes a child node
local function removeChild(selfNode, child)
--!@docEnd	
	if(selfNode.lhChildren)then
		return selfNode.lhChildren:remove(child);
	end
	return selfNode:remove(child);
end
--------------------------------------------------------------------------------
--!@docBegin
--!Returns the display group of this node (Retuns the children).
--!Because corona does not have a modern children hierachy this is simulated using display groups.
--!Each node its either a display group directly or has a display group added at a 0,0 position of the node.
--!Via enterFrame notification children get updated with correct transformation.
--!Maybe in the future Corona SDK will support a modern gaming objects hierarchy.
local function getChildren(selfNode)
--!@docEnd	
	if(selfNode.lhChildren ~= nil)then
		return selfNode.lhChildren;
	end
	return selfNode;
end
--------------------------------------------------------------------------------
--!@docBegin
--!Returns the number of children this node has. A number value
local function getNumberOfChildren(selfNode)
--!@docEnd	
	local children = selfNode:getChildren();
	if children.numChildren then
		return children.numChildren;
	end
	return 0;
end
--------------------------------------------------------------------------------
--!@docBegin
--!Returns the children at a specific index
--!@param index The index of the child to be returned
local function getChildrenAtIndex(selfNode, index)
--!@docEnd	
	local children = selfNode:getChildren();
	if index >= 1 and index <= children.numChildren then
		return children[index];
	end
	return nil;
end
--------------------------------------------------------------------------------
--!@docBegin
--!Set the node position
--!@param valueX The new x position value
--!@param valueY The new y position value
local function setPosition(selfNode, valueX, valueY)
--!@docEnd	

	selfNode.x = valueX;
	selfNode.y = valueY;
	if(selfNode.lhChildren)then
		selfNode.lhChildren.x = valueX;
		selfNode.lhChildren.y = valueY;
	end
end
--------------------------------------------------------------------------------
--!@docBegin
--!Set the node rotation
--!@param angle The new rotation value
local function setRotation(selfNode, angle)
--!@docEnd	
	selfNode.rotation = angle;
	if(selfNode.lhChildren)then
		selfNode.lhChildren.rotation = angle;
	end
end
--------------------------------------------------------------------------------
--!@docBegin
--!Set the node x and y scales values
--!@param xScale The new x scale value
--!@param yScale The new y scale value
local function setScale(selfNode, xScale, yScale)
--!@docEnd	
	selfNode.xScale = xScale;
	selfNode.yScale = yScale;
	
	if(selfNode.lhChildren)then
		selfNode.lhChildren.xScale = xScale;
		selfNode.lhChildren.yScale = yScale;
	end
end
--------------------------------------------------------------------------------
--!@docBegin
--!Set the node x and y anchor values
--!@param x The new x anchor value
--!@param y The new y anchor value
local function setAnchor(selfNode, x, y)
--!@docEnd	
	selfNode.anchorX = x;
	selfNode.anchorY = y;
	
	if(selfNode.lhChildren)then
		selfNode.lhChildren.anchorX = x;
		selfNode.lhChildren.anchorY = y;
	end
end

local function enterFrame(selfNode, event)

	if(selfNode._isNodeProtocol)then
		
		if(selfNode.lhChildren ~= nil)then
			
			selfNode.lhChildren.x = selfNode.x;
			selfNode.lhChildren.y = selfNode.y;
			
			selfNode.lhChildren.rotation = selfNode.rotation;
			
			selfNode.lhChildren.xScale = selfNode.xScale;
			selfNode.lhChildren.yScale = selfNode.yScale;
		end
		-- if(selfNode.lhUniqueName)then
			-- print("enter frame " .. tostring(selfNode.lhUniqueName));
		-- end
	end
	
	local children = selfNode:getChildren();
	if(children)then
		for i = 1, children.numChildren do
			local child = children[i];
			if(child and child._isNodeProtocol ~= nil)then
				child:enterFrame(event);
			end
		end
	end
end
--------------------------------------------------------------------------------
-- function batch_allSprites(selfBatch)--returns array with LHSprite objects

-- 	--we only have to put the sprites from self to a table
-- 	local spritesTable = {}
-- 	for i = 1, selfBatch.numChildren do
-- 		spritesTable[#spritesTable+1] = selfBatch[i];
-- 	end

-- 	return spritesTable
-- end
-- --------------------------------------------------------------------------------
-- function batch_spritesWithTag(selfBatch, tag) --returns array with LHSprite objects with tag
-- 	local spritesTable = {}
-- 	for i = 1, selfBatch.numChildren do
-- 		local spr = selfBatch[i];
		
-- 		if(spr.lhTag and spr.lhTag == tag)then
-- 			spritesTable[#spritesTable+1] = spr;
-- 		end
-- 	end

-- 	return spritesTable
-- end
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
function initNodeProtocolWithDictionary(dict, node)

	node.setPosition 	= setPosition;
	node.setRotation 	= setRotation;
	node.setScale 		= setScale;
	node.setAnchor 		= setAnchor;
	node.enterFrame 	= enterFrame;
	--Modern object hierarchy simulation
	node.addChild 				= addChild;
	node.removeChild 			= removeChild;
	node.getChildren 			= getChildren;
	node.getNumberOfChildren 	= getNumberOfChildren;
	node.getChildrenAtIndex 	= getChildrenAtIndex;


	node.protocolName = "LHNodeProtocol";
	
    local value = dict["generalPosition"]
    if value then
        local unitPosition = LHUtils.pointFromString(value);
        local calculatedPos= LHUtils.positionForNodeFromUnit(node, unitPosition);

		node:setPosition(calculatedPos.x, calculatedPos.y);
		
        -- CGPoint unitPos = [dict pointForKey:@"generalPosition"];
        --     CGPoint pos = [LHUtils positionForNode:_node
        --                                   fromUnit:unitPos];
            
        --     NSDictionary* devPositions = [dict objectForKey:@"devicePositions"];
        --     if(devPositions)
        --     {
                
        --         NSString* unitPosStr = [LHUtils devicePosition:devPositions
        --                                               forSize:LH_SCREEN_RESOLUTION];
                
        --         if(unitPosStr){
        --             CGPoint unitPos = LHPointFromString(unitPosStr);
        --             pos = [LHUtils positionForNode:_node
        --                                   fromUnit:unitPos];
        --         }
        -- }
        
    end
    
    
    node._isNodeProtocol = true;
    
    --LevelHelper 2 node protocol functions
	----------------------------------------------------------------------------
	node.getChildNodeWithUniqueName = getChildNodeWithUniqueName;
	node.getChildNodeWithUUID 		= getChildNodeWithUUID;
	node.getChildrenOfType			= getChildrenOfType;
	node.getChildrenOfProtocol		= getChildrenOfProtocol;
	node.getScene 					= getScene;
	node.getParent					= getParent;
	node.getUUID					= getUUID;
	node.getUniqueName				= getUniqueName;
	node.getType 					= getType;
	node.getProtocolName			= getProtocolName;
	
	--Load node protocol properties
	----------------------------------------------------------------------------
	node.lhUniqueName = dict["name"];
    node.lhUuid = dict["uuid"];
    node.lhTags = LHUtils.LHDeepCopy(dict["tags"]);

	node.lhUserProperties = LHUserProperties.customClassInstanceWithNode(	node, 
																			dict["userPropertyName"], 
																			dict["userPropertyInfo"]);
	
	value = dict["rotation"];
    if(value)then
    	node:setRotation(value)
    end
        
        
    value = dict["size"];
    if(value)then
    	local sz = LHUtils.sizeFromString(value);
    	
    	node.width = sz.width;
    	node.height= sz.height;
    	
    	--some corona nodes have width/height properties as read only - we still need the size
    	node.lhContentSize = {width = sz.width, height = sz.height};
    end
    
    value = dict["alpha"];
    if(value)then
        node.alpha = value/255.0;
    end

    
    node.lhZOrder = dict["zOrder"];
    
	value = dict["scale"];
	if(value)then
		local scl = LHUtils.pointFromString(value);
		node:setScale(scl.x, scl.y);
	end


    -- if([dict objectForKey:@"anchor"] &&
    --       ![_node isKindOfClass:[LHUINode class]] &&
    --       ![_node isKindOfClass:[LHBackUINode class]] &&
    --       ![_node isKindOfClass:[LHGameWorldNode class]])
    --     {
    
	value = dict["anchor"];
	if(value)then
		local anchor = LHUtils.pointFromString(value);
		node:setAnchor(anchor.x, anchor.y);
	end

	-- CGPoint anchor = [dict pointForKey:@"anchor"];
	--         anchor.y = 1.0f - anchor.y;
	--         [_node setAnchorPoint:anchor];
	--     }


end
--------------------------------------------------------------------------------
function createLHNodeWithDictionaryWithParent(childInfo, prnt)

    local nodeType = childInfo["nodeType"];
    
    -- local scene = nil;
--    if([prnt isKindOfClass:[LHScene class]]){
--        scene = (LHScene*)prnt;
--    }
--    else if([[prnt scene] isKindOfClass:[LHScene class]]){
--        scene = (LHScene*)[prnt scene];
--    }
    
    if nodeType =="LHGameWorldNode" then
	    local pNode = LHGameWorldNode:nodeWithDictionary(childInfo, prnt);
        return pNode;
    end
    
    if nodeType == "LHBackUINode" then
	    local pNode = LHBackUINode:nodeWithDictionary(childInfo, prnt);
        return pNode;
    end
    
    
    if nodeType == "LHUINode" then
		local pNode = LHUINode:nodeWithDictionary(childInfo, prnt);
		return pNode;
	end 
	
	if nodeType == "LHSprite" then    
    	local pNode = LHSprite:nodeWithDictionary(childInfo, prnt);
    	return pNode;
    end
    
    if nodeType == "LHBezier" then    
    	local pNode = LHBezier:nodeWithDictionary(childInfo, prnt);
    	return pNode;
    end
    
	if nodeType == "LHNode" then    
    	local pNode = LHNode:nodeWithDictionary(childInfo, prnt);
    	return pNode;
    end
    
    if nodeType == "LHTexturedShape" then    
    	local pNode = LHShape:nodeWithDictionary(childInfo, prnt);
    	return pNode;
    end
    
    if nodeType == "LHDistanceJoint" then    
    	local pNode = LHDistanceJoint:nodeWithDictionary(childInfo, prnt);
    	return pNode;
    end
    
    if nodeType == "LHRevoluteJoint" then    
    	local pNode = LHRevoluteJoint:nodeWithDictionary(childInfo, prnt);
    	return pNode;
    end
    
    if nodeType == "LHWeldJoint" then    
    	local pNode = LHWeldJoint:nodeWithDictionary(childInfo, prnt);
    	return pNode;
    end
    
    if nodeType == "LHPrismaticJoint" then
    	local pNode = LHPrismaticJoint:nodeWithDictionary(childInfo, prnt);
    	return pNode;
    end
    
    if nodeType == "LHPulleyJoint" then
    	local pNode = LHPulleyJoint:nodeWithDictionary(childInfo, prnt);
    	return pNode;
    end
    
    if nodeType == "LHWheelJoint" then
    	local pNode = LHWheelJoint:nodeWithDictionary(childInfo, prnt);
    	return pNode;
    end
    
    if nodeType == "LHGearJoint" then
    	local pNode = LHGearJoint:nodeWithDictionary(childInfo, prnt);
    	return pNode;
    end
    
    if nodeType == "LHRopeJoint" then
    	local pNode = LHRopeJoint:nodeWithDictionary(childInfo, prnt);
    	return pNode;
    end
    
    print("UNKNOWN NODE TYPE " .. nodeType);
    
    return nil
end
