--------------------------------------------------------------------------------
--
-- LHAnimation.lua
--
--!@docBegin
--!This class is responsible for playing animations defined inside LevelHelper 2.
--!
--!To receive animation notifications you have to add a listener to didFinishedRepetitionOnAnimation and/or didFinishedPlayingAnimation.
--!
--!@code
--!lhScene:addEventListener("didFinishedRepetitionOnAnimation", scene);--lhScene is your LHScene object
--!lhScene:addEventListener("didFinishedPlayingAnimation", scene);--lhScene is your LHScene object
--!@endcode
--!
--!@code
--!function scene:didFinishedPlayingAnimation(event)
--!	
--!	local animationObject = event.object;
--!	
--!	print("didFinishedPlayingAnimation info......................................................");
--!	print("Animation name: " .. tostring(animationObject:getName()));
--!	print("Animation object: " .. tostring(animationObject:getNode():getUniqueName()));
--!
--!end
--!@endcode
--!
--!@code
--!function scene:didFinishedRepetitionOnAnimation(event)
--!	
--!	local animationObject = event.object;
--!	
--!	print("didFinishedRepetitionOnAnimation info......................................................");
--!	print("Animation name: " .. tostring(animationObject:getName()));
--!	print("Animation object: " .. tostring(animationObject:getNode():getUniqueName()));
--!	
--!end
--!@endcode
--!
--!@docEnd
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local LHUtils = require("LevelHelper2-API.Utilities.LHUtils");
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--!@docBegin
--!Returns the name of the animation.
local function getName(selfObject)
--!@docEnd	
	return selfObject._name;
end
--------------------------------------------------------------------------------
--!@docBegin
--!Wheter or not this animation is active. The one that is currently played.
local function isActive(selfObject)
--!@docEnd	
	return selfObject._active;
end
--------------------------------------------------------------------------------
--!@docBegin
--!Set this animation as the active one.
--!@param active A boolean value specifying the active state of the animation.
local function setActive(selfObject, active)
--!@docEnd	
	selfObject._active = active;
	
	if(active)then
		selfObject._node:setActiveAnimation(selfObject);
	else
		selfObject._node:setActiveAnimation(nil);
	end
end
--------------------------------------------------------------------------------
--!@docBegin
--!The time it takes for the animation to finish a loop. A number value.
local function totalTime(selfObject)
--!@docEnd	
	return selfObject._totalFrames*(1.0/selfObject._fps);
end
--------------------------------------------------------------------------------
--!@docBegin
--!The total number of frames on the animation. A number value.
local function totalFrames(selfObject)
--!@docEnd	
	return selfObject._totalFrames;
end
--------------------------------------------------------------------------------
--!@docBegin
--!Current frame of the animation. As defines in LevelHelper 2 editor.
local function currentFrame(selfObject)
--!@docEnd	
	return selfObject._currentTime/(1.0/selfObject._fps);
end
--------------------------------------------------------------------------------
--!@docBegin
--!Move the animation to a frame.
--!@param value The frame number where the animation should jump to.
local function setCurrentFrame(selfObject, value)
--!@docEnd	
	selfObject:setCurrentTime(value*(1.0/selfObject._fps));
end
--------------------------------------------------------------------------------
--!@docBegin
--!Set the animations as playing or paused.
--!@param animating A boolean value that will set the animation as playing or paused.
local function setAnimating(selfObject, animating)
--!@docEnd	
	selfObject._animating = animating;
end
--------------------------------------------------------------------------------
--!@docBegin
--!Returns whether or not the animation is currently playing. A boolean value.
local function animating(selfObject)
--!@docEnd	
	return selfObject._animating;
end
--------------------------------------------------------------------------------
--!@docBegin
--!Restarts the animation. Will set the time to 0 and reset all repetitions.
local function restart(selfObject)
--!@docEnd	
	selfObject:resetOneShotFrames();
	selfObject._currentRepetition = 0;
	selfObject._currentTime = 0;
	selfObject._beginFrameIdx = 1;
