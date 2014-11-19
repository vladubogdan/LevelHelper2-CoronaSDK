-- This file was generated using LevelHelper 2
-- For more informations please visit http://www.gamedevhelper.com

module(...)

function getSpriteSheetData()

	local options = {
		-- array of tables representing each frame (required)
		frames = {

				--FRAME "gear-03"
				{
					x = 35,
					y = 65,
					width = 5,
					height = 5,
					sourceWidth = 5,
					sourceHeight = 5,
					sourceX = 0,
					sourceY = 0
				},


				--FRAME "gear-01"
				{
					x = 1,
					y = 39,
					width = 32,
					height = 32,
					sourceWidth = 32,
					sourceHeight = 32,
					sourceX = 0,
					sourceY = 0
				},


				--FRAME "gear-04"
				{
					x = 1,
					y = 1,
					width = 60,
					height = 36,
					sourceWidth = 60,
					sourceHeight = 36,
					sourceX = 0,
					sourceY = 0
				},


				--FRAME "gear-02"
				{
					x = 35,
					y = 39,
					width = 24,
					height = 24,
					sourceWidth = 24,
					sourceHeight = 24,
					sourceX = 0,
					sourceY = 0
				},

		},
		sheetContentWidth = 61,
		sheetContentHeight = 71
	}
	return options
end

function getFrameNamesMap()
	local frameIndexes =
	{
		["gear-03"] = 1,
		["gear-01"] = 2,
		["gear-04"] = 3,
		["gear-02"] = 4,
	}
	return frameIndexes;
end

function getFramesCount()
	return 4;
end

function getFrameForName(name)
	return getFrameNamesMap()[name];
end
