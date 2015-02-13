-- This file was generated using LevelHelper 2
-- For more informations please visit http://www.gamedevhelper.com

module(...)

function getSpriteSheetData()

	local options = {
		-- array of tables representing each frame (required)
		frames = {

				--FRAME "Gun"
				{
					x = 2,
					y = 218,
					width = 69,
					height = 44,
					sourceWidth = 69,
					sourceHeight = 44,
					sourceX = 0,
					sourceY = 0
				},


				--FRAME "Grenade"
				{
					x = 75,
					y = 218,
					width = 38,
					height = 43,
					sourceWidth = 38,
					sourceHeight = 43,
					sourceX = 0,
					sourceY = 0
				},


				--FRAME "HeadNormal"
				{
					x = 2,
					y = 107,
					width = 113,
					height = 101,
					sourceWidth = 113,
					sourceHeight = 101,
					sourceX = 0,
					sourceY = 0
				},


				--FRAME "hand_L"
				{
					x = 102,
					y = 264,
					width = 26,
					height = 25,
					sourceWidth = 26,
					sourceHeight = 25,
					sourceX = 0,
					sourceY = 0
				},


				--FRAME "HeadHurt"
				{
					x = 2,
					y = 2,
					width = 114,
					height = 101,
					sourceWidth = 114,
					sourceHeight = 101,
					sourceX = 0,
					sourceY = 0
				},


				--FRAME "foot_R"
				{
					x = 234,
					y = 138,
					width = 48,
					height = 23,
					sourceWidth = 48,
					sourceHeight = 23,
					sourceX = 0,
					sourceY = 0
				},


				--FRAME "HeadHappy"
				{
					x = 120,
					y = 2,
					width = 113,
					height = 106,
					sourceWidth = 113,
					sourceHeight = 106,
					sourceX = 1,
					sourceY = 0
				},


				--FRAME "Body"
				{
					x = 237,
					y = 3,
					width = 50,
					height = 66,
					sourceWidth = 50,
					sourceHeight = 66,
					sourceX = 0,
					sourceY = 1
				},


				--FRAME "hand_R"
				{
					x = 2,
					y = 265,
					width = 30,
					height = 27,
					sourceWidth = 30,
					sourceHeight = 27,
					sourceX = 0,
					sourceY = 0
				},


				--FRAME "lowerArm_L"
				{
					x = 236,
					y = 244,
					width = 20,
					height = 31,
					sourceWidth = 20,
					sourceHeight = 31,
					sourceX = 0,
					sourceY = 0
				},


				--FRAME "footBack_L"
				{
					x = 232,
					y = 218,
					width = 42,
					height = 23,
					sourceWidth = 42,
					sourceHeight = 23,
					sourceX = 0,
					sourceY = 0
				},


				--FRAME "HandKnife"
				{
					x = 36,
					y = 265,
					width = 62,
					height = 26,
					sourceWidth = 62,
					sourceHeight = 26,
					sourceX = 0,
					sourceY = 0
				},


				--FRAME "footBack_R"
				{
					x = 234,
					y = 191,
					width = 43,
					height = 23,
					sourceWidth = 43,
					sourceHeight = 23,
					sourceX = 0,
					sourceY = 0
				},


				--FRAME "lowerLeg_L"
				{
					x = 132,
					y = 256,
					width = 23,
					height = 35,
					sourceWidth = 23,
					sourceHeight = 35,
					sourceX = 0,
					sourceY = 0
				},


				--FRAME "HeadBack"
				{
					x = 119,
					y = 112,
					width = 111,
					height = 89,
					sourceWidth = 111,
					sourceHeight = 89,
					sourceX = 0,
					sourceY = 0
				},


				--FRAME "lowerArm_R"
				{
					x = 211,
					y = 244,
					width = 21,
					height = 32,
					sourceWidth = 21,
					sourceHeight = 32,
					sourceX = 0,
					sourceY = 0
				},


				--FRAME "HandOpen"
				{
					x = 195,
					y = 205,
					width = 33,
					height = 32,
					sourceWidth = 33,
					sourceHeight = 32,
					sourceX = 0,
					sourceY = 0
				},


				--FRAME "upperArm_L"
				{
					x = 144,
					y = 218,
					width = 21,
					height = 34,
					sourceWidth = 21,
					sourceHeight = 34,
					sourceX = 0,
					sourceY = 0
				},


				--FRAME "upperLeg_L"
				{
					x = 184,
					y = 254,
					width = 23,
					height = 33,
					sourceWidth = 23,
					sourceHeight = 33,
					sourceX = 0,
					sourceY = 0
				},


				--FRAME "upperArm_R"
				{
					x = 159,
					y = 255,
					width = 21,
					height = 33,
					sourceWidth = 21,
					sourceHeight = 33,
					sourceX = 0,
					sourceY = 0
				},


				--FRAME "upperLeg_R"
				{
					x = 169,
					y = 218,
					width = 23,
					height = 33,
					sourceWidth = 23,
					sourceHeight = 33,
					sourceX = 0,
					sourceY = 0
				},


				--FRAME "lowerLeg_R"
				{
					x = 117,
					y = 218,
					width = 23,
					height = 35,
					sourceWidth = 23,
					sourceHeight = 35,
					sourceX = 0,
					sourceY = 0
				},


				--FRAME "BodyBack"
				{
					x = 237,
					y = 73,
					width = 50,
					height = 62,
					sourceWidth = 50,
					sourceHeight = 62,
					sourceX = 0,
					sourceY = 1
				},


				--FRAME "foot_L"
				{
					x = 234,
					y = 165,
					width = 48,
					height = 23,
					sourceWidth = 48,
					sourceHeight = 23,
					sourceX = 0,
					sourceY = 0
				},

		},
		sheetContentWidth = 288,
		sheetContentHeight = 293
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
		["Gun"] = 1,
		["Grenade"] = 2,
		["HeadNormal"] = 3,
		["hand_L"] = 4,
		["HeadHurt"] = 5,
		["foot_R"] = 6,
		["HeadHappy"] = 7,
		["Body"] = 8,
		["hand_R"] = 9,
		["lowerArm_L"] = 10,
		["footBack_L"] = 11,
		["HandKnife"] = 12,
		["footBack_R"] = 13,
		["lowerLeg_L"] = 14,
		["HeadBack"] = 15,
		["lowerArm_R"] = 16,
		["HandOpen"] = 17,
		["upperArm_L"] = 18,
		["upperLeg_L"] = 19,
		["upperArm_R"] = 20,
		["upperLeg_R"] = 21,
		["lowerLeg_R"] = 22,
		["BodyBack"] = 23,
		["foot_L"] = 24,
	}
	return frameIndexes;
end

function getFramesCount()
	return 24;
end

function getFrameForName(name)
	return getFrameNamesMap()[name];
end
