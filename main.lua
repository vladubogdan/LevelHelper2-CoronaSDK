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
composer.gotoScene( "myScene" )