end
--------------------------------------------------------------------------------
--!@docBegin
--!The number of times this animation will loop. A 0 repetitions meens it will loop undefinately.
local function repetitions(selfObject)
--!@docEnd	
	return selfObject._repetitions;
end
--------------------------------------------------------------------------------
--!@docBegin
--!The node this animation belongs to.
local function getNode(selfObject)
--!@docEnd	
	return selfObject._node;
end
--------------------------------------------------------------------------------
--!@docBegin
--!Force the animation to go forward in time by adding the delta value to the current animation time.
--!@param delta A value that will be appended to the current animation time.
local function updateTimeWithDelta(selfObject, delta)
--!@docEnd	
	if(selfObject._animating)then
		local newTime = selfObject:getCurrentTime() + delta;
		selfObject:setCurrentTime(newTime);
	end
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local function setCurrentTime(selfObject, val)

	selfObject._currentTime = val;

	selfObject:animateNodeToTime(selfObject._currentTime);
	
	if( (selfObject._currentTime > selfObject:totalTime()) and selfObject:animating())then
		
		if selfObject._currentRepetition < selfObject:repetitions() + 1 then--dont grow this beyound num of repetitions as
			selfObject._currentRepetition = selfObject._currentRepetition + 1;
		end
		
		if( selfObject:didFinishAllRepetitions() == false) then
			selfObject._currentTime = 0.0;
			selfObject:resetOneShotFrames();
			
			local finishAnimRepEvent = { 	name="didFinishedRepetitionOnAnimation", 
								  		object= selfObject };
			selfObject._node:getScene():dispatchEvent(finishAnimRepEvent);
			
		else
			selfObject:getNode():setActiveAnimation(nil);
			
			local finishAnimEvent = { 	name="didFinishedPlayingAnimation", 
								  		object= selfObject };
			selfObject._node:getScene():dispatchEvent(finishAnimEvent);
		
			
		end
	end
	selfObject.previousTime = selfObject._currentTime;
end
--------------------------------------------------------------------------------
local function getCurrentTime(selfObject)
	return selfObject._currentTime;
end
--------------------------------------------------------------------------------
local function didFinishAllRepetitions(selfObject)
	if(selfObject:repetitions() == 0)then
		return false;
	end
	
	if(selfObject:animating() and selfObject._currentRepetition >= selfObject:repetitions())then
		return true;
	end
	return false;
end
--------------------------------------------------------------------------------
local function animateNodeToTime(selfObject, time)

	if(selfObject:didFinishAllRepetitions())then
		return;
	end

	if(selfObject._node)then
		
		if(time > selfObject:totalTime())then
			time = selfObject:totalTime();
		end

		for i=1, #selfObject._properties do
			local prop = selfObject._properties[i];
		
			local subproperties = prop:allSubproperties();
			
			-- print("has subproperties ");
			-- print(subproperties);
			
			if(subproperties)then
				for j=1, #subproperties do
					local subprop = subproperties[j];
					
					-- print("update subproperty");
					-- print(subprop);
					
					selfObject:updateNodeWithAnimationProperty(subprop, time);
				end
			end
			selfObject:updateNodeWithAnimationProperty(prop, time);
		end
	end
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local function resetOneShotFrames(selfObject)
	selfObject:resetOneShotFramesStartingFromFrameNumber(1);
end
--------------------------------------------------------------------------------
local function resetOneShotFramesStartingFromFrameNumber(selfObject, frameNumber)
	
	for i=1, #selfObject._properties do
		local prop = selfObject._properties[i];
	
		local subproperties = prop:allSubproperties();
		
		if(subproperties)then
			for j=1, #subproperties do
				local subprop = subproperties[j];
				
				local frames = subprop:keyFrames();
				for k=1, #frames do
					local frm = frames[k];
					if(frm:frameNumber() >= frameNumber)then
						frm:setWasShot(false);
					end
				end
				
			end
		end
	
		local frames = prop:keyFrames();
		for j=1, #frames do
			local frm = frames[j];
			if(frm:frameNumber() >= frameNumber)then
				frm:setWasShot(false);
			end
		end
	
	end
	
