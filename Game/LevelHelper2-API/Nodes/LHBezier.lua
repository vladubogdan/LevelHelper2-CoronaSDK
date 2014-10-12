--------------------------------------------------------------------------------
--!@docBegin
--!Get the line points of the bezier shape.
function linePoints(_bezierObj)
--!@docEnd
	return _bezierObj._linePoints;
end

local LHBezier = {}
function LHBezier:nodeWithDictionary(dict, prnt)

	if (nil == dict) then
		print("Invalid LHBezier initialization!")
	end
				
	local LHUtils = require("LevelHelper2-API.Utilities.LHUtils");
    local LHNodeProtocol = require('LevelHelper2-API.Protocols.LHNodeProtocol')
    local LHPhysicsProtocol = require('LevelHelper2-API.Protocols.LHPhysicsProtocol')
    
    local object = display.newGroup();
    
    --add all LevelHelper 2 valid properties to the object
	object.nodeType = "LHBezier"
	
    local points = dict["points"];
    local closed = dict["closed"];

    object._linePoints = {};
        
    local convert = {x = 1.0, y = 1.0};
    
    local prevPt = nil;
    local previousPointDict = nil;
    
    --Specific sprites properties
    ----------------------------------------------------------------------------
    local value = dict["colorOverlay"];
    local color = nil;
    if(value)then
        color = LHUtils.colorFromString(value);
    end
    
    local MAX_STEPS = 25;
    
    for i = 1, #points do
        
        local pointDict = points[i];
        
        if(previousPointDict ~= nil)then
               
            local control1 = LHUtils.pointFromString(previousPointDict["ctrl2"]);
            if false == previousPointDict["hasCtrl2"] then
                control1 = LHUtils.pointFromString(previousPointDict["mainPt"]);
            end
                
            
            local control2 = LHUtils.pointFromString(pointDict["ctrl1"]);
            if false == pointDict["hasCtrl1"] then
                control2 = LHUtils.pointFromString(pointDict["mainPt"]);
            end
                
            
            
            local previousMainPt = LHUtils.pointFromString(previousPointDict["mainPt"]);
            local mainPt = LHUtils.pointFromString(pointDict["mainPt"]);
                
            local t = 0.0
            while ( t >= 0.0 and  t <= 1 + (1.0 / MAX_STEPS) ) do
                
                local vPoint = LHUtils.LHPointOnCurve(previousMainPt, control1, control2, mainPt, t);
                
                object._linePoints[#object._linePoints+1] = {x = vPoint.x*convert.x, 
											 				y = vPoint.y*convert.y}
																	
                if prevPt then
                    local line = display.newLine( object, prevPt.x, prevPt.y, vPoint.x, vPoint.y );
                    line:setStrokeColor(color.red, color.green, color.blue);
                end
                
                prevPt = vPoint;
                
    		    t = t + 1.0 / MAX_STEPS
            end
        end
        previousPointDict = pointDict;
    end
    
    if closed == true then
        if #points  > 1 then
            
            local pointDict = points[1];
            
            local control1 = LHUtils.pointFromString(previousPointDict["ctrl2"]);
            if false == previousPointDict["hasCtrl2"] then
                control1 = LHUtils.pointFromString(previousPointDict["mainPt"]);
            end   
            
            local control2 = LHUtils.pointFromString(pointDict["ctrl1"]);
            if false == pointDict["hasCtrl1"] then
                control2 = LHUtils.pointFromString(pointDict["mainPt"]);
            end
            

            local previousMainPt = LHUtils.pointFromString(previousPointDict["mainPt"]);
            local mainPt = LHUtils.pointFromString(pointDict["mainPt"]);
                
            local t = 0.0
            while ( t >= 0.0 and  t <= 1 + (1.0 / MAX_STEPS) ) do
                
                local vPoint = LHUtils.LHPointOnCurve(previousMainPt, control1, control2, mainPt, t);
                
                object._linePoints[#object._linePoints+1] = {x = vPoint.x*convert.x, 
											 				y = vPoint.y*convert.y}
																	
                if prevPt then
                    local line = display.newLine( object, prevPt.x, prevPt.y, vPoint.x, vPoint.y );
                    line:setStrokeColor(color.red, color.green, color.blue);
                end
                
                prevPt = vPoint;
                
    		    t = t + 1.0 / MAX_STEPS
            end
        end
    end
    
    --add LevelHelper methods
    object.linePoints = linePoints;

	prnt:addChild(object);
	
	LHNodeProtocol.initNodeProtocolWithDictionary(dict, object);
	LHPhysicsProtocol.initPhysicsProtocolWithDictionary(dict["nodePhysics"], object, prnt:getScene());
	LHNodeProtocol.loadChildrenForNodeFromDictionary(object, dict);

	return object
end
--------------------------------------------------------------------------------
return LHBezier;