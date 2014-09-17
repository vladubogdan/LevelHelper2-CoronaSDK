-----------------------------------------------------------------------------------------
--
-- level1.lua
--
-----------------------------------------------------------------------------------------
local composer = require( "composer" )
local scene = composer.newScene()

-- include Corona's "physics" library
local physics = require "physics"
physics.start(); physics.pause()


--------------------------------------------
local LHScene =  require("LevelHelper2-API.LHScene");
local lhScene = nil;--forward declaration of lhScene in order to access it everywhere in this file
--------------------------------------------


function scene:create( event )
	
	local sceneGroup = scene.view

    local lhScene = LHScene:initWithContentOfFile("publishFolder/level01.json");

	local uiNode = lhScene:getUINode();
	
	local statue = uiNode:nodeWithUniqueName("object_statue");
	
	
	print("STATUE1 " .. tostring(statue));
-- 	print("STATUE2 " .. tostring(lhScene:nodeWithUniqueName("object_statue")));

    -- require('LevelHelper2-API.Utilities.LHUtils').LHPrintObjectInfo(statue);
    
    print("statue anchor " .. tostring(statue.anchorX) .. " " .. tostring(statue.anchorY));
        
end


function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
		-- 
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
		physics.start()
	end
end

function scene:hide( event )
	local sceneGroup = self.view
	
	local phase = event.phase
	
	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
		physics.stop()
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end	
	
end

function scene:destroy( event )

	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
	local sceneGroup = self.view
	
	package.loaded[physics] = nil
	physics = nil
end

--------------------------------------------------------------------------------
-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
--------------------------------------------------------------------------------

return scene