--------------------------------------------------------------------------------
--
-- LHBoneConnection.lua
--
--!@docBegin
--!LHBoneConnection class is used to hold data needed by a bone to transform a connected sprite.
--!
--!@docEnd
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
LHBoneConnection = {}
function LHBoneConnection:createConnectionWithDictionary(dict, bone)

	local LHUtils = require("LevelHelper2-API.Utilities.LHUtils");
	
	local object = {_angleDelta 	= dict["angleDelta"],
					_nodeName 		= dict["nodeName"],
					_bone 			= bone,
					_node 			= nil
				}
				
	setmetatable(object, { __index = LHBoneConnection })  -- Inheritance	
	
	local posDelta = LHUtils.pointFromString(dict["positionDelta"]);
	
	object._positionDelta  = {x = posDelta.x, y = posDelta.y};
	
	
	return object;
end
--------------------------------------------------------------------------------
function LHBoneConnection:getAngleDelta()
	return self._angleDelta;
end
--------------------------------------------------------------------------------
function LHBoneConnection:getPositionDelta()
	return self._positionDelta;	
end
--------------------------------------------------------------------------------
function LHBoneConnection:getConnectedNode()
	
	if(nil == self._connectedNode and self._nodeName~= nil and self._bone ~= nil) then
		
		local rootBoneNodes = self._bone:getRootBoneNodes();
	
		if(rootBoneNodes ~= nil)then
			self._connectedNode = rootBoneNodes:getChildNodeWithUniqueName(self._nodeName);
			
			--delta from level helper is not correct - lets calculated it in corona coordinate system
			-- the very first time after the connected node is found - so before any transformation is made
			if(self._connectedNode)then
				
    			local boneWorldAngle = self._bone:getParent():convertToWorldAngle(self._bone.rotation);
    			local spriteWorldAngle = self._connectedNode:getParent():convertToWorldAngle(self._connectedNode.rotation);
    			self._angleDelta = spriteWorldAngle - boneWorldAngle;
    
				local nodeWorldPos = self._connectedNode:convertToWorldSpace({x = 0, y = 0});
    			self._positionDelta = self._bone:convertToNodeSpace(nodeWorldPos);
    			
    			self._connectedNode:setAnchorByKeepingPosition(0.5, 0.5);
				
    		end
		end
	end

    return self._connectedNode;
end
--------------------------------------------------------------------------------
function LHBoneConnection:getConnectedNodeName()
	return self._nodeName;
end
--------------------------------------------------------------------------------
function LHBoneConnection:getBone()
	return self._bone;
end
--------------------------------------------------------------------------------
function LHBoneConnection:removeSelf()
	self._angleDelta = nil
	self._bone = nil;
 	self._positionDelta = nil
	self._nodeName = nil;
	self._node = nil;
	self = nil
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