end
--------------------------------------------------------------------------------
local function updateNodeWithAnimationProperty(selfObject, prop, time)

	local frames = prop:keyFrames();
	
	local beginFrm = nil;
	local endFrm = nil;
	
	
	for i=1, #frames do
		local frm = frames[i];
		
		
	
		if (frm:frameNumber()*(1.0/selfObject._fps) <= time ) then
			beginFrm = frm;
		end
		
		if (frm:frameNumber()*(1.0/selfObject._fps) > time) then
			endFrm = frm;
			break;--exit for
		end
	end
	
	local animNode = selfObject:getNode();
	
	if(prop:isSubproperty() and prop:subpropertyNode())then
		animNode = prop:subpropertyNode();
	end
	
	-- print("...............................");
	-- LHUtils.LHPrintObjectInfo(beginFrm);
	
    -- if([prop isKindOfClass:[LHChildrenPositionsProperty class]])
    -- {
    --     [self animateNodeChildrenPositionsToTime:time
    --                                   beginFrame:beginFrm
    --                                     endFrame:endFrm
    --                                         node:animNode
    --                                     property:prop];
    -- }
    -- else if([prop isKindOfClass:[LHPositionProperty class]])
    -- {
        -- [self animateNodePositionToTime:time
        --                      beginFrame:beginFrm
        --                       endFrame:endFrm
        --                           node:animNode];
    -- }
    if(prop.isAnimationChildrenPositionsProperty == true)then
	
		selfObject:animateNodeChildrenPositionsToTime(time, beginFrm, endFrm, animNode, prop);
	
	elseif(prop.isAnimationPositionProperty == true)then
		
		selfObject:animateNodePositionToTime(time, beginFrm, endFrm, animNode);
	
	elseif(prop.isAnimationRootBoneProperty == true)then
	
		selfObject:animateRootBonesToTime(time, beginFrm, endFrm, animNode);
	
	elseif(prop.isAnimationChildrenRotationsProperty == true)then
		
		selfObject:animateNodeChildrenRotationsToTime(time, beginFrm, endFrm, animNode, prop);
		
	elseif(prop.isAnimationRotationProperty == true)then
		
		selfObject:animateNodeRotationToTime(time, beginFrm, endFrm, animNode);
		
	elseif(prop.isAnimationChildrenScalesProperty == true)then
	
		selfObject:animateNodeChildrenScalesToTime(time, beginFrm, endFrm, animNode, prop);
		
	elseif(prop.isAnimationScaleProperty == true)then
		
		selfObject:animateNodeScaleToTime(time, beginFrm, endFrm, animNode);
		
	elseif(prop.isAnimationChildrenOpacitiesProperty == true)then
	
		selfObject:animateNodeChildrenOpacitiesToTime(time, beginFrm, endFrm, animNode, prop);
	
	elseif(prop.isAnimationOpacityProperty == true)then
		
		selfObject:animateNodeOpacityToTime(time, beginFrm, endFrm, animNode);
		
	elseif(prop.isAnimationSpriteFrameProperty == true)then
		
		selfObject:animateSpriteFrameChangeWithFrame(beginFrm, animNode);
	
	else
		
		
	end
	
end
--------------------------------------------------------------------------------
local function animateNodeChildrenPositionsToTime(selfObject, time, beginFrame, endFrame, animNode, prop)

	--here we handle positions
	local children = animNode:getChildrenOfProtocol("LHAnimationsProtocol");

	if(beginFrame ~= nil and endFrame ~= nil)then
	
		local beginTime = beginFrame:frameNumber()*(1.0/selfObject._fps);
		local endTime = endFrame:frameNumber()*(1.0/selfObject._fps);

		local framesTimeDistance = endTime - beginTime;
		local timeUnit = (time-beginTime)/framesTimeDistance; --a value between 0 and 1
	
		for i=1, #children do
			local child = children[i];
			
			if(prop:subpropertyForUUID(child:getUUID())==nil)then
				
				local beginPosition   = beginFrame:positionForUUID(child:getUUID());
				local endPosition     = endFrame:positionForUUID(child:getUUID());
					
				--lets calculate the new node position based on the start - end and unit time
				local newX = beginPosition.x + (endPosition.x - beginPosition.x)*timeUnit;
				local newY = beginPosition.y + (endPosition.y - beginPosition.y)*timeUnit;
				
				local newPos = {x = newX, y = newY};
		
				newPos = selfObject:convertFramePosition(newPos, child);
		
				child:setPosition({x = newPos.x, y = newPos.y});
			end
		end
	elseif(beginFrame) then
		--we only have begin frame so lets set positions based on this frame
		for i=1, #children do
			local child = children[i];
			if(prop:subpropertyForUUID(child:getUUID())==nil)then
				local beginPosition   = beginFrame:positionForUUID(child:getUUID());
				
				local newPos = {x = beginPosition.x, y= beginPosition.y};
		
				newPos = selfObject:convertFramePosition(newPos, child);
		
				child:setPosition({x = newPos.x, y = newPos.y});
			end
		end
	end
