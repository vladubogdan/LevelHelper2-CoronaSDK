--------------------------------------------------------------------------------
--
-- LHCamera.lua
--
--!@docBegin
--!LHCamera class is used to load a camera object from a level file.
--!
--!Conforms to:
--!
--!LHNodeProtocol
--!
--!LHAnimationsProtocol
--!
--!@docEnd
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--!@docBegin
--!Returns wheter or not the camera is the active camera in the scene. A boolean value.
local function isActive( selfNode)
--!@docEnd
	return selfNode._active;
end
--------------------------------------------------------------------------------
--!@docBegin
--!Sets the camera active or inactive.
--!@param value A boolean value.
local function setActive( selfNode, value)
--!@docEnd
	local cameras = selfNode:getScene():getChildrenOfType("LHCamera");
	
	for i=1, #cameras do
		
		local cam = cameras[i];
		cam:resetActiveState();
	end

	selfNode._active = value;
	selfNode:setSceneView();
end
--------------------------------------------------------------------------------
--!@docBegin
--!Get the node that this camera follows. The node or nil.
local function getFollowedNode(selfNode)
--!@docEnd
	if(selfNode._followedNodeUUID ~= nil and selfNode._followedNode == nil)then
		selfNode._followedNode = selfNode:getScene():getChildNodeWithUUID(selfNode._followedNodeUUID);
		if(selfNode._followedNode)then
			selfNode._followedNodeUUID = nil;
		end
	end
	return selfNode._followedNode;
end
--------------------------------------------------------------------------------
--!@docBegin
--!Sets the node this camera should follow.
--!@param node A LevelHelper node object
local function setFollowedNode( selfNode, node)
--!@docEnd
	selfNode._followedNode = node;
end
--------------------------------------------------------------------------------
--!@docBegin
--!Get a boolean value static if this camera is restricted to the game world area.
local function getRestrictedToGameWorld(selfNode)
--!@docEnd
	return selfNode._restricted;
end
--------------------------------------------------------------------------------
--!@docBegin
--!Sets whether this camera should be restricted to the game world area.
--!@param value A boolean value
local function setRestrictedToGameWorld( selfNode, value)
--!@docEnd
	selfNode._restricted = value;
end
--------------------------------------------------------------------------------
--!@docBegin
--!Get the camera position. A table like {x = 100, y=200}
local function getPosition(selfNode)
--!@docEnd	
	return {x = selfNode.x, y = selfNode.y};
end
--------------------------------------------------------------------------------
--!@docBegin
--!Set the camera position. The center of the view if the camera is active.
--!@param position The new camera position. A table like {x = 100, y=200}
local function setPosition(selfNode, position)
--!@docEnd	
	if(selfNode._active)then
		local transPoint = selfNode:transformToRestrictivePosition(position);
		
		if(selfNode:getLockX())then
			transPoint.x = position.x;
		end
		
		if(selfNode:getLockY())then
			transPoint.y = position.y;
		end
		
		selfNode.x = transPoint.x;
		selfNode.y = transPoint.y;
	else 
		selfNode.x = position.x;
		selfNode.y = position.y;
	end
end
--------------------------------------------------------------------------------
--!@docBegin
--!Set the camera view offset unit. This value is added to the camera position as an offset.
--!@param unit The new camera offset unit. This value is multipled with the screen dimensions and added to the camera position. A table value {x = 0.4, y = 0.2}
local function setOffsetUnit(selfNode, unit)
--!@docEnd	
	selfNode.offset = unit;
end
--------------------------------------------------------------------------------
--!@docBegin
--!Returns the camera unit offset. A table like {x = 0.2, y=0.3}
local function getOffsetUnit(selfNode)
--!@docEnd	
	return selfNode.offset;
end
--------------------------------------------------------------------------------
--!@docBegin
--!Set the important camera view unit. This value is multipled with the screen dimensions. The area is based on the center.
--!Based on this area the camera position will be calculated based on the following node movement.
--!This value is ignored when camera is not following a node.
--!@param unit The new camera important area unit. This value is multipled with the screen dimensions. A table value {x = 0.4, y = 0.2}
local function setImportantAreaUnit(selfNode, unit)
--!@docEnd	
	selfNode.importantArea = unit;
