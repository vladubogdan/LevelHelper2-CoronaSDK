
local widget = require( "widget" )
local composer = require( "composer" )
local scene = composer.newScene();
--------------------------------------------
local LHScene =  require("LevelHelper2-API.LHScene");
local lhScene = nil;--forward declaration of lhScene in order to access it everywhere in this file
--------------------------------------------
local LHUtils = require("LevelHelper2-API.Utilities.LHUtils");
--------------------------------------------
--------------------------------------------


function scene:create( event )

	local sceneGroup = scene.view

	lhScene = LHScene:initWithContentOfFile("publishFolder/introduction.json");

	sceneGroup:insert(lhScene);
	
	local myString = "INTRODUCTION\nUse the Previous and Next buttons to toggle between demos.\n"..
						"Use the Restart button to start the current demo again.\n"..
						"Investigate each demo source file and LevelHelper document file for more info on how it was done.\n"..
						"You can find all scene files in the \"demo\" folder.\"";
						
	local myText = display.newText( myString, 240, 340, display.contentWidth - 20, display.contentHeight, native.systemFont, 12 )
	myText:setFillColor( 0, 0, 0 )

	local uiNode = lhScene:getUINode();
	uiNode:insert( myText );
end

function scene:show( event )
	
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		self.demoButtons = require("demo.demoButtons");
		self.demoButtons:createButtonsWithComposerScene(self, "introductionScene");
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

	self.demoButtons = nil;
	lhScene = nil;

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