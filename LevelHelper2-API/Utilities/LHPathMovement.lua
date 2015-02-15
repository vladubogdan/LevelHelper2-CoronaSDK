-----------------------------------------------------------------------------------------
--
-- LHPathMovement.lua
--
--!@docBegin
--!A utility object that moves an object along a path. 
--!User should not have to use this directly but use the methods inside LHNodeProtocol.
--!
--!@docEnd
-----------------------------------------------------------------------------------------


--notifications
LHPathMovementHasEndedGlobalNotification = "LHPathMovementHasEndedGlobalNotification"
LHPathMovementHasEndedPerObjectNotification = "LHPathMovementHasEndedPerObjectNotification"

local LHUtils = require("LevelHelper2-API.Utilities.LHUtils");


LHPathMovement = {}
function LHPathMovement:initWithBezier(bezierObj, nodeObj)

	if (nil == bezierObj or nil == nodeObj) then
		print("Invalid LHPathMovement initialization!")
	end

	local object = {coronaSprite = nodeObj,
					pathPoints = LHUtils.LHDeepCopy(bezierObj:linePointsInSceneSpace()),
					totalPathLength = bezierObj:getLength(),
					currentPointIdx = 0,
					initialPointIdx = 0;
					currentRepetition = 0,
					pingPong = false,
					repetitions = 0,
					direction = 1,
					timeLength = 4.0, --as in 1 second
					elapsedTime = 0.0, -- as in how much time has passed since the movement began
					sectionElapsedTime = 0.0;
					playing = false,
					initialAngle = nodeObj.rotation,
					previousTime = os.clock(),
					firstLaunch = true,
					useOrientation = true,
					flipScaleXAtEnd = false,
					flipScaleYAtEnd = false
					}

	setmetatable(object, { __index = LHPathMovement })  -- Inheritance  

	return object
end

function LHPathMovement:setDirection(value)
	if(value >= 0)then
		self.direction = 1;
	else
		self.direction = -1;
	end
end
function LHPathMovement:restart()
	
	self.currentRepetition = 0;
	self.currentPointIdx = self.initialPointIdx;
end
--------------------------------------------------------------------------------
function LHPathMovement:removeSelf()

	self.coronaSprite = nil;
	self.pathPoints = nil;
	self = nil;
end
function LHPathMovement:getSectionPoints()
	
	local currentPoint = nil;
	local nextPoint = nil;
	
	if(self.currentPointIdx >= 1 and self.currentPointIdx <= #self.pathPoints)then
		currentPoint = self.pathPoints[self.currentPointIdx];	
	end
	
	if(self.currentPointIdx+1 >= 1 and self.currentPointIdx+1 <= #self.pathPoints)then
		nextPoint = self.pathPoints[self.currentPointIdx+1];	
	end
	
	return currentPoint, nextPoint;
end
--------------------------------------------------------------------------------
function LHPathMovement:enterFrame( event )

	if(self == nil)then
		return;
	end

	if(self.playing == false)then
		return;
	end
	
	local thisTime = event.time;
	local dt = (thisTime - self.previousTime)/1000.0;

	self.elapsedTime = self.elapsedTime + dt;
	
	self.sectionElapsedTime = self.sectionElapsedTime + dt;
	self.previousTime = thisTime;
	
	if(self.firstLaunch == true and self.currentPointIdx == 0)then
		if(self.direction > 0)then
			self.currentPointIdx = 1;
			self.initialPointIdx = 1;
		else
			self.currentPointIdx = #self.pathPoints -1;
			self.initialPointIdx = #self.pathPoints -1;
		end
	end
	
	self.firstLaunch = false;
	
	
	local currentPoint, nextPoint = self:getSectionPoints();
	
	if(nil == currentPoint or nil == nextPoint)then
		--reached end decide what to do
		self.playing = false;
		return;
	end
	
	local sectionLength = LHUtils.LHDistance(currentPoint, nextPoint);
	local sectionUnitLength = sectionLength/self.totalPathLength;
	local sectionTimeDuration = self.timeLength*sectionUnitLength;
	
	local sectionUnit = self.sectionElapsedTime/sectionTimeDuration;
	
	if(sectionUnit > 1.0)then
		
		self.sectionElapsedTime = 0.0;
		self.currentPointIdx = self.currentPointIdx + self.direction;
		
		if(self.direction >=0)then
			if(self.currentPointIdx == #self.pathPoints)then
				
				if(self.pingPong)then
					self.direction = -self.direction;
					self.currentPointIdx =#self.pathPoints -1;
				else
					self.currentPointIdx = 1;
				end
				self.currentRepetition = self.currentRepetition+1;
				
				if(self.flipScaleXAtEnd)then
					self.coronaSprite.xScale = -self.coronaSprite.xScale;
				end
				
				if(self.flipScaleYAtEnd)then
					self.coronaSprite.yScale = -self.coronaSprite.yScale;
				end
			end
		else
			if(self.currentPointIdx == 0)then
				
				if(self.pingPong)then
					self.direction = -self.direction;
					self.currentPointIdx = 1;
				else 
					self.currentPointIdx = #self.pathPoints -1;
				end
				self.currentRepetition = self.currentRepetition+1;
			
				if(self.flipScaleXAtEnd)then
					self.coronaSprite.xScale = -self.coronaSprite.xScale;
				end
				
				if(self.flipScaleYAtEnd)then
					self.coronaSprite.yScale = -self.coronaSprite.yScale;
				end
			end
		end
		
		if(self.currentRepetition >= self.repetitions and self.repetitions ~= 0)then
			self.playing = false;
			
			local endedEvent = { name=LHPathMovementHasEndedGlobalNotification, 
								 object = self.coronaSprite } 
			Runtime:dispatchEvent(endedEvent);

			local endedEvent = { name=LHPathMovementHasEndedPerObjectNotification, 
								object = self.coronaSprite } 
			self.coronaSprite:dispatchEvent(endedEvent);

			return
		end
		
	end
	
	--lets calculate the new node position based on the start - end and unit time
	local newX = currentPoint.x + (nextPoint.x - currentPoint.x)*sectionUnit;
	local newY = currentPoint.y + (nextPoint.y - currentPoint.y)*sectionUnit;
	
	if(self.direction < 0)then
		newX = nextPoint.x + (currentPoint.x - nextPoint.x)*sectionUnit;
		newY = nextPoint.y + (currentPoint.y - nextPoint.y)*sectionUnit;
	end
	
	if(self.useOrientation == true)then
		local curLineAngle = LHUtils.LHAngleOfLineInDegree(currentPoint, nextPoint) + 90;
		self.coronaSprite.rotation = curLineAngle + self.initialAngle;
	end
	

	local newPos = {x = newX, y = newY};
	self.coronaSprite:setPosition(newPos);
	
	
end
--------------------------------------------------------------------------------