end
--------------------------------------------------------------------------------
local function animateNodePositionToTime(selfObject, time, beginFrame, endFrame, animNode)

	--here we handle positions
	if(beginFrame ~= nil and endFrame ~= nil)then
	
		local beginTime = beginFrame:frameNumber()*(1.0/selfObject._fps);
		local endTime = endFrame:frameNumber()*(1.0/selfObject._fps);

		local framesTimeDistance = endTime - beginTime;
		local timeUnit = (time-beginTime)/framesTimeDistance; --a value between 0 and 1
		
		local beginPosition = beginFrame:positionForUUID(animNode:getUUID());
		local endPosition 	= endFrame:positionForUUID(animNode:getUUID());
		
		--lets calculate the new node position based on the start - end and unit time
		local newX = beginPosition.x + (endPosition.x - beginPosition.x)*timeUnit;
		local newY = beginPosition.y + (endPosition.y - beginPosition.y)*timeUnit;

		local newPos = {x = newX, y = newY};
		
		newPos = selfObject:convertFramePosition(newPos, animNode);
		
		animNode:setPosition({x = newPos.x, y = newPos.y});
	end

	if(beginFrame ~= nil and endFrame == nil)then
	
		-- we only have begin frame so lets set positions based on this frame
		local beginPosition = beginFrame:positionForUUID(animNode:getUUID());
	
		local newPos = {x = beginPosition.x, y= beginPosition.y};
		
		newPos = selfObject:convertFramePosition(newPos, animNode);
		
		animNode:setPosition({x = newPos.x, y = newPos.y});
	end
