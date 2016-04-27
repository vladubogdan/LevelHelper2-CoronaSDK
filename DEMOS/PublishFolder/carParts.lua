-- This file was generated using LevelHelper 2
-- For more informations please visit http://www.gamedevhelper.com

module(...)

function getSpriteSheetData()

	local options = {
		-- array of tables representing each frame (required)
		frames = {

				--FRAME "carTyre"
				{
					x = 131,
					y = 2,
					width = 43,
					height = 43,
					sourceWidth = 43,
					sourceHeight = 43,
					sourceX = 2,
					sourceY = 2
				},


				--FRAME "wood"
				{
					x = 0,
					y = 0,
					width = 128,
					height = 32,
					sourceWidth = 128,
					sourceHeight = 32,
					sourceX = 0,
					sourceY = 0
				},


				--FRAME "carBody"
				{
					x = 0,
					y = 47,
					width = 168,
					height = 68,
					sourceWidth = 168,
					sourceHeight = 68,
					sourceX = 5,
					sourceY = 7
				},

		},
		sheetContentWidth = 175,
		sheetContentHeight = 116
	}
	return options
end

function getPhysicsData()
	local physics =
	{
		["carTyre"] = {type=2,angularVelocity=0,linearVelocity="{0.000000, 0.000000}",allowSleep=true,fixedRotation=false,gravityScale=1,bullet=false,linearDamping=0,shapes={{restitution=0,category=1,center="{0.000000, 0.000000}",sensor=false,friction=2,name="UntitledCircleShape",shapeID=0,radius=21.25,density=0.1,mask=65535}},angularDamping=0},
		["wood"] = {bullet=false,allowSleep=true,linearDamping=0,shapes={{density=0.1,name="UntitledConcaveShape",restitution=0,friction=0.2,shapeID=0,sensor=false,mask=65535,points={{"{-27, -16}","{61, -15}","{62.5, -12.5}","{63.5, -7}","{63, 15.5}","{-34.5, 15.5}","{-27.5, -15.5}"},{"{-64, 5}","{-64, -13.5}","{-63, -15}","{-27.5, -15.5}","{-34.5, 15.5}","{-61.5, 14}","{-63, 12.5}"}},category=1}},type=0,angularVelocity=0,gravityScale=1,angularDamping=0,fixedRotation=false,linearVelocity="{0.000000, 0.000000}"},
		["carBody"] = {linearDamping=0,type=2,angularDamping=0,gravityScale=1,fixedRotation=false,shapes={{friction=0.2,restitution=0,points={{"{-45.75, -15.75}","{-40.25, -27.75}","{-36.25, -33.25}","{-35.75, -33.75}","{6.75, -33.75}","{9.75, -32.25}","{11.25, -30.25}","{11.25, -28.25}"},{"{-82.75, 30.75}","{-83.75, 27.75}","{-45.75, -15.75}"},{"{-80.75, 32.75}","{-82.75, 30.75}","{-45.75, -15.75}"},{"{-79.25, 33.25}","{-80.75, 32.75}","{-45.75, -15.75}"},{"{80.25, 32.75}","{-79.25, 33.25}","{-45.75, -15.75}"},{"{80.25, 32.75}","{-45.75, -15.75}","{18.25, -15.75}"},{"{80.25, 32.75}","{18.25, -15.75}","{43.25, -12.75}"},{"{80.25, 32.75}","{43.25, -12.75}","{53.25, -9.75}"},{"{80.25, 32.75}","{53.25, -9.75}","{64.75, -4.25}"},{"{80.25, 32.75}","{64.75, -4.25}","{76.25, 4.25}"},{"{80.25, 32.75}","{76.25, 4.25}","{83.25, 11.25}"},{"{80.25, 32.75}","{83.25, 11.25}","{83.25, 28.75}"},{"{80.25, 32.75}","{83.25, 28.75}","{82.75, 30.25}"},{"{-40.25, -27.75}","{-39.75, -30.75}","{-36.25, -33.25}"},{"{-45.75, -15.75}","{11.25, -28.25}","{18.25, -15.75}"},{"{-83.75, 27.75}","{-83.75, -0.75}","{-82.75, -3.25}","{-53.75, -15.75}","{-45.75, -15.75}"}},shapeID=0,sensor=false,mask=65535,category=1,name="UntitledConcaveShape",density=0.1}},bullet=false,angularVelocity=0,allowSleep=true,linearVelocity="{0.000000, 0.000000}"},
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
