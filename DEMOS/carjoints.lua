-----------------------------------------------------------------------------------------
--
-- createSpritesByCode.lua
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

local destroyJoint = true;

function scene:touch( event )
	
	if ( event.phase == "began" ) then
		
		print( "did touch - destroy front tyre joint")
		
		if(destroyJoint)then
			local frontTyreJoint = lhScene:getChildNodeWithUniqueName("frontTyreRevoluteJoint");
			
			print("found tyre joint " .. tostring(frontTyreJoint));
			
			if(frontTyreJoint ~= nil) then
				
				print("should remove joint");
				
				frontTyreJoint:removeSelf();
				
				destroyJoint = false;
			end
		else
		
			local frontTyre = lhScene:getChildNodeWithUniqueName("frontTyre");
			
			print("found tyre " .. tostring(frontTyre));
			
			if(frontTyre ~= nil) then
		
				print("should remove front tyre");				
				
				frontTyre:removeSelf();
				
				destroyJoint = true;
			end

			local carBody = lhScene:getChildNodeWithUniqueName("carBody");
			
			print("car body " .. tostring(carBody));
			
			if(carBody ~= nil) then
		
				print("should remove car body");				
				
				carBody:removeSelf();
				
				destroyJoint = true;
			end

			
		end
	end
end

function scene:show( event )
	
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		
		lhScene = LHScene:initWithContentOfFile("PublishFolder/car_joints.json");
	
		sceneGroup:insert(lhScene);
		
		local demoHelpString = "CAR DEMO - REVOLUTE JOINTS\n.";
		
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
		self.demoButtons:createButtonsWithComposerScene(self, "carjoints");
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
		-- 
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
		physics.start()
		
		Runtime:addEventListener( "touch", scene )
			
		local sceneGroup = scene.view
		
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
		
		Runtime:removeEventListener( "touch", scene )
	end	
	
end

function scene:destroy( event )

	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
	local sceneGroup = self.view
	
	Runtime:removeEventListener( "touch", scene )
	
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