-- This file was generated using LevelHelper 2
-- For more informations please visit http://www.gamedevhelper.com

module(...)

function getSpriteSheetData()

	local options = {
		-- array of tables representing each frame (required)
		frames = {

				--FRAME "64x64"
				{
					x = 2,
					y = 2,
					width = 32,
					height = 32,
					sourceWidth = 32,
					sourceHeight = 32,
					sourceX = 0,
					sourceY = 0
				},


				--FRAME "64x64-green"
				{
					x = 2,
					y = 38,
					width = 32,
					height = 32,
					sourceWidth = 32,
					sourceHeight = 32,
					sourceX = 0,
					sourceY = 0
				},

		},
		sheetContentWidth = 36,
		sheetContentHeight = 72
	}
	return options
end

function getPhysicsData()
	local physics =
	{
	}
	return physics;
end


function getFrameNamesMap()
	local frameIndexes =
	{
		["64x64"] = 1,
		["64x64-green"] = 2,
	}
	return frameIndexes;
end

function getFramesCount()
	return 2;
end

function getFrameForName(name)
	return getFrameNamesMap()[name];
end