end
--------------------------------------------------------------------------------
local function animateRootBonesToTime(selfObject, time, beginFrame, endFrame, rootBone)

	if(rootBone:isRoot() ~= true)then
		print("WARNING: Animation on a non root bone.");
		return;
	end
	
	local allBones = rootBone:getChildrenOfType("LHBone");
	
	if(beginFrame ~= nil and endFrame ~= nil)then
		
		local beginTime = beginFrame:frameNumber()*(1.0/selfObject._fps);
		local endTime = endFrame:frameNumber()*(1.0/selfObject._fps);

		local framesTimeDistance = endTime - beginTime;
		local timeUnit = (time-beginTime)/framesTimeDistance; --a value between 0 and 1
		
		local bFrmInfoRoot = beginFrame:frameInfoForBoneNamed("__rootBone__");
		local eFrmInfoRoot = endFrame:frameInfoForBoneNamed("__rootBone__");
		
		local beginPosition = bFrmInfoRoot:getPosition();
		local endPosition 	= eFrmInfoRoot:getPosition();
		
		local beginRotation = bFrmInfoRoot:getRotation();
		local endRotation 	= eFrmInfoRoot:getRotation();
		
		--lets calculate the new node position based on the start - end and unit time
		local newX = beginPosition.x + (endPosition.x - beginPosition.x)*timeUnit;
		local newY = beginPosition.y + (endPosition.y - beginPosition.y)*timeUnit;
		local newPos = {x = newX, y = newY};
		
		local shortest_angle = math.fmod( (math.fmod( (endRotation - beginRotation), 360.0) + 540.0), 360.0) - 180.0;
		local newRotation = beginRotation + shortest_angle*timeUnit;
		
		rootBone:setPosition(newPos);
		rootBone:setRotation(newRotation);
	
		for i=1, #allBones do
			
			local b = allBones[i];
			
			local bInfo = beginFrame:frameInfoForBoneNamed( b:getUniqueName() );
			local eInfo = endFrame:frameInfoForBoneNamed( b:getUniqueName() );
		
			if(bInfo ~= nil and eInfo ~= nil)then
				
				local beginRotation = bInfo:getRotation();
				local endRotation 	= eInfo:getRotation();
			
				local shortest_angle = math.fmod( (math.fmod( (endRotation - beginRotation), 360.0) + 540.0), 360.0) - 180.0;
				local newRotation = beginRotation + shortest_angle*timeUnit;
				
				b:setRotation(newRotation);
				
				if(b:getRigid() == false)then
				
					local beginPosition = bInfo:getPosition();
					local endPosition 	= eInfo:getPosition();
					--lets calculate the new node position based on the start - end and unit time
					local newX = beginPosition.x + (endPosition.x - beginPosition.x)*timeUnit;
					local newY = beginPosition.y + (endPosition.y - beginPosition.y)*timeUnit;
					local newPos = {x = newX, y = newY};
					
					b:setPosition(newPos);
				end
			end
		end
	end

	if(beginFrame ~= nil and endFrame == nil)then
	
		local bFrmInfoRoot = beginFrame:frameInfoForBoneNamed("__rootBone__");
		
		if(bFrmInfoRoot ~= nil)then 
			local beginPosition = bFrmInfoRoot:getPosition();
			local beginRotation = bFrmInfoRoot:getRotation();
			
			rootBone:setPosition(beginPosition);
			rootBone:setRotation(beginRotation);
		end
		
		for i=1, #allBones do
			
			local b = allBones[i];
			
			local bInfo = beginFrame:frameInfoForBoneNamed( b:getUniqueName() );
			
			if(bInfo ~= nil)then
				
				local beginRotation = bInfo:getRotation();
				b:setRotation(beginRotation);
				
				if(b:getRigid() == false)then
					local beginPosition = bInfo:getPosition();
					b:setPosition(beginPosition);
				end
			end
		end
	end
end
--------------------------------------------------------------------------------
local function animateNodeChildrenRotationsToTime(selfObject, time, beginFrame, endFrame, animNode, prop)

    local children = animNode:getChildrenOfProtocol("LHAnimationsProtocol");

	if(beginFrame ~= nil and endFrame ~= nil)then
	
		local beginTime = beginFrame:frameNumber()*(1.0/selfObject._fps);
		local endTime = endFrame:frameNumber()*(1.0/selfObject._fps);

		local framesTimeDistance = endTime - beginTime;
		local timeUnit = (time-beginTime)/framesTimeDistance; --a value between 0 and 1
	
		for i=1, #children do
			local child = children[i];
			
			if(prop:subpropertyForUUID(child:getUUID())==nil)then
	
				local beginRotation = beginFrame:rotationForUUID(child:getUUID());
				local endRotation   = endFrame:rotationForUUID(child:getUUID());
		
				local shortest_angle = math.fmod( (math.fmod( (endRotation - beginRotation), 360.0) + 540.0), 360.0) - 180.0;

				--lets calculate the new value based on the start - end and unit time
				local newRotation = beginRotation + shortest_angle*timeUnit;
		
				child:setRotation(newRotation);
			end
		end
	elseif(beginFrame)then
		for i=1, #children do
			local child = children[i];
			
			if(prop:subpropertyForUUID(child:getUUID())==nil)then
				--we only have begin frame so lets set value based on this frame
				local beginRotation = beginFrame:rotationForUUID(child:getUUID());
				child:setRotation(beginRotation);
			end
		end
	end
