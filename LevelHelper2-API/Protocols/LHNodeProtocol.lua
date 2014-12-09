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
local LHAsset	= require('LevelHelper2-API.Nodes.LHAsset');
local LHCamera	= require('LevelHelper2-API.Nodes.LHCamera');
local LHParallax	= require('LevelHelper2-API.Nodes.LHParallax');
local LHParallaxLayer	= require('LevelHelper2-API.Nodes.LHParallaxLayer');

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
	if(selfNode:getUniqueName() ~= nil and selfNode:getUniqueName() == name)then
		return selfNode;
	end
	
	for i = 1, selfNode:getNumberOfChildren() do
		local node = selfNode:getChildAtIndex(i);
		if node._isNodeProtocol == true then
			local uName = node:getUniqueName();

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
	if(selfNode:getUUID() ~= nil and selfNode:getUUID() == _uuid_)then
		return selfNode;
	end
	
	for i = 1, selfNode:getNumberOfChildren() do
		local node = selfNode:getChildAtIndex(i);
		if node._isNodeProtocol == true then
			local uid = node:getUUID();

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
		local node = selfNode:getChildAtIndex(i);
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
		local node = selfNode:getChildAtIndex(i);
		
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
	return selfNode._lhParent;
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
local function getChildAtIndex(selfNode, index)
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
--!@param value The new position value. A table like {x =100, y = 200}
local function setPosition(selfNode, value)
--!@docEnd	

	selfNode.x = value.x;
	selfNode.y = value.y;
	
	if(selfNode.lhChildren)then
		selfNode.lhChildren.x = value.x;
		selfNode.lhChildren.y = value.y;
	end
end
--------------------------------------------------------------------------------
--!@docBegin
--!Get the node position as a table {x = 100, y = 100}
local function getPosition(selfNode)
--!@docEnd	
	return {x = selfNode.x, y = selfNode.y}
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
		
		-- selfNode.lhChildren.anchorChildren = true;
		selfNode.lhChildren.anchorX = x;
		selfNode.lhChildren.anchorY = y;
	end
end
local function convertToWorldSpace(selfNode, position)
	local contentX, contentY = selfNode:localToContent(position.x, position.y);
	return {x = contentX, y = contentY};