end
--------------------------------------------------------------------------------
--!@docBegin
--!Returns the camera important area unit. A table like {x = 0.2, y=0.3}
local function getImportantAreaUnit(selfNode)
--!@docEnd	
	return selfNode.importantArea;
end
--------------------------------------------------------------------------------
--!@docBegin
--!Set whether or not the camera should move on x axis.
--!This value is ignored when camera is not following a node.
--!@param value A boolean value specifying if camera should move on x axis.
local function setLockX(selfNode, value)
--!@docEnd	
	selfNode.lockX = value;
end
--------------------------------------------------------------------------------
--!@docBegin
--!Set whether or not the camera should move on y axis.
--!This value is ignored when camera is not following a node.
--!@param value A boolean value specifying if camera should move on y axis.
local function setLockY(selfNode, value)
--!@docEnd	
	selfNode.lockY = value;
end
--------------------------------------------------------------------------------
--!@docBegin
--!Returns the camera x axis movement locking state. A boolean value.
local function getLockX(selfNode)
--!@docEnd	
	return selfNode.lockX;
end
--------------------------------------------------------------------------------
--!@docBegin
--!Returns the camera y axis movement locking state. A boolean value.
local function getLockY(selfNode)
--!@docEnd	
	return selfNode.lockY;
end
--------------------------------------------------------------------------------
--!@docBegin
--!When an important area is set, and the following node has exist it or has changed direction,
--!smooth movement will make the camera reach its new position in a non-snapping mode.
--!This value is ignored when camera is not following a node.
--!@param value A boolean value specifying if camera should reach its important area smoothly.
local function setSmoothMovement(selfNode, value)
--!@docEnd	
	selfNode.smoothMovement = value;
end
--------------------------------------------------------------------------------
--!@docBegin
--!Returns if the camera is trying to reach the important area smoothly.
local function getSmoothMovement(selfNode)
--!@docEnd	
	return selfNode.smoothMovement;
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local function resetActiveState( selfNode)
	selfNode._active = false;