end
--------------------------------------------------------------------------------
local function animateNodeRotationToTime(selfObject, time, beginFrame, endFrame, animNode)

	if(beginFrame ~= nil and endFrame ~= nil)then
	
		local beginTime = beginFrame:frameNumber()*(1.0/selfObject._fps);
		local endTime = endFrame:frameNumber()*(1.0/selfObject._fps);
	
		local framesTimeDistance = endTime - beginTime;
		local timeUnit = (time-beginTime)/framesTimeDistance; --a value between 0 and 1
		
		local beginRotation = beginFrame:rotationForUUID(animNode:getUUID());
		local endRotation   = endFrame:rotationForUUID(animNode:getUUID());
		
		local shortest_angle = math.fmod( (math.fmod( (endRotation - beginRotation), 360.0) + 540.0), 360.0) - 180.0;

		--lets calculate the new value based on the start - end and unit time
		local newRotation = beginRotation + shortest_angle*timeUnit;
		
		animNode:setRotation(newRotation);
	end
	
	if(beginFrame ~= nil and endFrame == nil)then
	
		--we only have begin frame so lets set value based on this frame
		local beginRotation = beginFrame:rotationForUUID(animNode:getUUID());
		animNode:setRotation(beginRotation);
	end
end
--------------------------------------------------------------------------------
local function animateNodeChildrenScalesToTime(selfObject, time, beginFrame, endFrame, animNode, prop)

	--here we handle positions
	local children = animNode:getChildrenOfProtocol("LHAnimationsProtocol");

	if(beginFrame ~= nil and endFrame ~= nil)then
	
		local beginTime = beginFrame:frameNumber()*(1.0/selfObject._fps);
		local endTime = endFrame:frameNumber()*(1.0/selfObject._fps);

		local framesTimeDistance = endTime - beginTime;
		local timeUnit = (time-beginTime)/framesTimeDistance; --a value between 0 and 1
	
		for i=1, #children do
			local child = children[i];
			
			if(prop:subpropertyForUUID(child:getUUID())==nil)then
				
				local beginScale = beginFrame:scaleForUUID(child:getUUID());
				local endScale = endFrame:scaleForUUID(child:getUUID());

				--lets calculate the new node scale based on the start - end and unit time
				local newX = beginScale.width + (endScale.width - beginScale.width)*timeUnit;
				local newY = beginScale.height + (endScale.height - beginScale.height)*timeUnit;
		
				child:setScale(newX, newY);
			end
		end
	elseif(beginFrame) then
		--we only have begin frame so lets set positions based on this frame
		for i=1, #children do
			local child = children[i];
			if(prop:subpropertyForUUID(child:getUUID())==nil)then
				
				local beginScale = beginFrame:scaleForUUID(child:getUUID());
				child:setScale(beginScale.width, beginScale.height);
				
			end
		end
	end
end
--------------------------------------------------------------------------------
local function animateNodeScaleToTime(selfObject, time, beginFrame, endFrame, animNode)

	--here we handle scale
	if(beginFrame ~= nil and endFrame ~= nil)then
	
		local beginTime = beginFrame:frameNumber()*(1.0/selfObject._fps);
		local endTime = endFrame:frameNumber()*(1.0/selfObject._fps);
	
		local framesTimeDistance = endTime - beginTime;
		local timeUnit = (time-beginTime)/framesTimeDistance; --a value between 0 and 1
	    
		local beginScale = beginFrame:scaleForUUID(animNode:getUUID());
		local endScale = endFrame:scaleForUUID(animNode:getUUID());

		--lets calculate the new node scale based on the start - end and unit time
		local newX = beginScale.width + (endScale.width - beginScale.width)*timeUnit;
		local newY = beginScale.height + (endScale.height - beginScale.height)*timeUnit;
		
		animNode:setScale(newX, newY);
	end
	if(beginFrame ~= nil and endFrame == nil)then

		local beginScale = beginFrame:scaleForUUID(animNode:getUUID());
		animNode:setScale(beginScale.width, beginScale.height);
	end
