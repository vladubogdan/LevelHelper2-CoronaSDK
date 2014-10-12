--------------------------------------------------------------------------------
--
-- LHScene.lua
--
--------------------------------------------------------------------------------

local LHUtils = require("LevelHelper2-API.Utilities.LHUtils");
local LHNodeProtocol = require("LevelHelper2-API.Protocols.LHNodeProtocol")

--------------------------------------------------------------------------------
--!@docBegin
--!Get the back ui node from the scene.
function getBackUINode(_sceneObj)
--!@docEnd
end
--------------------------------------------------------------------------------
--!@docBegin
--!Get the game world node from the scene.
function getGameWorldNode(_sceneObj)
--!@docEnd
end
--------------------------------------------------------------------------------
--!@docBegin
--!Get the front ui node from the scene.
function getUINode(_sceneObj)
--!@docEnd
    if(_sceneObj._uiNode == nil)then
        for i = 1, _sceneObj.numChildren do
		    local node = _sceneObj[i]

		    if node.nodeType == "LHUINode" then
		        _sceneObj._uiNode = node;
	        end
        end
	end
    return _sceneObj._uiNode;
end
--------------------------------------------------------------------------------
--!@docBegin
--!Get the physical shape fixture information with a specific unique identifier.
--!@param uuid The shape fixture unique identifier
function tracedFixturesWithUUID(_sceneObj, uuid)
--!@docEnd
	return _sceneObj._tracedFixtures[uuid];
end

function removeSelf(_sceneObj)
	
	Runtime:removeEventListener( "enterFrame", _sceneObj )
	_sceneObj:_superRemoveSelf();
	
end

local LHScene = {}
function LHScene:initWithContentOfFile(jsonFile)

	if (nil == jsonFile) then
		print("Invalid Json file.")
	end
				
	local _scene = display.newGroup();
	
	--add all LevelHelper 2 valid properties to the object
	_scene.nodeType = "LHScene"
	
	--functions
	_scene.getBackUINode 				= getBackUINode;
	_scene.getGameWorldNode 			= getGameWorldNode;
	_scene.getUINode 		 			= getUINode;
	_scene.tracedFixturesWithUUID 		= tracedFixturesWithUUID;
	
	_scene._superRemoveSelf 			= _scene.removeSelf;
	_scene.removeSelf 					= removeSelf;
	
	local dict = nil;
    if not base then base = system.ResourceDirectory; end
    local jsonContent = LHUtils.jsonFileContent(jsonFile, base)    
    if(jsonContent)then
        local json = require "json"
        dict = json.decode( jsonContent )
    end


	local tracedFixInfo = dict["tracedFixtures"];
	if(tracedFixInfo ~= nil)then
		_scene._tracedFixtures = LHUtils.LHDeepCopy(tracedFixInfo);
	end
	
	
	local LHNodeProtocol = require('LevelHelper2-API.Protocols.LHNodeProtocol')
	LHNodeProtocol.initNodeProtocolWithDictionary(dict, _scene);
	LHNodeProtocol.loadChildrenForNodeFromDictionary(_scene, dict);
	
	Runtime:addEventListener( "enterFrame", _scene )
	
	return _scene
end
--------------------------------------------------------------------------------
return LHScene;