end
--------------------------------------------------------------------------------
local function visit(selfNode, event)

	if(selfNode._active == false)then
		return;
	end

	local followed = selfNode:getFollowedNode();
	
	if(followed)then
	
		local scene = selfNode:getScene();
		local gwNode = scene:getGameWorldNode();
	
		local winSize = scene:getDesignResolutionSize();
	
		local curPosition = followed:getPosition();
		
		if(selfNode.previousFollowedPosition.x == 0 and selfNode.previousFollowedPosition.y == 0)then
			
			selfNode.previousFollowedPosition = curPosition;
			
			selfNode.directionalOffset.x = selfNode.importantArea.width * winSize.width * 0.5;
			selfNode.directionalOffset.y = selfNode.importantArea.height * winSize.height * 0.5;
			
		end
		
		if(curPosition.x ~= selfNode.previousFollowedPosition.x or curPosition.y ~= selfNode.previousFollowedPosition.y)then
			
			local direction = {	x = curPosition.x - selfNode.previousFollowedPosition.x,
								y = curPosition.y - selfNode.previousFollowedPosition.y};
							
			if(selfNode.previousDirectionVector.x == 0 and selfNode.previousDirectionVector.y == 0)then
				
				selfNode.previousDirectionVector = direction;
				
			end
			
			local followedDeltaX = curPosition.x - selfNode.previousFollowedPosition.x;
			local followedDeltaY = curPosition.y - selfNode.previousFollowedPosition.y;
			
			local filteringFactor = 0.5;
			
			
			if(selfNode.reachingOffsetX)then
				
				local lastOffset = selfNode.directionalOffset.x;
				
				selfNode.directionalOffset.x = selfNode.directionalOffset.x - followedDeltaX;
				
				if(selfNode.smoothMovement)then
					selfNode.directionalOffset.x = selfNode.directionalOffset.x * filteringFactor + lastOffset * (1.0 - filteringFactor);
				end
				
				if(selfNode.directionMultiplierX > 0)then
					if(selfNode.directionalOffset.x < selfNode.directionalOffsetToReach.x)then
						selfNode.directionalOffset.x = selfNode.directionalOffsetToReach.x;
						selfNode.reachingOffsetX = false;
					end
				else
					if(selfNode.directionalOffset.x > selfNode.directionalOffsetToReach.x)then
						selfNode.directionalOffset.x = selfNode.directionalOffsetToReach.x;
						selfNode.reachingOffsetX = false;
					end
				end
			end
			
			if(direction.x/selfNode.previousDirectionVector.x <= 0 or (direction.x == 0 and selfNode.previousDirectionVector.x == 0))then
				
				if(direction.x >=0)then
					selfNode.directionMultiplierX = 1.0;
				else
					selfNode.directionMultiplierX = -1.0;
				end
				
				selfNode.directionalOffsetToReach.x = -selfNode.importantArea.width * winSize.width * 0.5 * selfNode.directionMultiplierX;
				selfNode.reachingOffsetX = true;
			end
		
			if(selfNode.reachingOffsetY)then
				
				local lastOffset = selfNode.directionalOffset.y;
				selfNode.directionalOffset.y = selfNode.directionalOffset.y - followedDeltaY;
				
				if(selfNode.smoothMovement)then
					selfNode.directionalOffset.y = selfNode.directionalOffset.y * filteringFactor + lastOffset * (1.0 - filteringFactor);
				end
				
				if(selfNode.directionMultiplierY > 0)then
					if(selfNode.directionalOffset.y > selfNode.directionalOffsetToReach.y)then
						selfNode.directionalOffset.y = selfNode.directionalOffsetToReach.y;
						selfNode.reachingOffsetY = false;
					end
				else
					
					if(selfNode.directionalOffset.y < selfNode.directionalOffsetToReach.y)then
						selfNode.directionalOffset.y = selfNode.directionalOffsetToReach.y;
						selfNode.reachingOffsetY = false;
					end
				end
			end
			
			if(direction.y / selfNode.previousDirectionVector.y <= 0 or (direction.y == 0 and selfNode.previousDirectionVector.y == 0))then
				if(direction.y >=0)then
					selfNode.directionMultiplierY = -1.0;
				else
					selfNode.directionMultiplierY = 1.0;
				end
				
				selfNode.directionalOffsetToReach.y = selfNode.importantArea.height * winSize.height * 0.5 * selfNode.directionMultiplierY;
				
				selfNode.reachingOffsetY = true;
			end
			
			selfNode.previousDirectionVector = direction;
		end
		
		selfNode.previousFollowedPosition = curPosition;
	end
	
	
	selfNode:animationProtocolEnterFrame(event);


	if(followed)then
		local pt = selfNode:transformToRestrictivePosition(followed:getPosition());
		selfNode:setPosition(pt);
	end
	
	selfNode:setSceneView();
	
	selfNode._wasUpdated = true;
end
--------------------------------------------------------------------------------
local function setSceneView(selfNode)
	if(selfNode._active)then
		
		local transPoint = selfNode:transformToRestrictivePosition(selfNode:getPosition());
		
		local gwNode = selfNode:getScene():getGameWorldNode();
		
		gwNode:setPosition(transPoint);
	end
