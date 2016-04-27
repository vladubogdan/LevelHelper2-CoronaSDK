local widget = require( "widget" )
local composer = require( "composer" )

local availableDemoScenes = {}


availableDemoScenes[#availableDemoScenes+1] = {name= "carjoints", scene= "carjoints"}
availableDemoScenes[#availableDemoScenes+1] = {name= "assetLoadByCode", scene= "assetLoadByCode"}
availableDemoScenes[#availableDemoScenes+1] = {name= "duplicateNodesInScene", scene= "duplicateNodesInScene"}
availableDemoScenes[#availableDemoScenes+1] = {name= "createSpritesByCode", scene= "createSpritesByCode"}
availableDemoScenes[#availableDemoScenes+1] = {name= "moveOnPathByCode", scene= "moveOnPathByCode"}
availableDemoScenes[#availableDemoScenes+1] = {name= "skeletalCharacter", scene= "skeletalCharacter"}
availableDemoScenes[#availableDemoScenes+1] = {name= "cameraFollow", scene= "cameraFollow"}
availableDemoScenes[#availableDemoScenes+1] = {name= "simpleNonSpriteSheetAnimation", scene= "simpleNonSpriteSheetAnimation"}
availableDemoScenes[#availableDemoScenes+1] = {name= "complexPhysicsShapes", scene= "complexPhysicsShapes"}

local DemoButtons = {}
function DemoButtons:createButtonsWithComposerScene(object, _curSceneName_)

	self.currentSceneName = _curSceneName_;
	
	local sceneGroup = object.view

	local previousButton = widget.newButton
	{
	    label = "Previous",
	    onEvent = function(event) self:handlePreviousButtonEvent(event); end,
	    emboss = false,
	    --properties for a rounded rectangle button...
	    shape="roundedRect",
	    width = 100,
	    height = 20,
	    cornerRadius = 0,
	    fillColor = { default={ 1, 0, 0, 1 }, over={ 1, 0.1, 0.7, 0.4 } },
	    strokeColor = { default={ 1, 0.4, 0, 1 }, over={ 0.8, 0.8, 1, 1 } },
	    strokeWidth = 1
	}
	previousButton.x = display.contentCenterX - 120
	previousButton.y = display.screenOriginY + 20
	sceneGroup:insert(previousButton);

	local restartButton = widget.newButton
	{
	    label = "Restart",
	    onEvent = function(event)  self:handleRestartButtonEvent(event); end,
	    emboss = false,
	    --properties for a rounded rectangle button...
	    shape="roundedRect",
	    width = 100,
	    height = 20,
	    cornerRadius = 0,
	    fillColor = { default={ 1, 0, 0, 1 }, over={ 1, 0.1, 0.7, 0.4 } },
	    strokeColor = { default={ 1, 0.4, 0, 1 }, over={ 0.8, 0.8, 1, 1 } },
	    strokeWidth = 1
	}
	restartButton.x = display.contentCenterX
	restartButton.y = display.screenOriginY + 20
	sceneGroup:insert(restartButton);

	local nextButton = widget.newButton
	{
	    label = "Next",
	    onEvent = function(event)  self:handleNextButtonEvent(event); end,
	    emboss = false,
	    --properties for a rounded rectangle button...
	    shape="roundedRect",
	    width = 100,
	    height = 20,
	    cornerRadius = 0,
	    fillColor = { default={ 1, 0, 0, 1 }, over={ 1, 0.1, 0.7, 0.4 } },
	    strokeColor = { default={ 1, 0.4, 0, 1 }, over={ 0.8, 0.8, 1, 1 } },
	    strokeWidth = 1
	}
	nextButton.x = display.contentCenterX + 120
	nextButton.y = display.screenOriginY + 20
	sceneGroup:insert(nextButton);
	
end
	
	
function DemoButtons:handleRestartButtonEvent( event )

    if ( "ended" == event.phase ) then
        
        for i = 1, #availableDemoScenes do
        	local v = availableDemoScenes[i];
        	if v.name == self.currentSceneName then
        		print( "Restart " .. v.name  .. " scene " .. v.scene);
  				composer.gotoScene( v.scene );
        	end
        end
    end
end

function DemoButtons:handlePreviousButtonEvent( event )

    if ( "ended" == event.phase ) then
        
        local prevV = nil;
        for i = 1, #availableDemoScenes do
        	local v = availableDemoScenes[i];
        	if v.name == self.currentSceneName then
        		if(prevV ~= nil) then
        			print( "Load Previous Scene: " .. prevV.name .. " scene " .. prevV.scene );
  					composer.gotoScene( prevV.scene );
  					return
  				end
    		end
    		prevV = v;
    	end
    end
end

function DemoButtons:handleNextButtonEvent( event )

    if ( "ended" == event.phase ) then
        
        local found = false;
        for i = 1, #availableDemoScenes do
        	local v = availableDemoScenes[i];
        	
        	if found == true then
        		print( "Load Next Scene: " .. v.name .. " scene " .. v.scene );
  				composer.gotoScene( v.scene );
  				return 
        	end
        	
        	if v.name == self.currentSceneName then
        		found = true;
    		end
    	end
        
    end
end

return DemoButtons;
