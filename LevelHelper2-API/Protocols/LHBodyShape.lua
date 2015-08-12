--------------------------------------------------------------------------------
--
-- LHBodyShape.lua
--
--------------------------------------------------------------------------------
function LHDot(a, b)
	return a.x * b.x + a.y * b.y
end

function LHDistanceSquared(a, b)
	local c = {x = a.x - b.x, y = a.y - b.y}
	return LHDot(c, c);
end

function LHValidateCentroid(vs)

	local count = #vs;
	
	if(count < 3 or count > 8)then
		return false;
	end

	local n = math.min(count, 8);

	local ps = {};
	local tempCount = 0;
	for i = 1, n do
		local v = vs[i];
		
		local unique = true;
		if(tempCount > 0)then
			
			for j = 1, tempCount do
				local curPs = ps[j];
				local squared = LHDistanceSquared(v, curPs);
				
				if squared < 0.5 * 0.005 then
					unique = false;
					break;
				end
			end
		end
		
		if (unique)then
			ps[tempCount+1] = v;
			tempCount = tempCount+1;
		end
	end
    
	n = tempCount;
	if (n < 3)then
        return false;
	end
    
    return true;
end


LHBodyShape = {}
function LHBodyShape:createCircleWithDictionary(dictionary, node, scene, size, allBodyFixtures)

	local object = {_shapeName = dictionary["name"],
					_shapeID   = dictionary["shapeID"],
					_minFixtureIdForThisObject = 1,
					_maxFixtureIdForThisObject = 1,
					_subShape = {},
					}
	setmetatable(object, { __index = LHBodyShape })  -- Inheritance	
	
	local collisionFilter = {categoryBits = dictionary["category"], maskBits = dictionary["mask"] } 

	local circleRadius = size.width*0.5*node.xScale;
	if(circleRadius < 0)then
		circleRadius = circleRadius*(-1.0);
	end
	
	fixtureInfo = {	friction= dictionary["friction"],
					bounce	= dictionary["restitution"], 
					density = dictionary["density"],
					radius  = circleRadius,
					isSensor= dictionary["sensor"],
					filter  = collisionFilter
					}
					
	object._subShape[#object._subShape+1] = fixtureInfo;
	allBodyFixtures[#allBodyFixtures+1] = object._subShape[#object._subShape];
	
	return object;
end
--------------------------------------------------------------------------------
function LHBodyShape:createWithName(name, node, scene, from, to, allBodyFixtures)

	local object = {_shapeName = name,
					_shapeID   = 0,
					_minFixtureIdForThisObject = 1,
					_maxFixtureIdForThisObject = 1,
					_subShape = {},
					}
	setmetatable(object, { __index = LHBodyShape })  -- Inheritance	
	
	local chainPoints = {}
			
	chainPoints[#chainPoints+1] = from.x;
	chainPoints[#chainPoints+1] = from.y;
	
	chainPoints[#chainPoints+1] = to.x;
	chainPoints[#chainPoints+1] = to.y;
	
	fixtureInfo = {	}
	
	fixtureInfo.chain = chainPoints;
	fixtureInfo.connectFirstAndLastChainVertex = false;
	
	object._subShape[#object._subShape+1] = fixtureInfo;
	allBodyFixtures[#allBodyFixtures+1] = object._subShape[#object._subShape];
	
	return object;
end
--------------------------------------------------------------------------------
function LHBodyShape:createRectangleWithDictionary(dictionary, node, scene, size, allBodyFixtures)

	local object = {_shapeName = dictionary["name"],
					_shapeID   = dictionary["shapeID"],
					_minFixtureIdForThisObject = 1,
					_maxFixtureIdForThisObject = 1,
					_subShape = {},
					}
	setmetatable(object, { __index = LHBodyShape })  -- Inheritance	
	
	local collisionFilter = {categoryBits = dictionary["category"], maskBits = dictionary["mask"] } 

	fixtureInfo = {	friction= dictionary["friction"],
					bounce	= dictionary["restitution"], 
					density = dictionary["density"],
					box		= { halfWidth = size.width*0.5*node.xScale, halfHeight = size.height*0.5*node.yScale},
					isSensor= dictionary["sensor"],
					filter  = collisionFilter
					}
					
	object._subShape[#object._subShape+1] = fixtureInfo;
	allBodyFixtures[#allBodyFixtures+1] = object._subShape[#object._subShape];
	
	return object;
end
--------------------------------------------------------------------------------
function LHBodyShape:createChainWithDictionary(dictionary, points, shouldClose, node, scene, allBodyFixtures)

	local object = {_shapeName = dictionary["name"],
					_shapeID   = dictionary["shapeID"],
					_minFixtureIdForThisObject = 1,
					_maxFixtureIdForThisObject = 1,
					_subShape = {},
					}
	setmetatable(object, { __index = LHBodyShape })  -- Inheritance	
	
	local collisionFilter = {categoryBits = dictionary["category"], maskBits = dictionary["mask"] } 

	local chainPoints = {}
			
	for i = 1, #points do
				
		local pt = points[i];
				
		pt.x = pt.x * node.xScale;
		pt.y = pt.y * node.yScale;
				
		chainPoints[#chainPoints+1] = pt.x;
		chainPoints[#chainPoints+1] = pt.y;
		
	end
	
	fixtureInfo = {	friction= dictionary["friction"],
					bounce	= dictionary["restitution"], 
					density = dictionary["density"],
					isSensor= dictionary["sensor"],
					filter  = collisionFilter,
					chain 	= chainPoints,
					connectFirstAndLastChainVertex = shouldClose;
				}
				
	object._subShape[#object._subShape+1] = fixtureInfo;
	allBodyFixtures[#allBodyFixtures+1] = object._subShape[#object._subShape];
	
	return object;
end
--------------------------------------------------------------------------------
function LHBodyShape:createTrianglesWithDictionary(dictionary, triangles, node, scene, allBodyFixtures)

	local object = {_shapeName = dictionary["name"],
					_shapeID   = dictionary["shapeID"],
					_minFixtureIdForThisObject = 1,
					_maxFixtureIdForThisObject = 1,
					_subShape = {},
					}
	setmetatable(object, { __index = LHBodyShape })  -- Inheritance	
	
	local collisionFilter = {categoryBits = dictionary["category"], maskBits = dictionary["mask"] } 

	
	local i = 1;
	while triangles[i] do
		
		local ptA = triangles[i];
		ptA.x = ptA.x * node.xScale;
		ptA.y = ptA.y * node.yScale;
		
		i = i+1;
		local ptB = triangles[i];
		ptB.x = ptB.x * node.xScale;
		ptB.y = ptB.y * node.yScale;
		
		i = i+1;
		local ptC = triangles[i];
		ptC.x = ptC.x * node.xScale;
		ptC.y = ptC.y * node.yScale;
		
		i = i+1;
		
		local shapePoints = {};
		
		shapePoints[#shapePoints+1] = ptA.x;
		shapePoints[#shapePoints+1] = ptA.y;
		
		shapePoints[#shapePoints+1] = ptB.x;
		shapePoints[#shapePoints+1] = ptB.y;
		
		shapePoints[#shapePoints+1] = ptC.x;
		shapePoints[#shapePoints+1] = ptC.y;
		
		local fixtureInfo = {	friction= dictionary["friction"],
								bounce	= dictionary["restitution"], 
								density = dictionary["density"],
								isSensor= dictionary["sensor"],
								filter  = collisionFilter,
								shape 	= shapePoints
							}
	
		object._subShape[#object._subShape+1] = fixtureInfo;
		allBodyFixtures[#allBodyFixtures+1] = object._subShape[#object._subShape];
		
	end
	
	
	return object;
end
--------------------------------------------------------------------------------
function LHBodyShape:createShapeFixturesWithDictionary(dictionary, shapeFixturesInfo, node, scene, allBodyFixtures)

	local LHUtils = require("LevelHelper2-API.Utilities.LHUtils");

	local object = {_shapeName = dictionary["name"],
					_shapeID   = dictionary["shapeID"],
					_minFixtureIdForThisObject = 1,
					_maxFixtureIdForThisObject = 1,
					_subShape = {},
					}
	setmetatable(object, { __index = LHBodyShape })  -- Inheritance	
	
	local collisionFilter = {categoryBits = dictionary["category"], maskBits = dictionary["mask"] } 


	if (shapeFixturesInfo ~= nil) then
	
		for i=1, #shapeFixturesInfo do
			local curShapeInfo = shapeFixturesInfo[i];
			
			local count = #curShapeInfo

			if(count > 2)then
		
				local shapePoints = {}
				
				local centroidTest = {};
				
				for j = 1, #curShapeInfo do
					
					local pointStr = curShapeInfo[j];
					local pt = LHUtils.pointFromString(pointStr);
					
					pt.x = pt.x * node.xScale;
					pt.y = pt.y * node.yScale;
				
					shapePoints[#shapePoints+1] = pt.x;
					shapePoints[#shapePoints+1] = pt.y;
					
					centroidTest[#centroidTest+1] = pt;
				end
				
				if(LHValidateCentroid(centroidTest))then
				
					local fixtureInfo = {	friction= dictionary["friction"],
									bounce	= dictionary["restitution"], 
									density = dictionary["density"],
									isSensor= dictionary["sensor"],
									filter  = collisionFilter,
									shape 	= shapePoints
								}
	
					object._subShape[#object._subShape+1] = fixtureInfo;
					allBodyFixtures[#allBodyFixtures+1] = object._subShape[#object._subShape];
					
				end
			end
		end
	end
	
	return object;
end
--------------------------------------------------------------------------------
function LHBodyShape:createComplexShapeWithDictionary(dictionary, node, scene, allBodyFixtures)

	local LHUtils = require("LevelHelper2-API.Utilities.LHUtils");

	local object = {_shapeName = dictionary["name"],
					_shapeID   = dictionary["shapeID"],
					_minFixtureIdForThisObject = 1,
					_maxFixtureIdForThisObject = 1,
					_subShape = {},
					}
	setmetatable(object, { __index = LHBodyShape })  -- Inheritance	
	
	local collisionFilter = {categoryBits = dictionary["category"], maskBits = dictionary["mask"] } 

 	local shapeFixturesInfo = dictionary.points;
        
	if (shapeFixturesInfo ~= nil) then
	
		for i=1, #shapeFixturesInfo do
			local curShapeInfo = shapeFixturesInfo[i];
			
			local count = #curShapeInfo

			if(count > 2)then
		
				local shapePoints = {}
				
				local centroidTest = {};
				
				for j = 1, #curShapeInfo do
					
					local pointStr = curShapeInfo[j];
					local pt = LHUtils.pointFromString(pointStr);
					
					pt.x = pt.x * node.xScale;
					pt.y = pt.y * node.yScale;
				
					shapePoints[#shapePoints+1] = pt.x;
					shapePoints[#shapePoints+1] = pt.y;
					
					centroidTest[#centroidTest+1] = pt;
				end
				
				if(LHValidateCentroid(centroidTest))then
				
					local fixtureInfo = {	friction= dictionary["friction"],
									bounce	= dictionary["restitution"], 
									density = dictionary["density"],
									isSensor= dictionary["sensor"],
									filter  = collisionFilter,
									shape 	= shapePoints
								}
	
					object._subShape[#object._subShape+1] = fixtureInfo;
					allBodyFixtures[#allBodyFixtures+1] = object._subShape[#object._subShape];
					
				end
			end
		end
	else
		local circleRadius = dictionary.radius * node.xScale;

		local centerStr = dictionary.center;
		local center = LHUtils.pointFromString(centerStr);
		
		center.x = center.x * node.xScale;
		center.y = center.y * node.yScale;
		
		if(center.x ~= 0 and center.y ~= 0)then
		
			--since corona does not support offseted cirlce shapes we will construct the circle from points and use a polygon shape
			--i guess somebody at corona did not look closely at the b2CircleShape in box2d in order to add a lua binding for .m_p property
			
			--we need to construct points circle points
        	local k_segments = 16.0;
        	local k_increment = 2.0 * math.pi / k_segments;
        	local theta = 0.0;
        
        	local maxShapePoints = 7;--its 8 but we add center to the points at the end
        	
        	local shapePoints = {};
        	
        	for i = 0, k_segments do
        	
        		local point = {x = math.cos(theta)*circleRadius, y = math.sin(theta)*circleRadius};
        		
        		point.x = point.x + center.x;
        		point.y = point.y + center.y;
        		
        		theta = theta + k_increment;
        	
        		shapePoints[#shapePoints+1] = point.x;
        		shapePoints[#shapePoints+1] = point.y;
        			
        		if(#shapePoints == maxShapePoints*2)then
        		
        			shapePoints[#shapePoints+1] = center.x;
        			shapePoints[#shapePoints+1] = center.y;
        			
        			local fixtureInfo = {	friction= dictionary["friction"],
											bounce	= dictionary["restitution"], 
											density = dictionary["density"],
											isSensor= dictionary["sensor"],
											filter  = collisionFilter,
											shape 	= shapePoints
										}
				
					object._subShape[#object._subShape+1] = fixtureInfo;
					allBodyFixtures[#allBodyFixtures+1] = object._subShape[#object._subShape];
					
					shapePoints = {};
					shapePoints[#shapePoints+1] = point.x;
        			shapePoints[#shapePoints+1] = point.y;
        		
        		end

        		previousPt = point;	
        	end
        	
        	shapePoints[#shapePoints+1] = center.x;
			shapePoints[#shapePoints+1] = center.y;
			
		
			local fixtureInfo = {	friction= dictionary["friction"],
									bounce	= dictionary["restitution"], 
									density = dictionary["density"],
									isSensor= dictionary["sensor"],
									filter  = collisionFilter,
									shape 	= shapePoints
								}
		
			object._subShape[#object._subShape+1] = fixtureInfo;
			allBodyFixtures[#allBodyFixtures+1] = object._subShape[#object._subShape];
			
					
		else
            
			fixtureInfo = {	friction= dictionary["friction"],
						bounce	= dictionary["restitution"], 
						density = dictionary["density"],
						radius  = circleRadius,
						isSensor= dictionary["sensor"],
						filter  = collisionFilter
						}
						
			object._subShape[#object._subShape+1] = fixtureInfo;
			allBodyFixtures[#allBodyFixtures+1] = object._subShape[#object._subShape];
		end
	end
	
	return object;
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
function LHBodyShape:removeSelf()

	self._minFixtureIdForThisObject = nil
 	self._maxFixtureIdForThisObject = nil
	self._shapeName = nil;
	self._shapeID = nil;
	self._subShape = nil;
	self = nil
end
