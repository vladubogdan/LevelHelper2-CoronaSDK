-- This file was generated using LevelHelper 2
-- For more informations please visit http://www.gamedevhelper.com

module(...)

function getSpriteSheetData()

	local options = {
		-- array of tables representing each frame (required)
		frames = {

				--FRAME "carTyre"
				{
					x = 134,
					y = 3,
					width = 43,
					height = 43,
					sourceWidth = 43,
					sourceHeight = 43,
					sourceX = 2,
					sourceY = 2
				},


				--FRAME "wood"
				{
					x = 2,
					y = 2,
					width = 128,
					height = 32,
					sourceWidth = 128,
					sourceHeight = 32,
					sourceX = 0,
					sourceY = 0
				},


				--FRAME "carBody"
				{
					x = 2,
					y = 49,
					width = 168,
					height = 68,
					sourceWidth = 168,
					sourceHeight = 68,
					sourceX = 5,
					sourceY = 7
				},

		},
		sheetContentWidth = 178,
		sheetContentHeight = 118
	}
	return options
end

function getPhysicsData()
	local physics =
	{
		["carTyre"] = {gravityScale=1,shapes={{name="smallerCircleShape",mask=65535,sensor=false,category=1,shapeID=4,restitution=0,center="{0.000000, 0.000000}",density=0.1,friction=0.2,radius=18.3507}},allowSleep=true,bullet=false,type=2,angularDamping=0,angularVelocity=0,linearVelocity="{0.000000, 0.000000}",linearDamping=0,fixedRotation=false},
		["wood"] = {bullet=false,linearVelocity="{0.000000, 0.000000}",type=0,gravityScale=1,angularDamping=0,fixedRotation=false,linearDamping=0,shapes={{category=1,restitution=0,sensor=false,name="UntitledConcaveShape",friction=0.2,shapeID=0,mask=65535,density=0.1,points={{"{-27, -16}","{61, -15}","{62.5, -12.5}","{63.5, -7}","{63, 15.5}","{-34.5, 15.5}","{-27.5, -15.5}"},{"{-64, 5}","{-64, -13.5}","{-63, -15}","{-27.5, -15.5}","{-34.5, 15.5}","{-61.5, 14}","{-63, 12.5}"}}}},allowSleep=true,angularVelocity=0},
		["carBody"] = {bullet=false,fixedRotation=false,shapes={{friction=0.2,category=1,points={{"{30.5, 18.5}","{57.09765625, -5.7890625}","{64.5, -4}","{76, 4}","{83, 11}","{83, 28.5}","{82.5, 30}","{80, 32.5}"},{"{28, -15.5}","{43, -12.5}","{57.09765625, -5.7890625}","{30.5, 18.5}","{18.5, -3.5}","{18, -15.5}"},{"{30.5, 18.5}","{80, 32.5}","{-79, 33}","{-45, 15.5}"},{"{-36, -33}","{-35.5, -33.5}","{6.5, -33.5}","{18, -15.5}","{18.5, -3.5}","{-38, -6}","{-45.5, -15.5}"},{"{-45.5, -15.5}","{-38, -6}","{-45, 15.5}"},{"{-53.5, -15.5}","{-45.5, -15.5}","{-45, 15.5}"},{"{-82.5, -3}","{-53.5, -15.5}","{-45, 15.5}"},{"{-82.5, -3}","{-45, 15.5}","{-79, 33}"},{"{-83.5, -0.5}","{-82.5, -3}","{-79, 33}"},{"{-83.5, 27.5}","{-83.5, -0.5}","{-79, 33}"},{"{-82.5, 30.5}","{-83.5, 27.5}","{-79, 33}"},{"{-80.5, 32.5}","{-82.5, 30.5}","{-79, 33}"}},name="complexShapeWithHole",sensor=false,mask=65535,shapeID=3,density=0.1,restitution=0},{friction=0.2,center="{65.666016, 2.742188}",category=1,radius=18.89075,name="circleShape",sensor=false,mask=65535,shapeID=2,density=0.1,restitution=0}},type=2,allowSleep=true,gravityScale=1,linearDamping=0,linearVelocity="{0.000000, 0.000000}",angularVelocity=0,angularDamping=0},
	}
	return physics;
end


function getFrameNamesMap()
	local frameIndexes =
	{
		["carTyre"] = 1,
		["wood"] = 2,
		["carBody"] = 3,
	}
	return frameIndexes;
end

function getFramesCount()
	return 3;
end

function getFrameForName(name)
	return getFrameNamesMap()[name];
end
