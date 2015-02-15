-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- hide the status bar
display.setStatusBar( display.HiddenStatusBar )

-- include the Corona "composer" module
local composer = require "composer"

--demo scenes - use buttons to switch to other demo scenes
-- composer.gotoScene( "complexPhysicsShapes" )
composer.gotoScene( "moveOnPathByCode" )