end
--------------------------------------------------------------------------------
local function transformToRestrictivePosition(selfNode, position)

	local scene = selfNode:getScene();

	local gwNode = scene:getGameWorldNode();
	local transPoint = position;

 	local winSize = scene:getDesignResolutionSize();
	local halfWinSize = {x = winSize.width * 0.5, y =  winSize.height * 0.5};

	local followed = selfNode:getFollowedNode();
	if(followed)then
		
		local gwNodePos = followed:getPosition();
		if(followed:getParent() ~= gwNodePos)then
			
			local worldPoint = followed:convertToWorldSpace({x= 0, y= 0});
			gwNodePos = gwNode:convertToNodeSpace(worldPoint);
		end
		
		local scaledMidpoint = {x = gwNodePos.x, y = gwNodePos.y};
		local followedPos = {	x = (halfWinSize.x - scaledMidpoint.x), 
								y = (halfWinSize.y - scaledMidpoint.y)};

		if(selfNode:getLockX() == false)then
			transPoint.x = followedPos.x;
			transPoint.x = transPoint.x + selfNode.directionalOffset.x;
		end
		
		if(selfNode:getLockY() == false)then
			transPoint.y = followedPos.y;
			transPoint.y = transPoint.y + selfNode.directionalOffset.y;
		end
		
		transPoint.x = transPoint.x + selfNode.offset.x*winSize.width;
		transPoint.y = transPoint.y + selfNode.offset.y*winSize.height;
		
	end
	
	
	local x = transPoint.x;
	local y = transPoint.y;
	local worldRect = scene:getGameWorldRect();
	
	if(selfNode:getRestrictedToGameWorld() and 
		(worldRect.origin.x ~= 0 or worldRect.origin.y ~= 0 or worldRect.size.width ~= 0 or worldRect.size.height ~= 0))then
	
		x = math.max(x, winSize.width*0.5 - (worldRect.origin.x + worldRect.size.width - winSize.width * 0.5));
		x = math.min(x, winSize.width*0.5 - worldRect.origin.x - winSize.width*0.5);
		
		y = math.max(y, winSize.height*0.5 - (worldRect.origin.y + worldRect.size.height - (winSize.height*0.5)));
		y = math.min(y, winSize.height*0.5 - (worldRect.origin.y + winSize.height*0.5));
	end
	
	transPoint.x = x;
	transPoint.y = y;

	return transPoint;
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local LHCamera = {}
function LHCamera:nodeWithDictionary(dict, prnt)

	if (nil == dict) then
		print("Invalid LHCamera initialization!")
	end
				
	local LHUtils = require("LevelHelper2-API.Utilities.LHUtils");
	local LHNodeProtocol = require('LevelHelper2-API.Protocols.LHNodeProtocol')
	local LHAnimationsProtocol = require('LevelHelper2-API.Protocols.LHAnimationsProtocol');
	
	local object = display.newGroup();
	
	--add all LevelHelper 2 valid properties to the object
	object.nodeType = "LHCamera"
	
	--add LevelHelper methods
	
	object._wasUpdated = false;
	
	object._followedNodeUUID= dict["followedNodeUUID"];
	object._active 			= dict["activeCamera"];
	object._restricted 		= dict["restrictToGameWorld"];
	
	object.lockX = dict["lockX"];
	object.lockY = dict["lockY"];
	object.importantArea = LHUtils.sizeFromString(dict["importantArea"]);
	object.smoothMovement = dict["smoothMovement"];
	object.offset = LHUtils.pointFromString(dict["offset"]);


	object.previousFollowedPosition = {x = 0, y = 0};
	object.previousDirectionVector = {x = 0, y = 0};
	
	object.directionalOffset = {x = 0, y = 0};
	object.directionalOffsetToReach = {x = 0, y = 0};
	object.directionMultiplierX  = 0;
	object.directionMultiplierY = 0;

	object.reachingOffsetX = false;
	object.reachingOffsetY = false;


	prnt:addChild(object);
	
	LHNodeProtocol.initNodeProtocolWithDictionary(dict, object, prnt);
	LHAnimationsProtocol.initAnimationsProtocolWithDictionary(dict, object, prnt:getScene());
	
	object.nodeProtocolEnterFrame 	= object.enterFrame;
	object.enterFrame 				= visit;
	
	object.resetActiveState 		= resetActiveState;
	object.setSceneView 			= setSceneView;
	object.transformToRestrictivePosition = transformToRestrictivePosition;
	
	--Functions
	----------------------------------------------------------------------------
	object.isActive = isActive;
	object.setActive= setActive;
	
	object.getFollowedNode = getFollowedNode;
	object.setFollowedNode = setFollowedNode;
	object.getRestrictedToGameWorld = getRestrictedToGameWorld;
	object.setRestrictedToGameWorld = setRestrictedToGameWorld;
	object.setPosition = setPosition;
	object.getPosition = getPosition;
	
	object.setOffsetUnit = setOffsetUnit;
	object.getOffsetUnit = getOffsetUnit;
	object.setImportantAreaUnit = setImportantAreaUnit;
	object.getImportantAreaUnit = getImportantAreaUnit;
	object.setLockX = setLockX;
	object.setLockY = setLockY;
	object.getLockX = getLockX;
	object.getLockY = getLockY;
	object.setSmoothMovement = setSmoothMovement;
	object.getSmoothMovement = getSmoothMovement;
	
	
	return object
end
--------------------------------------------------------------------------------
return LHCamera;