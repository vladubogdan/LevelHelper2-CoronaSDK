-----------------------------------------------------------------------------------------
--
-- myScene.lua
--
-----------------------------------------------------------------------------------------
local widget = require( "widget" )
local composer = require( "composer" )
local scene = composer.newScene();

local physics = require("physics")
physics.setDrawMode( "hybrid" )
	
--------------------------------------------
local LHScene =  require("LevelHelper2-API.LHScene");
local lhScene = nil;--forward declaration of lhScene in order to access it everywhere in this file
--------------------------------------------
--------------------------------------------

function scene:create( event )
	local sceneGroup = scene.view
end

function scene:show( event )
	
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		
		--1 -> load your level file from the published subfolder (dont forget to publish the level first)
		lhScene = LHScene:initWithContentOfFile("LH2-Published/example.json");
	
		--2 - > add your new loaded level to the scene group
		sceneGroup:insert(lhScene);
	
		
		local welcomeOptions = 
		{		    
		    text = "Welcome to",     
		    x = 480,
		    y = 540,
		    width = display.contentWidth - 20,
		    height= display.contentHeight,
		    font = native.systemFontBold,   
		    fontSize = 20,
		    align = "center"  --new alignment parameter
		}

		local welcomeText = display.newText( welcomeOptions);
		welcomeText:setFillColor( 0, 0, 0 )
	
		local uiNode = lhScene:getUINode();
		uiNode:insert( welcomeText );
	
		local lhOptions = 
		{		    
		    text = "LevelHelper 2",     
		    x = 480,
		    y = 580,
		    width = display.contentWidth - 20,
		    height= display.contentHeight,
		    font = native.systemFontBold,   
		    fontSize = 40,
		    align = "center"  --new alignment parameter
		}

		local lhText = display.newText( lhOptions);
		lhText:setFillColor( 0, 0, 0 )
	
		local uiNode = lhScene:getUINode();
		uiNode:insert( lhText );

		local infOptions = 
		{		    
		    text = "Run the DEMOS project for examples.\nCheck myScene.lua to learn how to load a level.\nVisit www.gamedevhelper.com for more learn resources.",     
		    x = 480,
		    y = 640,
		    width = display.contentWidth - 20,
		    height= display.contentHeight,
		    font = native.systemFontBold,   
		    fontSize = 20,
		    align = "center"  --new alignment parameter
		}

		local infText = display.newText( infOptions);
		infText:setFillColor( 0, 0, 0 )
	
		local uiNode = lhScene:getUINode();
		uiNode:insert( infText );



	-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		
		local sceneGroup = scene.view

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
		
		--3 remove the level from memory when you are changing to a new scene
		lhScene:removeSelf();
		lhScene = nil;
		
		physics.stop();
		
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
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