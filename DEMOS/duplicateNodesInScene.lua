-----------------------------------------------------------------------------------------
--
-- duplicateNodesInScene.lua
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

local nameIdx = 1;

function scene:touch( event )
	
	if ( event.phase == "began" ) then
		
		print( "did touch - creating sprite")
		
		local nodesNamesInScene = {"carTyre", "Officer", "wood"}
		
		local newNodeObj = lhScene:cloneNodeWithUniqueName(nodesNamesInScene[nameIdx]);
			
		newNodeObj.x = event.x;
		newNodeObj.y = event.y;
		
		print("did create node obj " .. tostring(newNodeObj));
		
		nameIdx = nameIdx + 1;
		if(nameIdx > #nodesNamesInScene)then
			nameIdx = 1;
		end
		
	end
end

function scene:didFinishedRepetitionOnAnimation(event)
	
	local animationObject = event.object;
	
	print("didFinishedRepetitionOnAnimation info......................................................");
	print("Animation name: " .. tostring(animationObject:getName()));
	print("Animation object: " .. tostring(animationObject:getNode():getUniqueName()));
	--look inside LHAnimation for more methods
end

function scene:didFinishedPlayingAnimation(event)
	
	local animationObject = event.object;
	
	print("didFinishedPlayingAnimation info......................................................");
	print("Animation name: " .. tostring(animationObject:getName()));
	print("Animation object: " .. tostring(animationObject:getNode():getUniqueName()));
	--look inside LHAnimation for more methods
end

function scene:show( event )
	
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		
		lhScene = LHScene:initWithContentOfFile("PublishFolder/duplicateNodesInScene.json");
	
		sceneGroup:insert(lhScene);
		
		
		lhScene:addEventListener("didFinishedRepetitionOnAnimation", scene);
		lhScene:addEventListener("didFinishedPlayingAnimation", scene);
		
		
		local objectsWithTagTable = lhScene:getChildrenWithTags({"UPPER_LEG"}, false);
		print("objects only with tag UPPER_LEG count: " .. tostring(#objectsWithTagTable) .. " (should return 2)");
		
		local objectsWithTagTable = lhScene:getChildrenWithTags({"UPPER_LEG", "LOWER_LEG"}, true);
		print("objects only with tag UPPER_LEG or LOWER_LEG count: " .. tostring(#objectsWithTagTable) .. " (should return 4)");
		
		local objectsWithTagTable = lhScene:getChildrenWithTags({"UPPER_LEG", "LOWER_LEG"}, false);
		print("objects only with tag UPPER_LEG and LOWER_LEG count: " .. tostring(#objectsWithTagTable) .. " (should return 0)");
			
		
		local demoHelpString = "DUPLICATE NODES IN SCENE BY CODE DEMO\n.";
		
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
		self.demoButtons:createButtonsWithComposerScene(self, "duplicateNodesInScene");
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