end
--------------------------------------------------------------------------------
local function animateNodeChildrenOpacitiesToTime(selfObject, time, beginFrame, endFrame, animNode, prop)

	--here we handle positions
	local children = animNode:getChildrenOfProtocol("LHAnimationsProtocol");

	if(beginFrame ~= nil and endFrame ~= nil)then
	
		local beginTime = beginFrame:frameNumber()*(1.0/selfObject._fps);
		local endTime = endFrame:frameNumber()*(1.0/selfObject._fps);

		local framesTimeDistance = endTime - beginTime;
		local timeUnit = (time-beginTime)/framesTimeDistance; --a value between 0 and 1
	
		for i=1, #children do
			local child = children[i];
			
			if(prop:subpropertyForUUID(child:getUUID())==nil)then
				
				local beginValue = beginFrame:opacityForUUID(child:getUUID());
				local endValue = endFrame:opacityForUUID(child:getUUID());
		
				--lets calculate the new value based on the start - end and unit time
				local newValue = beginValue + (endValue - beginValue)*timeUnit;

				child.alpha = newValue/255.0;
			end
		end
	elseif(beginFrame) then
		--we only have begin frame so lets set positions based on this frame
		for i=1, #children do
			local child = children[i];
			if(prop:subpropertyForUUID(child:getUUID())==nil)then
				
				--we only have begin frame so lets set value based on this frame
				local beginValue = beginFrame:opacityForUUID(child:getUUID());
				child.alpha = beginValue/255.0;
				
			end
		end
	end
end
--------------------------------------------------------------------------------
local function animateNodeOpacityToTime(selfObject, time, beginFrame, endFrame, animNode)

	--here we handle sprites opacity
    if(beginFrame ~= nil and endFrame ~= nil)then
	
		local beginTime = beginFrame:frameNumber()*(1.0/selfObject._fps);
		local endTime = endFrame:frameNumber()*(1.0/selfObject._fps);
	
		local framesTimeDistance = endTime - beginTime;
		local timeUnit = (time-beginTime)/framesTimeDistance; --a value between 0 and 1
	
		local beginValue = beginFrame:opacityForUUID(animNode:getUUID());
		local endValue = endFrame:opacityForUUID(animNode:getUUID());
		
		--lets calculate the new value based on the start - end and unit time
		local newValue = beginValue + (endValue - beginValue)*timeUnit;

		animNode.alpha = newValue/255.0;
	end
	if(beginFrame ~= nil and endFrame == nil)then

		--we only have begin frame so lets set value based on this frame
		local beginValue = beginFrame:opacityForUUID(animNode:getUUID());
		animNode.alpha = beginValue/255.0;
	end
end
--------------------------------------------------------------------------------
local function animateSpriteFrameChangeWithFrame(selfObject, beginFrame, animNode)
	
	local sprite = nil;
	if(animNode:getType() == "LHSprite") then
		sprite = animNode;
	end
	
	if(sprite == nil)then
		return;
	end
	
	if(beginFrame and sprite)then
		
		if(selfObject:animating())then
			if(beginFrame:wasShot() == false)then
 				sprite:setSpriteFrameWithName(beginFrame:spriteFrameName());
 				beginFrame:setWasShot(true);
 	 		end
 		else
 			sprite:setSpriteFrameWithName(beginFrame:spriteFrameName());
 		end
	 end
end
--------------------------------------------------------------------------------
local function getScene(selfObject)
	if selfObject._scene == nil then
		selfObject._scene = selfObject:getNode():getScene();
	end
	return selfObject._scene;
