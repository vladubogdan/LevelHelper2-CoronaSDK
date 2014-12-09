-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- hide the status bar
display.setStatusBar( display.HiddenStatusBar )

-- include the Corona "composer" module
local composer = require "composer"


--empty scene prepared for LevelHelper 2 use (check help text inside myScene.lua)
--composer.gotoScene( "myScene" )

--demo scenes - use buttons to switch to other demo scenes
composer.gotoScene( "demo.cameraFollow" )