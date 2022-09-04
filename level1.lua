-----------------------------------------------------------------------------------------
--
-- level1.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

-- include Corona's "physics" library
local physics = require "physics"

--------------------------------------------
local musicTrack1
-- forward declarations and other locals
local screenW, screenH, halfW = display.actualContentWidth, display.actualContentHeight, display.contentCenterX

function scene:create( event )

	-- Called when the scene's view does not exist.
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.

	local sceneGroup = self.view

	-- We need physics started to add bodies, but we don't want the simulaton
	-- running until the scene is on the screen.
	physics.start()
	physics.pause()


	-- hero character
	-- have the background from top right, actual size

	local background = display.newImageRect( "scenery/trees.png", display.actualContentWidth, display.actualContentHeight )
	background.anchorX = 0
	background.anchorY = 0
	background.x = 0 + display.screenOriginX 
	background.y = -28 + display.screenOriginY
	
	-- make a character (off-screen), position it, and rotate slightly
	local hero = display.newImageRect( "knight/hero.png", 170, 140 )
	hero.x, hero.y = 10, -100
	hero.rotation = 0
	
	-- add physics to the hero
	physics.addBody( hero, "dynamic", { density=1.0, friction=0.1, bounce=0.3 } )

	local function dragHero( event )
 
		local hero = event.target
		local phase = event.phase
	 
		if ( "began" == phase ) then
			-- Set touch focus on the hero
			display.currentStage:setFocus( hero )
			 -- Store initial offset position
			 hero.touchOffsetX = event.x - hero.x
			 hero.touchOffsetY = event.y - hero.y
			elseif ( "moved" == phase ) then
				-- Move the hero to the new touch position
				hero.x = event.x - hero.touchOffsetX
				hero.y = event.y - hero.touchOffsetY
			
			elseif ( "ended" == phase or "cancelled" == phase ) then
				-- Release touch focus on the hero
				display.currentStage:setFocus( nil )
			end
			return true  -- Prevents touch propagation to underlying objects
	end
	hero:addEventListener( "touch", dragHero )

	
	-- create a grass object and add physics (with custom shape)
	local grass = display.newImageRect( "scenery/black grass.png", screenW, 30 )
	grass.anchorX = 0
	grass.anchorY = 1
	--  draw the grass at the very bottom of the screen
	grass.x, grass.y = display.screenOriginX, display.actualContentHeight + display.screenOriginY
	
	-- define a shape that's slightly shorter than image bounds
	local grassShape = { -halfW,-1, halfW,-1, halfW,1, -halfW,1 }
	physics.addBody( grass, "static", { friction=0.3, shape=grassShape } )
	
	-- all display objects groups
	sceneGroup:insert( background )
	sceneGroup:insert( grass)
	sceneGroup:insert( hero )
	
	-- in game music
	musicTrack1 = audio.loadStream( "audio/terror.wav")

end


function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
		-- 
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
		physics.start()
		audio.play( musicTrack1, { channel=2, loops=-1 } )
	end
end

function scene:hide( event )
	local sceneGroup = self.view
	
	local phase = event.phase
	
	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
		physics.stop()
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

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene