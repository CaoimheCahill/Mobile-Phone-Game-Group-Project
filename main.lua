-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- hide the status bar
display.setStatusBar( display.HiddenStatusBar )

local composer = require "composer"

-- load menu screen
composer.gotoScene( "menu" )

-- Reserve channel 1 for menu bg music
audio.reserveChannels( 1 )
audio.setVolume( 0.2, { channel=1 } )
-- reserve channel 2 for in-game
audio.reserveChannels( 2 )
audio.setVolume( 0.1, { channel=2 } )

-- add virtual joysticks to mobile 
system.activate("multitouch")
if isMobile or isSimulator then
	local vjoy = require( "Assets/vjoy" )
	local stick = vjoy.newStick()
	stick.x, stick.y = 128, display.contentHeight - 128
	local button = vjoy.newButton()
	button.x, button.y = display.contentWidth - 128, display.contentHeight - 128
end