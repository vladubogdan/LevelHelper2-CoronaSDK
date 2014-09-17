-----------------------------------------------------------------------------------------
--
-- LHNodeProtocol.lua
--
-----------------------------------------------------------------------------------------

module (..., package.seeall)

local LHGameWorldNode = require('LevelHelper2-API.Nodes.LHGameWorldNode')
local LHUINode = require('LevelHelper2-API.Nodes.LHUINode')
local LHBackUINode = require('LevelHelper2-API.Nodes.LHBackUINode')
local LHSprite = require('LevelHelper2-API.Nodes.LHSprite')

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
function nodeWithUniqueName(selfNode, name)
--!@docEnd	
    if selfNode.numChildren then
        for i = 1, selfNode.numChildren do
    		local node = selfNode[i]
    		if node._isNodeProtocol == true then
                local uName = node.lhUniqueName
                
            	if(uName ~= nil)then
        			if(uName == name)then
        				return node;
        			end
                end
            
    	        local childNode = node:nodeWithUniqueName(name);
    	        if childNode ~= nil then
    	            return childNode;
    	        end
    	    end
        end
    end
	return nil;
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

    local LHUtils = require("LevelHelper2-API.Utilities.LHUtils");

    local value = dict["generalPosition"]
    if value then
        local unitPosition = LHUtils.pointFromString(value);
        local calculatedPos= LHUtils.positionForNodeFromUnit(node, unitPosition);
            
        node.x = calculatedPos.x;
        node.y = calculatedPos.y;
        
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
	node.nodeWithUniqueName = nodeWithUniqueName;
	
	--Load node protocol properties
	----------------------------------------------------------------------------
	node.lhUniqueName = dict["name"];
    node.lhUuid = dict["uuid"];
    node.lhTags = LHUtils.LHDeepCopy(dict["tags"]);
        
    value = dict["rotation"];
    if(value)then
        node.rotation = value;
    end
        
    value = dict["alpha"];
    if(value)then
        node.alpha = value/255.0;
    end

    
    node.lhZOrder = dict["zOrder"];
    
    value = dict["scale"];
    if(value)then
        local scl = LHUtils.pointFromString(value);
        node.xScale = scl.x;
        node.yScale = scl.y;
    end
        
    
    -- if([dict objectForKey:@"anchor"] &&
    --       ![_node isKindOfClass:[LHUINode class]] &&
    --       ![_node isKindOfClass:[LHBackUINode class]] &&
    --       ![_node isKindOfClass:[LHGameWorldNode class]])
    --     {
    
    value = dict["anchor"];
    if(value)then
        local anchor = LHUtils.pointFromString(value);
        node.anchorX = anchor.x;
        node.anchorY = anchor.y;
    end
    
            -- CGPoint anchor = [dict pointForKey:@"anchor"];
    --         anchor.y = 1.0f - anchor.y;
    --         [_node setAnchorPoint:anchor];
    --     }
    
        
end
--------------------------------------------------------------------------------
function createLHNodeWithDictionaryWithParent(childInfo, prnt)

    local nodeType = childInfo["nodeType"];
    
    local scene = nil;
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
    
    print("UNKNOWN NODE TYPE " .. nodeType);
    
    return nil
end
