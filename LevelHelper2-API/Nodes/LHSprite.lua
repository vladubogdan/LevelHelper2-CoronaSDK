--------------------------------------------------------------------------------
--
-- LHSprite.lua
--
--!@docBegin
--!LHSprite class is used to load textured rectangles that are found in a level file.
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
--------------------------------------------------------------------------------
--!@docBegin
--!Changes the sprite texture rectangle based on the new sprite name.
--!@param spriteName A name from the sprite sheet this sprite belongs to. A string value.
local function setSpriteFrameWithName( selfNode, spriteName )
--!@docEnd
	if(selfNode.frameNamesMap ~= nil)then
		local frame = selfNode.frameNamesMap[spriteName];
		if(frame)then
			selfNode:setFrame(frame);
			selfNode.spriteFrameName = spriteName;
		end
	end
end
--------------------------------------------------------------------------------
--!@docBegin
--!Get the name of the sprite texture rectangle.
--!Returns A string value or nil if sprite is not using a frame name but an image file.
local function getSpriteFrameName( selfNode)
--!@docEnd
	return selfNode.spriteFrameName;
end
--------------------------------------------------------------------------------
--!@docBegin
--!Get the image file path used by the texture of this sprite.
--!Returns A string value
local function getImageFilePath(selfNode)
	return selfNode.imageFilePath;
end

--------------------------------------------------------------------------------
--!@docBegin
--!Get the sprite sheet path
--!Returns A string value or nil if sprite is using an image file.
local function getSpriteSheetPath(selfNode)
	return selfNode.spriteSheetPath;
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local function visit(selfNode, event)

	selfNode:animationProtocolEnterFrame(event);
	selfNode:nodeProtocolEnterFrame(event);
	
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local LHSprite = {}
function LHSprite:nodeWithDictionary(dict, prnt)
	
	if (nil == dict) then
		print("Invalid LHSprite initialization!")
	end
	
	
	local LHUtils = require("LevelHelper2-API.Utilities.LHUtils");
	
	local relativeImagePath = dict["relativeImagePath"];
	local imageFileName     = dict["imageFileName"];
	local imageFilePath     = relativeImagePath .. imageFileName;
	local spriteName        = dict["spriteName"];
	
	local contentSize       = LHUtils.sizeFromString(dict["size"]);
	
	local isSprite = (nil ~= spriteName);
	
	local object = nil; --sprite sheet or newImage
	
	-- contentSize.width = contentSize.width*4;
	-- contentSize.height= contentSize.height*4;
	
	-- print("image path " .. imageFilePath);
	-- print("relativeImagePath " .. tostring(relativeImagePath));
	-- print("imageFileName " .. imageFileName);
	
	-- print("ACTUAL CONTENT SIZE : " .. display.actualContentWidth .. " " .. display.actualContentHeight);
	-- print("PIXEL SIZE : " .. display.pixelWidth .. " " .. display.pixelHeight);
	-- print("USER CONTENT SIZE : " .. display.contentWidth .. " " .. display.contentHeight);
	-- print( display.pixelWidth / display.actualContentWidth )
	-- print("IMAGE SIZE " .. tostring(contentSize.width) .. " " .. tostring(contentSize.height));
	    
	if false == isSprite then
	    object = display.newImageRect(imageFilePath, contentSize.width, contentSize.height, true);
	else
		
		local spriteSheetPath = LHUtils.stripExtension(imageFilePath);
		spriteSheetPath = LHUtils.replaceOccuranceOfStringWithString( spriteSheetPath, "/", "." )
		
		    
		-- require the sprite sheet information file
		local sheetInfo = require(spriteSheetPath); 
		--create the image sheet
		local imageSheet = graphics.newImageSheet( imageFilePath, sheetInfo.getSpriteSheetData() );
		--create the sprite
		
		    
		--local GHSprite = display.newImage(imageSheet, sheetInfo.getFrameForName(spriteName));
		--here i call the local GHSprite only because i want the documentation parser to know where to add this method
		--i could have called it in any way.
		
		local sequenceData = {
		    name=imageFile,
		    start=1,
		    count=sheetInfo.getFramesCount()
		}
		object = display.newSprite( imageSheet, sequenceData )
		
		object:setFrame(sheetInfo.getFrameForName(spriteName));
		object.frameNamesMap = LHUtils.LHDeepCopy(sheetInfo.getFrameNamesMap());    
		--    addGHSpriteMethods();
		--    loadPhysicsForImageFileAndSpriteName(imageFilePath, spriteName);    
		
		
		local unitPosition = LHUtils.pointFromString(dict["generalPosition"]);
		
		local calculatedPos= LHUtils.positionForNodeFromUnit(object, unitPosition);
		
		object.x = calculatedPos.x;
		object.y = calculatedPos.y;

		object.spriteSheetPath = spriteSheetPath;
	end

	--add all LevelHelper 2 valid properties to the object
	object.nodeType = "LHSprite"
	
	object.spriteFrameName = spriteName;
	object.imageFilePath = imageFilePath;
	
	
	
	--Functions
	----------------------------------------------------------------------------
	object.setSpriteFrameWithName 	= setSpriteFrameWithName;
	object.getSpriteFrameName 		= getSpriteFrameName;
	object.getImageFilePath 		= getImageFilePath;
	object.getSpriteSheetPath 		= getSpriteSheetPath;
	
	
	local LHNodeProtocol = require('LevelHelper2-API.Protocols.LHNodeProtocol');
	local LHAnimationsProtocol = require('LevelHelper2-API.Protocols.LHAnimationsProtocol');
	local LHPhysicsProtocol = require('LevelHelper2-API.Protocols.LHPhysicsProtocol');
	
	
	
	
	
	-- LHUtils.LHPrintObjectInfo(prnt);
	
	prnt:addChild(object);
	LHNodeProtocol.simulateModernObjectHierarchy(prnt, object);
	LHNodeProtocol.initNodeProtocolWithDictionary(dict, object, prnt);
	
	LHPhysicsProtocol.initPhysicsProtocolWithDictionary(dict["nodePhysics"], object, prnt:getScene());
	LHNodeProtocol.loadChildrenForNodeFromDictionary(object, dict);
	
	LHAnimationsProtocol.initAnimationsProtocolWithDictionary(dict, object, prnt:getScene());
	
	--Specific sprites properties
	----------------------------------------------------------------------------
	local value = dict["colorOverlay"];
	if(value)then
		local clr = LHUtils.colorFromString(value);
		object:setFillColor(clr.red, clr.green, clr.blue);
	end


	object.nodeProtocolEnterFrame 	= object.enterFrame;
	object.enterFrame = visit;
	
	
	return object
end
--------------------------------------------------------------------------------
return LHSprite;
