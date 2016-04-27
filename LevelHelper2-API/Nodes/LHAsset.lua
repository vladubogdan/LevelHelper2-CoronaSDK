--------------------------------------------------------------------------------
--
--LHAsset.lua
--
--!@docBegin
--!LHAsset class is used to load an asset object from a level file or from the resources folder.
--!
--!Conforms to:
--!
--!LHNodeProtocol
--!
--!LHAnimationsProtocol
--!
--!LHPhysicsProtocol
--!
--!@docEnd
--------------------------------------------------------------------------------
local function visit(selfNode, event)

	selfNode:animationProtocolEnterFrame(event);
	selfNode:nodeProtocolEnterFrame(event);
	
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
--!@docBegin
--!Get the node with the unique name inside the current node.
--!@param name The node unique name to look for inside the children of the current node.
local function getChildNodeWithUniqueName(selfNode, name)
--!@docEnd	
	if(selfNode:getUniqueName() ~= nil and selfNode:getUniqueName() == name)then
		return selfNode;
	end
	
	local assetParent = selfNode:getParent();
	
	if(assetParent)then
		for i = 1, assetParent:getNumberOfChildren() do
			local node = assetParent:getChildAtIndex(i);
			if node._isNodeProtocol == true and node._assetParent == selfNode then
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
	
	local assetParent = selfNode:getParent();
	if(assetParent)then
		for i = 1, assetParent:getNumberOfChildren() do
			local node = assetParent:getChildAtIndex(i);
			if node._isNodeProtocol == true and node._assetParent == selfNode then
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
	
	local assetParent = selfNode:getParent();
	if(assetParent)then
		for i = 1, assetParent:getNumberOfChildren() do
			local node = assetParent:getChildAtIndex(i);
			if node._isNodeProtocol == true and node._assetParent == selfNode then
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
	
	local assetParent = selfNode:getParent();
	if(assetParent)then
		for i = 1, assetParent:getNumberOfChildren() do
			local node = assetParent:getChildAtIndex(i);
			
			if node._isNodeProtocol == true and node._assetParent == selfNode then
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
	end
	return temp;
end
--------------------------------------------------------------------------------
--!@docBegin
--!Returns all children nodes that have the specified tag values.
--!@param tagsTable A table of strings containing tag names.
--!@param any Specify if all or just one tag value of the node needs to be in common with the tagsTable passed as argument to this function.
local function getChildrenWithTags(selfNode, tagsTable, any)
--!@docEnd	
	local temp = {};

	local assetParent = selfNode:getParent();
	if(assetParent)then
		
		for i = 1, assetParent:getNumberOfChildren() do
			local child = assetParent:getChildAtIndex(i);
			
			if child._isNodeProtocol == true and child._assetParent == selfNode then
		
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
	end
	return temp;
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local LHAsset = {}
function LHAsset:nodeWithDictionary(dict, prnt)

	if (nil == dict) then
		print("Invalid LHAsset initialization!")
	end
				
	local LHUtils = require("LevelHelper2-API.Utilities.LHUtils");
    local LHNodeProtocol = require('LevelHelper2-API.Protocols.LHNodeProtocol')
    local LHAnimationsProtocol = require('LevelHelper2-API.Protocols.LHAnimationsProtocol');
    local LHPhysicsProtocol = require('LevelHelper2-API.Protocols.LHPhysicsProtocol')
    
    local object = display.newGroup();
    
    --add all LevelHelper 2 valid properties to the object
	object.nodeType = "LHAsset"
	
	--add LevelHelper methods
    
    prnt:addChild(object);
	
	local scene = prnt:getScene();
	
	LHNodeProtocol.initNodeProtocolWithDictionary(dict, object, prnt);
	LHPhysicsProtocol.initPhysicsProtocolWithDictionary(dict["nodePhysics"], object, prnt:getScene());
	local LHUtils = require("LevelHelper2-API.Utilities.LHUtils");
	
	local fileExists = false;
	if(dict["assetFile"])then

		local assetInfo = scene:assetInfoForFile(dict["assetFile"]);

		if(assetInfo)then
			
			fileExists = true;
			local tracedFix = assetInfo["tracedFixtures"];
			if(tracedFix)then
				object._tracedFixtures = LHUtils.LHDeepCopy(tracedFix);
			end

			LHNodeProtocol.loadChildrenForNodeFromDictionary(object, assetInfo);
			
			for i=1, object:getNumberOfChildren() do
				
				local child = object:getChildAtIndex(i);
				
				if(child)then
					
					child._assetParent = object;
					
					local contentX, contentY = child:localToContent(0,0);
				
					local localX, localY = prnt:contentToLocal(contentX, contentY);
					
					prnt:insert(child);
					
					child:setPosition({x = localX, y = localY});
					child.lhOriginalPosition = {x = localX, y = localY};
					
					local xScale = child.xScale;
					local yScale = child.yScale;
					
					child:setScale(xScale*object.xScale, yScale*object.yScale);
					
					local localRot = child.rotation;
					
					child:setRotation(localRot+object.rotation);
					
				end
			end
			
		end
	end
	if(false == fileExists)then
		print("WARNING: COULD NOT FIND INFORMATION FOR ASSET " ..  object:getUniqueName() ..". This usually means that the asset was created but not saved. Check your level and in the Scene Navigator, click on the lock icon next to the asset name.");
		LHNodeProtocol.loadChildrenForNodeFromDictionary(object, dict);
	end

	LHAnimationsProtocol.initAnimationsProtocolWithDictionary(dict, object, prnt:getScene());
	
	object.nodeProtocolEnterFrame 	= object.enterFrame;
	object.enterFrame = visit;
	
	
	object.getChildNodeWithUniqueName = getChildNodeWithUniqueName;
	object.getChildNodeWithUUID = getChildNodeWithUUID;
	object.getChildrenOfType = getChildrenOfType;
	object.getChildrenOfProtocol = getChildrenOfProtocol;
	object.getChildrenWithTags = getChildrenWithTags;

	--Functions
	----------------------------------------------------------------------------
	
	return object
