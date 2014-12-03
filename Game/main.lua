-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- hide the status bar
display.setStatusBar( display.HiddenStatusBar )

-- include the Corona "composer" module
local composer = require "composer"

-- load menu screen
-- composer.gotoScene( "demo.basicLayout" )
-- composer.gotoScene( "demo.cameraFollow" )
composer.gotoScene( "demo.parallaxDemo" )
-- composer.gotoScene( "demo.simpleAnimationExample" )
-- composer.gotoScene( "demo.introductionScene" )