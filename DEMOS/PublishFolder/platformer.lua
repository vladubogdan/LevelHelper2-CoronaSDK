-- This file was generated using LevelHelper 2
-- For more informations please visit http://www.gamedevhelper.com

module(...)

function getSpriteSheetData()

	local options = {
		-- array of tables representing each frame (required)
		frames = {

				--FRAME "monkey"
				{
					x = 1695,
					y = 370,
					width = 46,
					height = 77,
					sourceWidth = 46,
					sourceHeight = 77,
					sourceX = 9,
					sourceY = 4
				},


				--FRAME "mountain02"
				{
					x = 1131,
					y = 2,
					width = 874,
					height = 232,
					sourceWidth = 874,
					sourceHeight = 232,
					sourceX = 0,
					sourceY = 0
				},


				--FRAME "mushrooms"
				{
					x = 1828,
					y = 238,
					width = 123,
					height = 96,
					sourceWidth = 123,
					sourceHeight = 96,
					sourceX = 4,
					sourceY = 6
				},


				--FRAME "mountain01"
				{
					x = 1131,
					y = 238,
					width = 560,
					height = 182,
					sourceWidth = 560,
					sourceHeight = 182,
					sourceX = 0,
					sourceY = 0
				},


				--FRAME "clouds"
				{
					x = 1914,
					y = 338,
					width = 82,
					height = 53,
					sourceWidth = 82,
					sourceHeight = 53,
					sourceX = 0,
					sourceY = 0
				},


				--FRAME "bush"
				{
					x = 1827,
					y = 338,
					width = 83,
					height = 65,
					sourceWidth = 83,
					sourceHeight = 65,
					sourceX = 0,
					sourceY = 0
				},


				--FRAME "brick"
				{
					x = 1695,
					y = 238,
					width = 128,
					height = 128,
					sourceWidth = 128,
					sourceHeight = 128,
					sourceX = 0,
					sourceY = 0
				},


				--FRAME "mountain03"
				{
					x = 2,
					y = 2,
					width = 1125,
					height = 277,
					sourceWidth = 1125,
					sourceHeight = 277,
					sourceX = 0,
					sourceY = 0
				},


				--FRAME "smallTreeDark"
				{
					x = 1745,
					y = 370,
					width = 18,
					height = 29,
					sourceWidth = 18,
					sourceHeight = 29,
					sourceX = 0,
					sourceY = 0
				},


				--FRAME "smallTree"
				{
					x = 1745,
					y = 403,
					width = 18,
					height = 29,
					sourceWidth = 18,
					sourceHeight = 29,
					sourceX = 0,
					sourceY = 0
				},

		},
		sheetContentWidth = 2006,
		sheetContentHeight = 449
	}
	return options
end

function getFrameNamesMap()
	local frameIndexes =
	{
		["monkey"] = 1,
		["mountain02"] = 2,
		["mushrooms"] = 3,
		["mountain01"] = 4,
		["clouds"] = 5,
		["bush"] = 6,
		["brick"] = 7,
		["mountain03"] = 8,
		["smallTreeDark"] = 9,
		["smallTree"] = 10,
	}
	return frameIndexes;
end

function getFramesCount()
	return 10;
end

function getFrameForName(name)
	return getFrameNamesMap()[name];
end