end
local function convertFramePosition(selfObject, newPos, animNode)

	if(animNode:getType() == "LHCamera")then
		local winSize = selfObject:getScene():getDesignResolutionSize();
		return {x = winSize.width*0.5 - newPos.x,
				y = winSize.height*0.5 - newPos.y};
	end
	
    -- if([animNode isKindOfClass:[LHCamera class]]){
    --     CGSize winSize = [[self scene] designResolutionSize];
    --     return CGPointMake(winSize.width*0.5  - newPos.x,
    --                       -winSize.height*0.5 - newPos.y);
    -- }

    -- print("point is ");
    -- print(newPos.x);
    -- print(newPos.y);


	-- local scene = selfObject:getScene();

	if(	animNode:getParent() == nil or 
		(animNode:getParent():getType() == "LHScene") or
		(animNode:getParent():getType() == "LHGameWorldNode") or
		(animNode:getParent():getType() == "LHUINode") or
		(animNode:getParent():getType() == "LHBackUINode") )then


	else
		local parent = animNode:getParent();
		local pcontent = parent.lhContentSize;
		
		local prntAncX = parent.anchorX;
		local prntAncY = parent.anchorY;
		
		newPos.x = newPos.x - pcontent.width*(prntAncX - 0.5);
		newPos.y = newPos.y - pcontent.height*(prntAncY - 0.5);
	end
    -- CGPoint offset = [scene designOffset];

    -- CCNode* p = [animNode parent];
    -- if([animNode parent] == nil ||
    --   [animNode parent] == scene ||
    --   [animNode parent] == [scene gameWorldNode]||
    --   [animNode parent] == [scene backUiNode]||
    --   [animNode parent] == [scene uiNode])
    -- {
    --     newPos.x += offset.x;
    --     newPos.y += offset.y;
        
    --     newPos.y += scene.designResolutionSize.height;// p.contentSize.height;
    -- }
    
	return newPos;
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local LHAnimation = {}
function LHAnimation:animationWithDictionary(dict, node)

	if (nil == dict) then
		print("Invalid LHAnimation initialization!")
	end
	
	local object = {_repetitions = dict["repetitions"],
					_totalFrames = dict["totalFrames"],
					_name = dict["name"],
					_active = dict["active"],
					_fps = dict["fps"],
					_animating = false,
					_currentTime = 0.0,
					_currentRepetition = 0,
					_beginFrameIdx = 1,
					_node = node,
					_properties = {},
					_currentTime = 0.0,
					_previousTime = 0.0
				}
	setmetatable(object, { __index = LHAnimation })  -- Inheritance

	--public methods
	object.getName 				= getName;
	object.isActive				= isActive;
	object.setActive			= setActive;
	object.totalTime			= totalTime;
	object.currentFrame			= currentFrame;
	object.setCurrentFrame		= setCurrentFrame;
	object.setAnimating			= setAnimating;
	object.animating			= animating;
	object.restart				= restart;
	object.repetitions			= repetitions;
	object.getNode				= getNode;
	object.updateTimeWithDelta	= updateTimeWithDelta;
	
	object.setCurrentTime = setCurrentTime;
	object.getCurrentTime = getCurrentTime;
	object.animateNodeToTime = animateNodeToTime;
	object.didFinishAllRepetitions = didFinishAllRepetitions;
	object.updateNodeWithAnimationProperty = updateNodeWithAnimationProperty;
	
	object.animateNodeChildrenPositionsToTime = animateNodeChildrenPositionsToTime;
	object.animateNodePositionToTime = animateNodePositionToTime;
	object.animateRootBonesToTime = animateRootBonesToTime;
	object.animateNodeChildrenRotationsToTime = animateNodeChildrenRotationsToTime;
	object.animateNodeChildrenScalesToTime = animateNodeChildrenScalesToTime;
	object.animateNodeRotationToTime = animateNodeRotationToTime;
	object.animateNodeScaleToTime = animateNodeScaleToTime;
	object.animateNodeChildrenOpacitiesToTime = animateNodeChildrenOpacitiesToTime;
	object.animateNodeOpacityToTime = animateNodeOpacityToTime;
	object.animateSpriteFrameChangeWithFrame = animateSpriteFrameChangeWithFrame;
	
	object.convertFramePosition = convertFramePosition;
	object.getScene = getScene;
	
	--private methods
	object.resetOneShotFrames 						= resetOneShotFrames;
	object.resetOneShotFramesStartingFromFrameNumber= resetOneShotFramesStartingFromFrameNumber;
	
	--load animation properties - key frames info
	local propDictInfo = dict["properties"];
	
	local LHAnimationProperty = require('LevelHelper2-API.Animations.AnimationProperties.LHAnimationProperty');
	
	for key,value in pairs(propDictInfo) do 
		
		local prop = LHAnimationProperty:animationPropertyWithDictionary(value, object);
		object._properties[#object._properties +1] = prop;
	end
	
	if(object._active)then
		object:restart();
		object:setAnimating(true);
	end
	
	return object
end
--------------------------------------------------------------------------------
return LHAnimation;
