-----------------------------------------------------------------------------------------
--
-- complexPhysicsShapes.lua
--
-----------------------------------------------------------------------------------------
local widget = require( "widget" )
local composer = require( "composer" )
local scene = composer.newScene();

local physics = require("physics")
physics.setDrawMode( "hybrid" )
physics.start();
	
--------------------------------------------
local LHScene =  require("LevelHelper2-API.LHScene");
local lhScene = nil;--forward declaration of lhScene in order to access it everywhere in this file
--------------------------------------------
--------------------------------------------
function scene:create( event )
	local sceneGroup = scene.view
end

function scene:didBeginContact(event)
	
	local contactInfo = event.object;
	
	print("did BEGIN contact with info......................................................");
	print("Node A: " .. tostring(contactInfo.nodeA));
	print("Node A Shape name: " .. contactInfo.nodeAShapeName);
	print("Node A Shape id: " .. contactInfo.nodeAShapeID);
	print("Node B: " .. tostring(contactInfo.nodeB));
	print("Node B Shape name: " .. contactInfo.nodeBShapeName);
	print("Node B Shape id: " .. contactInfo.nodeBShapeID);
	
end

function scene:didEndContact(event)
	
	local contactInfo = event.object;
	
	print("did END contact with info......................................................");
	print("Node A: " .. tostring(contactInfo.nodeA));
	print("Node A Shape name: " .. contactInfo.nodeAShapeName);
	print("Node A Shape id: " .. contactInfo.nodeAShapeID);
	print("Node B: " .. tostring(contactInfo.nodeB));
	print("Node B Shape name: " .. contactInfo.nodeBShapeName);
	print("Node B Shape id: " .. contactInfo.nodeBShapeID);
	
end


function scene:show( event )
	
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		
		lhScene = LHScene:initWithContentOfFile("PublishFolder/complexPhysicsShapes.json");
	
		sceneGroup:insert(lhScene);
	
		local demoHelpString = "COMPLEX PHYSICS SHAPES DEMO";
		
		local textOptions = 
		{		    
		    text = demoHelpString,     
		    x = 480,
		    y = 640,
		    width = display.contentWidth - 20,
		    height= display.contentHeight,
		    font = native.systemFontBold,   
		    fontSize = 18,
		    align = "center"  --new alignment parameter
		}

		local myText = display.newText( textOptions);
		myText:setFillColor( 0, 0, 0 )
	
		local uiNode = lhScene:getUINode();
		uiNode:insert( myText );
		
		
		self.demoButtons = require("demoButtons");
		self.demoButtons:createButtonsWithComposerScene(self, "complexPhysicsShapes");
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
		-- 
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
		physics.start()
	
		lhScene:enableCollisionHandling();
		lhScene:addEventListener("didBeginContact", scene);
		lhScene:addEventListener("didEndContact", scene);
		
	end
end

function scene:hide( event )
	
	local sceneGroup = self.view
	
	local phase = event.phase
	
	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		self.demoButtons = nil;
		
		lhScene:removeSelf();
		lhScene = nil;
		--
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