end

--------------------------------------------------------------------------------
--!@docBegin
--!Creates a new asset node with a specific name.
--!@param assetName The name of the new asset node. Can be used later to retrieve the asset from the children hierarchy.
--!@param fileName The name of the asset file. Do not provide an extension. E.g If file is named "myAsset.lhasset.json" then yous should pass @"myAsset.lhasset".
--!@param prnt The parent node. Must not be nil and must be a children of the LHScene (or subclass of LHScene).
--!@param scenePosX The x position where the asset should be placed in scene coordinates.
--!@param scenePosY The y position where the asset should be placed in scene coordinates.
--!@return A new node object or nil if no asset file is found.
--!@code
--!		local LHAsset = require('LevelHelper2-API.Nodes.LHAsset');
--!		local newAssetObj = LHAsset:createWithNameAndAssetFileName("uniqueNameOfNodeInScene", "myAsset.lhasset", lhScene:getGameWorldNode(), 100, 200);
--!			
--!		--where lhScene is the object returned by LHScene:initWithContentOfFile("...");
--!@endcode
function LHAsset:createWithNameAndAssetFileName(assetName, fileName, prnt, scenePosX, scenePosY)
--!@docEnd	

	-- get the asset info 
	local dict = prnt:getScene():assetInfoForFile(fileName);
	
	if (nil == dict) then
		print("Invalid LHAsset initialization!")
	end
				
	local LHUtils = require("LevelHelper2-API.Utilities.LHUtils");
    local LHNodeProtocol = require('LevelHelper2-API.Protocols.LHNodeProtocol')
    local LHAnimationsProtocol = require('LevelHelper2-API.Protocols.LHAnimationsProtocol');
    local LHPhysicsProtocol = require('LevelHelper2-API.Protocols.LHPhysicsProtocol')
    
    local object = display.newGroup();
    
    --add all LevelHelper 2 valid properties to the object
	object.nodeType = "LHAsset"
	
	--add LevelHelper methods
    
    prnt:addChild(object);
	
	local scene = prnt:getScene();
	
	LHNodeProtocol.initNodeProtocolWithDictionary(dict, object, prnt);
	
	local prntPos = prnt:convertToNodeSpace({x = scenePosX, y = scenePosY});
	object:setPosition(prntPos);
	
	LHPhysicsProtocol.initPhysicsProtocolWithDictionary(dict["nodePhysics"], object, prnt:getScene());
	local LHUtils = require("LevelHelper2-API.Utilities.LHUtils");
	
	local assetInfo = dict;
	if(assetInfo)then
			
		fileExists = true;
		local tracedFix = assetInfo["tracedFixtures"];
		if(tracedFix)then
			object._tracedFixtures = LHUtils.LHDeepCopy(tracedFix);
		end

		LHNodeProtocol.loadChildrenForNodeFromDictionary(object, assetInfo);
		
		for i=1, object:getNumberOfChildren() do
			
			local child = object:getChildAtIndex(i);
			
			if(child)then
				
				child._assetParent = object;
				
				local contentX, contentY = child:localToContent(0,0);
			
				local localX, localY = prnt:contentToLocal(contentX, contentY);
				
				prnt:insert(child);
				
				child:setPosition({x = localX, y = localY});
				child.lhOriginalPosition = {x = localX, y = localY};
				
				
				local xScale = child.xScale;
				local yScale = child.yScale;
				
				child:setScale(xScale*object.xScale, yScale*object.yScale);
				
				local localRot = child.rotation;
				
				child:setRotation(localRot+object.rotation);
				
			end
		end
	end
	
	LHAnimationsProtocol.initAnimationsProtocolWithDictionary(dict, object, prnt:getScene());
	
	object.nodeProtocolEnterFrame 	= object.enterFrame;
	object.enterFrame = visit;
	
	object.getChildNodeWithUniqueName = getChildNodeWithUniqueName;
	object.getChildNodeWithUUID = getChildNodeWithUUID;
	object.getChildrenOfType = getChildrenOfType;
	object.getChildrenOfProtocol = getChildrenOfProtocol;
	object.getChildrenWithTags = getChildrenWithTags;

	--Functions
	----------------------------------------------------------------------------
	
	object.lhUniqueName = assetName;
	
	return object
end
--------------------------------------------------------------------------------
return LHAsset;
