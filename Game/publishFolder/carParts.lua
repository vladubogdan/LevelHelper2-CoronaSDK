-- This file was generated using LevelHelper 2
-- For more informations please visit http://www.gamedevhelper.com

module(...)

function getSpriteSheetData()

	local options = {
		-- array of tables representing each frame (required)
		frames = {

				--FRAME "carTyre"
				{
					x = 67,
					y = 1,
					width = 21,
					height = 21,
					sourceWidth = 21,
					sourceHeight = 21,
					sourceX = 1,
					sourceY = 1
				},


				--FRAME "carBody"
				{
					x = 1,
					y = 25,
					width = 84,
					height = 34,
					sourceWidth = 84,
					sourceHeight = 34,
					sourceX = 3,
					sourceY = 4
				},


				--FRAME "wood"
				{
					x = 1,
					y = 1,
					width = 64,
					height = 16,
					sourceWidth = 64,
					sourceHeight = 16,
					sourceX = 0,
					sourceY = 0
				},

		},
		sheetContentWidth = 89,
		sheetContentHeight = 59
	}
	return options
end

function getFrameNamesMap()
	local frameIndexes =
	{
		["carTyre"] = 1,
		["carBody"] = 2,
		["wood"] = 3,
	}
	return frameIndexes;
end

function getFramesCount()
	return 3;
end

function getFrameForName(name)
	return getFrameNamesMap()[name];
end
