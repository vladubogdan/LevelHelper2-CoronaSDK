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
		["carTyre"] = {angularDamping=0,linearDamping=0,allowSleep=true,fixedRotation=false,linearVelocity="{0.000000, 0.000000}",gravityScale=1,bullet=false,type=2,angularVelocity=0,shapes={{friction=0.2,radius=18.3507,density=0.1,restitution=0,center="{0.000000, 0.000000}",sensor=false,name="smallerCircleShape",shapeID=4,category=1,mask=65535}}},
		["wood"] = {gravityScale=1,bullet=false,angularVelocity=0,linearVelocity="{0.000000, 0.000000}",allowSleep=true,type=0,fixedRotation=false,shapes={{category=1,name="UntitledConcaveShape",restitution=0,mask=65535,density=0.1,sensor=false,shapeID=0,friction=0.2,points={{"{-27, -16}","{61, -15}","{62.5, -12.5}","{63.5, -7}","{63, 15.5}","{-34.5, 15.5}","{-27.5, -15.5}"},{"{-64, 5}","{-64, -13.5}","{-63, -15}","{-27.5, -15.5}","{-34.5, 15.5}","{-61.5, 14}","{-63, 12.5}"}}}},linearDamping=0,angularDamping=0},
		["carBody"] = {angularDamping=0,linearVelocity="{0.000000, 0.000000}",allowSleep=true,fixedRotation=false,linearDamping=0,angularVelocity=0,shapes={{sensor=false,density=0.1,friction=0.2,mask=65535,points={{"{30.5, 18.5}","{57.09765625, -5.7890625}","{64.5, -4}","{76, 4}","{83, 11}","{83, 28.5}","{82.5, 30}","{80, 32.5}"},{"{28, -15.5}","{43, -12.5}","{57.09765625, -5.7890625}","{30.5, 18.5}","{18.5, -3.5}","{18, -15.5}"},{"{30.5, 18.5}","{80, 32.5}","{-79, 33}","{-45, 15.5}"},{"{-36, -33}","{-35.5, -33.5}","{6.5, -33.5}","{18, -15.5}","{18.5, -3.5}","{-38, -6}","{-45.5, -15.5}"},{"{-45.5, -15.5}","{-38, -6}","{-45, 15.5}"},{"{-53.5, -15.5}","{-45.5, -15.5}","{-45, 15.5}"},{"{-82.5, -3}","{-53.5, -15.5}","{-45, 15.5}"},{"{-82.5, -3}","{-45, 15.5}","{-79, 33}"},{"{-83.5, -0.5}","{-82.5, -3}","{-79, 33}"},{"{-83.5, 27.5}","{-83.5, -0.5}","{-79, 33}"},{"{-82.5, 30.5}","{-83.5, 27.5}","{-79, 33}"},{"{-80.5, 32.5}","{-82.5, 30.5}","{-79, 33}"}},restitution=0,shapeID=3,category=1,name="complexShapeWithHole"},{sensor=false,density=0.1,category=1,mask=65535,name="circleShape",shapeID=2,restitution=0,center="{65.666016, 2.742188}",radius=18.89075,friction=0.2}},gravityScale=1,bullet=false,type=2},
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