end
local function convertToNodeSpace(selfNode, position)
	local localX, localY = selfNode:contentToLocal(position.x, position.y);
	return {x = localX, y = localY};
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
function initNodeProtocolWithDictionary(dict, node, prnt)

	node.setPosition 	= setPosition;
	node.getPosition	= getPosition;
	node.setRotation 	= setRotation;
	node.setScale 		= setScale;
	node.setAnchor 		= setAnchor;
	node.enterFrame 	= enterFrame;
	--Modern object hierarchy simulation
	node.addChild 				= addChild;
	node.removeChild 			= removeChild;
	node.getChildren 			= getChildren;
	node.getNumberOfChildren 	= getNumberOfChildren;
	node.getChildAtIndex 	= getChildAtIndex;


	node.protocolName = "LHNodeProtocol";
	node._isNodeProtocol = true;
    node._lhParent = prnt;
    
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
	
	node.convertToWorldSpace = convertToWorldSpace;
	node.convertToNodeSpace = convertToNodeSpace;
	
	--Load node protocol properties
	----------------------------------------------------------------------------
	node.lhUniqueName = dict["name"];
    node.lhUuid = dict["uuid"];
    node.lhTags = LHUtils.LHDeepCopy(dict["tags"]);

	node.lhUserProperties = LHUserProperties.customClassInstanceWithNode(	node, 
																			dict["userPropertyName"], 
																			dict["userPropertyInfo"]);
	
	local value = dict["rotation"];
	if(value)then
		node:setRotation(value)
	end

	node.lhContentSize = {width = 0, height = 0};

	value = dict["size"];
	if(value~= nil)then
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

	value = dict["anchor"];
	if(value)then
		local anchor = LHUtils.pointFromString(value);
		node:setAnchor(anchor.x, anchor.y);
	end
	
	value = dict["generalPosition"]
	if value then
		local unitPosition = LHUtils.pointFromString(value);	
		local calculatedPos= LHUtils.positionForNodeFromUnit(node, unitPosition);

		
		-- print(x);
		-- print(y);
		
		-- print("TEST THIS-------------------");
		-- print(node);
		-- print(node:getParent():getUniqueName());
		-- print(node:getParent():getType());
			
		-- local parent = node:getParent();
		
		-- if(parent)then
			-- print("WE HAVE PARENT-------------");
			-- print(parent:getUniqueName());
			
			if(	node:getParent()~= nil and 
				(node:getParent():getType() ~= "LHScene") and
				(node:getParent():getType() ~= "LHGameWorldNode") and
				(node:getParent():getType() ~= "LHUINode") and
				(node:getParent():getType() ~= "LHBackUINode") )then
			
				-- print("IS CHILD----------------------------------------------");
				-- print(node:getUniqueName());
				-- print(node:getParent():getUniqueName());
				-- print(node:getParent():getType());
				-- print(node:getParent():getUniqueName());
				
				local parent = node:getParent();
				
				local prntAncX = parent.anchorX;
				local prntAncY = parent.anchorY;
				
				local x = (parent.lhContentSize.width)*(prntAncX - 0.5);
				local y = (parent.lhContentSize.height)*(prntAncY - 0.5);
			
				-- print(x);
				-- print(y);
				
				calculatedPos.x = calculatedPos.x - x;
				calculatedPos.y = calculatedPos.y - y;
			end
		-- end
		
		node:setPosition({x = calculatedPos.x, y = calculatedPos.y});
		
		-- print("position for sprite " .. node:getUniqueName());
		-- print(calculatedPos.x);
		-- print(calculatedPos.y);
		
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
		return LHGameWorldNode:nodeWithDictionary(childInfo, prnt);
	end
	
	if nodeType == "LHBackUINode" then
		return LHBackUINode:nodeWithDictionary(childInfo, prnt);
	end
	
	if nodeType == "LHUINode" then
		return LHUINode:nodeWithDictionary(childInfo, prnt);
	end 
	
	if nodeType == "LHSprite" then    
		return LHSprite:nodeWithDictionary(childInfo, prnt);
	end
	
	if nodeType == "LHBezier" then    
		return LHBezier:nodeWithDictionary(childInfo, prnt);
	end
	
	if nodeType == "LHNode" then    
		return LHNode:nodeWithDictionary(childInfo, prnt);
	end
	
	if nodeType == "LHTexturedShape" then    
		return LHShape:nodeWithDictionary(childInfo, prnt);
	end
	
	if nodeType == "LHDistanceJoint" then    
		return LHDistanceJoint:nodeWithDictionary(childInfo, prnt);
	end
	
	if nodeType == "LHRevoluteJoint" then    
		return LHRevoluteJoint:nodeWithDictionary(childInfo, prnt);
	end
	
	if nodeType == "LHWeldJoint" then    
		return LHWeldJoint:nodeWithDictionary(childInfo, prnt);
	end
	
	if nodeType == "LHPrismaticJoint" then
		return LHPrismaticJoint:nodeWithDictionary(childInfo, prnt);
	end
	
	if nodeType == "LHPulleyJoint" then
		return LHPulleyJoint:nodeWithDictionary(childInfo, prnt);
	end
	
	if nodeType == "LHWheelJoint" then
		return LHWheelJoint:nodeWithDictionary(childInfo, prnt);
	end
	
	if nodeType == "LHGearJoint" then
		return LHGearJoint:nodeWithDictionary(childInfo, prnt);
	end
	
	if nodeType == "LHRopeJoint" then
		return LHRopeJoint:nodeWithDictionary(childInfo, prnt);
	end
	
	if nodeType == "LHAsset" then
		return LHAsset:nodeWithDictionary(childInfo, prnt);
	end
	
	if nodeType == "LHCamera" then
		return LHCamera:nodeWithDictionary(childInfo, prnt);
	end
	
	if nodeType == "LHParallaxLayer" then
		return LHParallaxLayer:nodeWithDictionary(childInfo, prnt);
	end
	
	if nodeType == "LHParallax" then
		return LHParallax:nodeWithDictionary(childInfo, prnt);
	end
	
	print("UNKNOWN NODE TYPE " .. nodeType);
	
	return nil
end
