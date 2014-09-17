--------------------------------------------------------------------------------
--
-- LHScene.lua
--
--------------------------------------------------------------------------------

local LHUtils = require('LevelHelper2-API.Utilities.LHUtils')
local LHNodeProtocol = require('LevelHelper2-API.Protocols.LHNodeProtocol')

--------------------------------------------------------------------------------
function getBackUINode(_sceneObj)
    
end
--------------------------------------------------------------------------------
function getGameWorldNode(_sceneObj)
end
--------------------------------------------------------------------------------
function getUINode(_sceneObj)

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


local LHScene = {}
function LHScene:initWithContentOfFile(jsonFile)

	if (nil == jsonFile) then
		print("Invalid Json file.")
	end
				
	local _scene = display.newGroup();
	
	--add all LevelHelper 2 valid properties to the object
	_scene.nodeType = "LHScene"
	
	--functions
	_scene.getBackUINode 	= getBackUINode;
	_scene.getGameWorldNode = getGameWorldNode;
	_scene.getUINode 	    = getUINode;
	
	
	local dict = nil;
    if not base then base = system.ResourceDirectory; end
    local jsonContent = LHUtils.jsonFileContent(jsonFile, base)    
    if(jsonContent)then
        local json = require "json"
        dict = json.decode( jsonContent )
    end

	
	local LHNodeProtocol = require('LevelHelper2-API.Protocols.LHNodeProtocol')
	LHNodeProtocol.initNodeProtocolWithDictionary(dict, _scene);
	LHNodeProtocol.loadChildrenForNodeFromDictionary(_scene, dict);
	
	return _scene
end
--------------------------------------------------------------------------------
return LHScene;
