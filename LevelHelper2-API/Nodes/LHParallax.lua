--------------------------------------------------------------------------------
--
-- LHParallax.lua
--
--!@docBegin
--!LHParallax class is used to load a parallax object from a level file.
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
--!Get the node that this parallax follows. The node or nil.
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
--!Sets the node this parallax should follow.
--!@param node A LevelHelper node object
local function setFollowedNode( selfNode, node)
--!@docEnd
	selfNode._followedNode = node;
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local function transformLayerPositions(selfNode)
	
	local scene = selfNode:getScene();
	local gwNode = scene:getGameWorldNode();
	
	local parallaxPos = selfNode:getPosition();
	local followed = selfNode:getFollowedNode();
	
	
	if(followed~=nil)then
		
		if(followed:getType() == "LHCamera")then
			if(followed._wasUpdated == false)then
				return;
			end
		end
	
		local worldPoint = followed:convertToWorldSpace({x = 0, y = 0});
		if(followed:getType() == "LHCamera")then
			local winSize = scene:getDesignResolutionSize();
			worldPoint = {x = winSize.width* 0.5, y = winSize.height*0.5};
		end
		
		
		parallaxPos = gwNode:convertToNodeSpace(worldPoint);
	end
	
	if(selfNode.initialPosition.x == 0 and selfNode.initialPosition.y == 0)then
		selfNode.initialPosition = parallaxPos;
	end
	
	if(selfNode.lastPosition.x ~= parallaxPos.x or selfNode.lastPosition.y ~= parallaxPos.y)then
		
		local deltaPos = {x = selfNode.initialPosition.x - parallaxPos.x, 
							y = selfNode.initialPosition.y - parallaxPos.y};
		
		for i=1, selfNode:getNumberOfChildren() do
		
			local nd = selfNode:getChildAtIndex(i);
			
			if(nd~= nil and nd:getType() == "LHParallaxLayer")then
			
				local initialPos = nd:getInitialPosition();
				local pt = {x = initialPos.x - deltaPos.x*nd:getXRatio(),
							y = initialPos.y - deltaPos.y*nd:getYRatio()};
				nd:setPosition(pt);
			end
		end
	end

	selfNode.lastPosition = parallaxPos;

end
--------------------------------------------------------------------------------
local function visit(selfNode, event)

	selfNode:animationProtocolEnterFrame(event);
	selfNode:nodeProtocolEnterFrame(event);
	
	selfNode:transformLayerPositions();
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local LHParallax = {}
function LHParallax:nodeWithDictionary(dict, prnt)

	if (nil == dict) then
		print("Invalid LHParallax initialization!")
	end
				
	local LHUtils = require("LevelHelper2-API.Utilities.LHUtils");
	local LHNodeProtocol = require('LevelHelper2-API.Protocols.LHNodeProtocol')
	local LHAnimationsProtocol = require('LevelHelper2-API.Protocols.LHAnimationsProtocol');

	local object = display.newGroup();
	
	--add all LevelHelper 2 valid properties to the object
	object.nodeType = "LHParallax"
	
	--add LevelHelper methods
	prnt:addChild(object);
	
	LHNodeProtocol.initNodeProtocolWithDictionary(dict, object, prnt);
	LHNodeProtocol.loadChildrenForNodeFromDictionary(object, dict);

	object._followedNodeUUID = dict["followedNodeUUID"];

 	object.lastPosition = {x = 0, y = 0};
	object.initialPosition = {x = 0, y = 0};

	LHAnimationsProtocol.initAnimationsProtocolWithDictionary(dict, object, prnt:getScene());
	
	object.nodeProtocolEnterFrame 	= object.enterFrame;
	object.enterFrame = visit;
	object.transformLayerPositions = transformLayerPositions;
	
	--Functions
	----------------------------------------------------------------------------
	object.getFollowedNode = getFollowedNode;
	object.setFollowedNode = setFollowedNode;
	
	
	return object
end
--------------------------------------------------------------------------------
return LHParallax;
