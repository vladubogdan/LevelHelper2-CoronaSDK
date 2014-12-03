-- This file was generated using LevelHelper 2
-- For more informations please visit http://www.gamedevhelper.com

module(...)

function getSpriteSheetData()

	local options = {
		-- array of tables representing each frame (required)
		frames = {

				--FRAME "mountain02.png"
				{
					x = 566,
					y = 1,
					width = 437,
					height = 116,
					sourceWidth = 437,
					sourceHeight = 116,
					sourceX = 0,
					sourceY = 0
				},


				--FRAME "bush.png"
				{
					x = 914,
					y = 169,
					width = 42,
					height = 32,
					sourceWidth = 42,
					sourceHeight = 32,
					sourceX = 0,
					sourceY = 0
				},


				--FRAME "mountain03.png"
				{
					x = 1,
					y = 1,
					width = 563,
					height = 139,
					sourceWidth = 563,
					sourceHeight = 139,
					sourceX = 0,
					sourceY = 0
				},


				--FRAME "brick.png"
				{
					x = 848,
					y = 119,
					width = 64,
					height = 64,
					sourceWidth = 64,
					sourceHeight = 64,
					sourceX = 0,
					sourceY = 0
				},


				--FRAME "mushrooms.png"
				{
					x = 914,
					y = 119,
					width = 62,
					height = 48,
					sourceWidth = 62,
					sourceHeight = 48,
					sourceX = 2,
					sourceY = 3
				},


				--FRAME "smallTreeDark.png"
				{
					x = 873,
					y = 185,
					width = 9,
					height = 15,
					sourceWidth = 9,
					sourceHeight = 15,
					sourceX = 0,
					sourceY = 0
				},


				--FRAME "clouds.png"
				{
					x = 957,
					y = 169,
					width = 41,
					height = 26,
					sourceWidth = 41,
					sourceHeight = 26,
					sourceX = 0,
					sourceY = 0
				},


				--FRAME "monkey.png"
				{
					x = 848,
					y = 185,
					width = 23,
					height = 39,
					sourceWidth = 23,
					sourceHeight = 39,
					sourceX = 5,
					sourceY = 2
				},


				--FRAME "mountain01.png"
				{
					x = 566,
					y = 119,
					width = 280,
					height = 91,
					sourceWidth = 280,
					sourceHeight = 91,
					sourceX = 0,
					sourceY = 0
				},


				--FRAME "smallTree.png"
				{
					x = 873,
					y = 202,
					width = 9,
					height = 15,
					sourceWidth = 9,
					sourceHeight = 15,
					sourceX = 0,
					sourceY = 0
				},

		},
		sheetContentWidth = 1003,
		sheetContentHeight = 224
	}
	return options
end

function getFrameNamesMap()
	local frameIndexes =
	{
		["mountain02.png"] = 1,
		["bush.png"] = 2,
		["mountain03.png"] = 3,
		["brick.png"] = 4,
		["mushrooms.png"] = 5,
		["smallTreeDark.png"] = 6,
		["clouds.png"] = 7,
		["monkey.png"] = 8,
		["mountain01.png"] = 9,
		["smallTree.png"] = 10,
	}
	return frameIndexes;
end

function getFramesCount()
	return 10;
end

function getFrameForName(name)
	return getFrameNamesMap()[name];
end
