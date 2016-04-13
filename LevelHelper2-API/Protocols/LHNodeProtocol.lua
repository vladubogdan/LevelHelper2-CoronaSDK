-----------------------------------------------------------------------------------------
--
-- LHNodeProtocol.lua
--
--!@docBegin
--!Most of the LevelHelper 2 nodes conforms to this protocol.
--!
--!@docEnd
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
local LHBone	= require('LevelHelper2-API.Nodes.LHBone');
local LHBoneNodes= require('LevelHelper2-API.Nodes.LHBoneNodes');

require('LevelHelper2-API.Utilities.LHPathMovement');

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
--!Returns a table of strings representing the tags assigned on this node.
local function getTags(selfNode)
--!@docEnd
	return selfNode.lhTags;	
end
--------------------------------------------------------------------------------
--!@docBegin
--!Returns all children nodes that have the specified tag values.
--!@param tagsTable A table of strings containing tag names.
--!@param any Specify if all or just one tag value of the node needs to be in common with the tagsTable passed as argument to this function.
local function getChildrenWithTags(selfNode, tagsTable, any)
--!@docEnd	
	local temp = {};

	for i = 1, selfNode:getNumberOfChildren() do
		local child = selfNode:getChildAtIndex(i);
		
		if child._isNodeProtocol == true then
	
			local childTags = child:getTags();
	
			local foundCount = 0;
			local foundAtLeastOne = false;
			
			for t = 1, #childTags do
				
				local tg = childTags[t];
				
				for v = 1, #tagsTable do
					local st = tagsTable[v];
					
					if st == tg then
					
						foundCount = foundCount + 1;
						foundAtLeastOne = true;
						if any then
							break;
						end
					end
				end

				if(any and foundAtLeastOne)then
					temp[#temp+1] = child;
					break;
				end
			end

			if(false == any and foundAtLeastOne and foundCount == #tagsTable)then
				temp[#temp+1] = child;
			end
			
			local childArray = child:getChildrenWithTags(tagsTable, any);
			if(childArray)then
				for j =1, #childArray do
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
--!Returns the user property object assigned to this node or null.
local function getUserProperty(selfNode)
--!@docEnd
	return selfNode.lhUserProperties;
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
--------------------------------------------------------------------------------
--!@docBegin
--!Set the node x and y anchor by keeping the position of the node on screen in the same place.
--!@param x The new x anchor value
--!@param y The new y anchor value
local function setAnchorByKeepingPosition(selfNode, x, y)
--!@docEnd
	local prevAnchor = selfNode:getAnchor();
	local prevPos = selfNode:getPosition();  			
	prevPos = selfNode:getParent():convertToWorldSpace(prevPos);
  	
  	local newPos = {x = prevPos.x + (x - prevAnchor.x)*selfNode.lhContentSize.width,
  					y = prevPos.y + (y - prevAnchor.y)*selfNode.lhContentSize.height};
  				
  	selfNode.anchorX = x;
    selfNode.anchorY = y;
    
    newPos = selfNode:getParent():convertToNodeSpace(newPos);
  			
    selfNode.x = newPos.x;
	selfNode.y = newPos.y;
			
	if(selfNode.lhChildren)then
		-- selfNode.lhChildren.anchorChildren = true;
		selfNode.lhChildren.anchorX = x;
		selfNode.lhChildren.anchorY = y;
		
		selfNode.lhChildren.x = newPos.x;
		selfNode.lhChildren.y = newPos.y;
	end		
end

--------------------------------------------------------------------------------
--!@docBegin
--!Get the node anchor as a table {x = 0.5, y = 0.5}
local function getAnchor(selfNode)
--!@docEnd	
	return {x = selfNode.anchorX, y = selfNode.anchorY};
end


local function convertToWorldSpace(selfNode, position)
	local contentX, contentY = selfNode:localToContent(position.x, position.y);
	return {x = contentX, y = contentY};
end
local function convertToNodeSpace(selfNode, position)
	local localX, localY = selfNode:contentToLocal(position.x, position.y);
	return {x = localX, y = localY};
end

local function convertToWorldAngle(selfNode, localAngle)

    local rot = LHUtils.LHPointForAngle(localAngle);
    local worldPt = selfNode:convertToWorldSpace(rot);
   	local worldOriginPt = selfNode:convertToWorldSpace({x = 0, y = 0});
    local worldVec = LHUtils.LHPointSub(worldPt, worldOriginPt);
    local ang = LHUtils.LHPointToAngle(worldVec);
    return LHUtils.LHNormalAbsoluteAngleDegrees(ang);
    
end

local function convertToNodeAngle(selfNode, worldAngle)

    local rot = LHUtils.LHPointForAngle(worldAngle);
    local nodePt = selfNode:convertToNodeSpace(rot);
    local nodeOriginPt = selfNode:convertToNodeSpace({x = 0, y = 0});
    local nodeVec = LHUtils.LHPointSub(nodePt, nodeOriginPt);
    local ang = LHUtils.LHPointToAngle(nodeVec);
    return LHUtils.LHNormalAbsoluteAngleDegrees(ang);
end


local function unitForGlobalPosition(selfNode, globalpt)

    local localPt = selfNode:convertToNodeSpace(globalpt);
    local sizer = selfNode.lhContentSize;

	local centerPointX = sizer.width*0.5;
    local centerPointY = sizer.height*0.5;
    
    localPt.x = localPt.x + centerPointX;
    localPt.y = localPt.y + centerPointY;
		
	return  {x = localPt.x/sizer.width, y = localPt.y/sizer.height};
end

--pragma-mark - Path movement
--------------------------------------------------------------------------------
--!@docBegin
--!Prepare movement on a bezier object.
--!@param bezierObject The bezier object of which shape will be used to create the movement of the node. 
--!@code
--!		local bezierObject 			= lhScene:getChildNodeWithUniqueName("bezierNodeName");
--!		local objectToMoveOnPath	= lhScene:getChildNodeWithUniqueName("objectNodeName");
--!		objectToMoveOnPath:pathMovementPrepareOnBezier(bezierObject);
--!@endcode
--!Adding path movement has ended event listener
--!@code
--! 	--somewhere at the beginning of your scene file add the following method
--! 	function scene:LHPathMovementHasEndedPerObjectNotification(event)
--!			print("did end path movement on object " .. tostring(event.object) .. " name: " .. event.object:getUniqueName());	
--!		end
--!
--! 	--adding the event lister
--!  	objectToMoveOnPath:addEventListener( "LHPathMovementHasEndedPerObjectNotification", scene )
--!@endcode
local function pathMovementPrepareOnBezier(selfNode, bezierObject)
--!@docEnd	
	selfNode._pathMovementObj = LHPathMovement:initWithBezier(bezierObject, selfNode);
end
--------------------------------------------------------------------------------
--!@docBegin
--!Play or pause the path movement if it was previously prepared using pathMovementPrepareOnBezier method.
--!@param value A true or false value.
local function pathMovementSetPlaying(selfNode, value)
--!@docEnd
	if(nil ~= selfNode._pathMovementObj)then
		selfNode._pathMovementObj.playing = value;
	end
end
--------------------------------------------------------------------------------
--!@docBegin
--!Find if the path movement is currently playing or not.
--!@return A boolean value.
local function pathMovementGetPlaying(selfNode)
--!@docEnd
	if(nil ~= selfNode._pathMovementObj)then
		return selfNode._pathMovementObj.playing;
	end
	return false;
end
--------------------------------------------------------------------------------
--!@docBegin
--!Set the duration it should take for the object to travel from the beginning to the end of the path.
--!
--!If path movement is set as ping pong the time to travel begin -> end -> begin will be double.
--!@param value A number value. In seconds.
local function pathMovementSetDuration(selfNode, value)
--!@docEnd
	if(nil ~= selfNode._pathMovementObj)then
		selfNode._pathMovementObj.timeLength = value;
	end
end
--------------------------------------------------------------------------------
--!@docBegin
--!Put the object at the initial path movement starting point and resets repetitions count.
--!
--!Path movement play/pause state will not be changed.
local function pathMovementRestart(selfNode)
--!@docEnd
	if(nil ~= selfNode._pathMovementObj)then
		selfNode._pathMovementObj:restart();
	end
end
--------------------------------------------------------------------------------
--!@docBegin
--!Set the path movement direction.
--!
--!@param value A number value. A positiv value means the object will move on path from first to last point. A negative value means from last to first point.
local function pathMovementSetDirection(selfNode, value)
--!@docEnd
	if(nil ~= selfNode._pathMovementObj)then
		selfNode._pathMovementObj:setDirection(value);
	end
end
--------------------------------------------------------------------------------
--!@docBegin
--!Get the path movement direction.
--!@return A number value. A positiv value means object is moving on path from first to last point. A negative value means object is moving on path from last to first point.
local function pathMovementGetDirection(selfNode)
--!@docEnd
	if(nil ~= selfNode._pathMovementObj)then
		return selfNode._pathMovementObj.direction;
	end
	return 0;
end
--------------------------------------------------------------------------------
--!@docBegin
--!Set if the object moving on the path should rotate to have the same orientation as the path.
--!
--!The object orientation starts from the initial angle of the object when the path movement was prepared.
--!@param value A bolean value.
local function pathMovementSetUseOrientation(selfNode, value)
--!@docEnd
	if(nil ~= selfNode._pathMovementObj)then
		selfNode._pathMovementObj.useOrientation = value;
	end
end
--------------------------------------------------------------------------------
--!@docBegin
--!Get if the object moving on the path is rotating to match the path trajectory.
local function pathMovementGetUseOrientation(selfNode)
--!@docEnd
	if(nil ~= selfNode._pathMovementObj)then
		return selfNode._pathMovementObj.useOrientation;
	end
	return false;
end
--------------------------------------------------------------------------------
--!@docBegin
--!Set if the object xScale should be flipped when the path movement reaches an end point.
--!
--!This is useful for when orienting an object on the path and the movement changes direction.
--!@param value A bolean value.
local function pathMovementSetFlipScaleXAtEnd(selfNode, value)
--!@docEnd
	if(nil ~= selfNode._pathMovementObj)then
		selfNode._pathMovementObj.flipScaleXAtEnd = value;
	end
end
--------------------------------------------------------------------------------
--!@docBegin
--!Get if the object xScale is flipped when path movement reaches an end point.
local function pathMovementGetFlipScaleXAtEnd(selfNode)
--!@docEnd
	if(nil ~= selfNode._pathMovementObj)then
		return selfNode._pathMovementObj.flipScaleXAtEnd;
	end
	return false;
end
--------------------------------------------------------------------------------
--!@docBegin
--!Set if the object yScale should be flipped when the path movement reaches an end point.
--!
--!This is useful for when orienting an object on the path and the movement changes direction.
--!@param value A bolean value.
local function pathMovementSetFlipScaleYAtEnd(selfNode, value)
--!@docEnd
	if(nil ~= selfNode._pathMovementObj)then
		selfNode._pathMovementObj.flipScaleYAtEnd = value;
	end
end
--------------------------------------------------------------------------------
--!@docBegin
--!Get if the object yScale is flipped when path movement reaches an end point.
local function pathMovementGetFlipScaleYAtEnd(selfNode)
--!@docEnd
	if(nil ~= selfNode._pathMovementObj)then
		return selfNode._pathMovementObj.flipScaleYAtEnd;
	end
	return false;
end
--------------------------------------------------------------------------------
--!@docBegin
--!Set how many times the path should move until it pause itself.
--!
--!@param value A number value. A value of 0 means the path should loop until it is stopped manually using pathMovementSetPlaying(false);
local function pathMovementSetRepetitions(selfNode, value)
--!@docEnd
	if(nil ~= selfNode._pathMovementObj)then
		selfNode._pathMovementObj.repetitions = value;
	end
end
--------------------------------------------------------------------------------
--!@docBegin
--!Get the number of path movement repetitions.
--!@return A number value. A 0 value means the path is looping.
local function pathMovementGetRepetitions(selfNode)
--!@docEnd
	if(nil ~= selfNode._pathMovementObj)then
		return selfNode._pathMovementObj.repetitions;
	end
	return 0;
end
--------------------------------------------------------------------------------
--!@docBegin
--!Get how many times the movement was repeated on the path since started. This counter is reset only when calling pathMovementRestart().
--!@return A number value.
local function pathMovementGetCurrentRepetition(selfNode)
--!@docEnd
	if(nil ~= selfNode._pathMovementObj)then
		return selfNode._pathMovementObj.currentRepetition;
	end
	return 0;
end
--------------------------------------------------------------------------------
--!@docBegin
--!Set if the movement on the path should ping pong. E.g Move from beginning to end to beginning.
--!If you enable ping pong and use a specific number of path movement repetitions, you should double the repetitions number.
--!@param value A boolean value.
local function pathMovementSetIsPingPong(selfNode, value)
--!@docEnd
	if(nil ~= selfNode._pathMovementObj)then
		selfNode._pathMovementObj.pingPong = value;
	end
end
--------------------------------------------------------------------------------
--!@docBegin
--!Get if path movement is ping pong.
--!@return A boolean value.
local function pathMovementGetIsPingPong(selfNode)
--!@docEnd
	if(nil ~= selfNode._pathMovementObj)then
		return selfNode._pathMovementObj.pingPong;
	end
	return false;
end

--pragma-mark -
--------------------------------------------------------------------------------
local function enterFrame(selfNode, event)

	if(selfNode._shouldRemoveSelf)then
		selfNode:nodeProtocolRemoveSelf();
		return;
	end
	
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
	
	if(selfNode._pathMovementObj ~= nil)then
		selfNode._pathMovementObj:enterFrame(event);
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

local function scheduleForRemoval(selfNode)
	selfNode._shouldRemoveSelf = true;
end
local function nodeProtocolRemoveSelf(selfNode)
	
    -- local LHUtils = require("LevelHelper2-API.Utilities.LHUtils");    
    -- local nodeInfo = LHUtils.LHPrintObjectInfo(selfNode);    
    -- print("node info " .. tostring(nodeInfo));
    
	local children = selfNode:getChildren();
	while(children ~= nil and children.numChildren > 0)do
		local child = children[1];
		
		if(child)then
    		if(child.nodeProtocolRemoveSelf ~= nil)then
	            child:nodeProtocolRemoveSelf();                                               
			else
	            child:removeSelf();                
			end
		end
		children = selfNode:getChildren();
	end

	if(selfNode._pathMovementObj ~= nil)then
		selfNode._pathMovementObj:removeSelf();
	end
	selfNode._pathMovementObj = nil;
	    
    selfNode.nodeProtocolRemoveSelf = nil;    
	if(selfNode._superRemoveSelf ~= nil)then
		selfNode:_superRemoveSelf();
	end
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
function initNodeProtocolWithDictionary(dict, node, prnt)

	node.setPosition 	= setPosition;
	node.getPosition	= getPosition;
	node.setRotation 	= setRotation;
	node.setScale 		= setScale;
	node.setAnchor 		= setAnchor;
	node.setAnchorByKeepingPosition = setAnchorByKeepingPosition;
	node.getAnchor 		= getAnchor;
	node.enterFrame 	= enterFrame;
	
	if(node.removeSelf ~= nil)then
		node._superRemoveSelf = node.removeSelf;
	end
	-- node.removeSelf = nodeProtocolRemoveSelf;
	node.removeSelf = scheduleForRemoval;
	node.nodeProtocolRemoveSelf = nodeProtocolRemoveSelf;
	
	--Modern object hierarchy simulation
	node.addChild 				= addChild;
	node.removeChild 			= removeChild;
	node.getChildren 			= getChildren;
	node.getNumberOfChildren 	= getNumberOfChildren;
	node.getChildAtIndex 	= getChildAtIndex;


	node.protocolName = "LHNodeProtocol";
	node._dictionaryInfo = dict;
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
	node.getUserProperty			= getUserProperty;
	node.getType 					= getType;
	node.getProtocolName			= getProtocolName;
	
	node.getTags 					= getTags;
	node.getChildrenWithTags 		= getChildrenWithTags;

	node.convertToWorldSpace = convertToWorldSpace;
	node.convertToNodeSpace = convertToNodeSpace;
	node.convertToWorldAngle = convertToWorldAngle;
	node.convertToNodeAngle = convertToNodeAngle;
	node.unitForGlobalPosition = unitForGlobalPosition;
	
	node._pathMovementObj = nil;
	node.pathMovementPrepareOnBezier = pathMovementPrepareOnBezier;
	node.pathMovementSetPlaying = pathMovementSetPlaying;
	node.pathMovementGetPlaying = pathMovementGetPlaying;
	node.pathMovementSetDuration = pathMovementSetDuration;
	node.pathMovementRestart = pathMovementRestart;
	node.pathMovementSetDirection = pathMovementSetDirection;
	node.pathMovementGetDirection = pathMovementGetDirection;
	node.pathMovementSetRepetitions = pathMovementSetRepetitions;
	node.pathMovementGetRepetitions = pathMovementGetRepetitions;
	node.pathMovementGetCurrentRepetition = pathMovementGetCurrentRepetition;
	node.pathMovementSetIsPingPong = pathMovementSetIsPingPong;
	node.pathMovementGetIsPingPong = pathMovementGetIsPingPong;
	node.pathMovementSetUseOrientation = pathMovementSetUseOrientation;
	node.pathMovementGetUseOrientation = pathMovementGetUseOrientation;
	
	node.pathMovementSetFlipScaleXAtEnd = pathMovementSetFlipScaleXAtEnd;
	node.pathMovementGetFlipScaleXAtEnd = pathMovementGetFlipScaleXAtEnd;
	node.pathMovementSetFlipScaleYAtEnd = pathMovementSetFlipScaleYAtEnd;
	node.pathMovementGetFlipScaleYAtEnd = pathMovementGetFlipScaleYAtEnd;
	
	--Load node protocol properties
	----------------------------------------------------------------------------
	node.lhContentSize = {width = 0, height = 0};
	
	if(dict ~= nil)then
		
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
	
				if(	node:getParent()~= nil and 
					(node:getParent():getType() ~= "LHScene") and
					(node:getParent():getType() ~= "LHGameWorldNode") and
					(node:getParent():getType() ~= "LHUINode") and
					(node:getParent():getType() ~= "LHBackUINode") )then
				
	
					local parent = node:getParent();
					
					local prntAncX = parent.anchorX;
					local prntAncY = parent.anchorY;
					
					local x = (parent.lhContentSize.width)*(prntAncX - 0.5);
					local y = (parent.lhContentSize.height)*(prntAncY - 0.5);
				
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
	end --if dict

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
	
	if nodeType == "LHBone" then    
		return LHBone:nodeWithDictionary(childInfo, prnt);
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
	
	if nodeType == "LHBoneNodes" then
		return LHBoneNodes:nodeWithDictionary(childInfo, prnt);
	end
	
	
	print("UNKNOWN NODE TYPE " .. tostring(nodeType));
	
	return nil
end
