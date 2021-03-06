--------------------------------------------------------------------------------
--
-- LHUtils.lua
--
--!@docBegin
--!This file contains helper methods needed by the LevelHelper 2 API. Users should also find this methods useful.
--! 
--!@docEnd
--------------------------------------------------------------------------------
module (..., package.seeall)
--------------------------------------------------------------------------------
--!@docBegin
--!Loads json file and returns contents as a string.
--!@param filename The path to the json file.
--!@param base Optional parametter. Where it should look for the file. Default is system.ResourceDirectory.
function jsonFileContent( filename, base )
--!@docEnd

	-- set default base dir if none specified
	if not base then base = system.ResourceDirectory; end
	
	-- create a file path for corona i/o
	local path = system.pathForFile( filename, base )
	
    if path == nil then
        return nil;
    end
    
	-- will hold contents of file
	local contents = nil;
	
	-- io.open opens a file at path. returns nil if no file found
	local file = io.open( path, "r" )
	if file then
	   -- read all contents of file into a string
	   contents = file:read( "*a" )
	   io.close( file )	-- close the file after using it
	end
	
	return contents
end



--!@docBegin
--!Returns the extention given a path string.
--!@param path A string representing the path.
--!@code
--!    local GHUtils =  require("GameDevHelperAPI.GHUtils");
--!    local ext = GHUtils.filenameExtension("Assets/image.png");
--!    --will return "png"
--!@endcode
function filenameExtension( path )
--!@docEnd
    return path:match( "%.([^%.]+)$" )
end

--!@docBegin
--!Returns the path without the extension.
--!@param path A string representing the path.
--!@code
--!    local GHUtils =  require("GameDevHelperAPI.GHUtils");
--!    local ext = GHUtils.stripExtension("Assets/image.png");
--!    --will return "Assets/image"
--!@endcode
function stripExtension( path )
--!@docEnd

	local i = path:match( ".+()%.%w+$" )
	if ( i ) then return path:sub(1, i-1) end
	return path

end

--!@docBegin
--!Returns the path without the filename.
--!@param path A string representing the path.
--!@code
--!    local GHUtils =  require("GameDevHelperAPI.GHUtils");
--!    local ext = GHUtils.getPathFromFilename("Assets/image.png");
--!    --will return "Assets/"
--!@endcode
function getPathFromFilename(path)
--!@docEnd
	return path:match( "^(.*[/\\])[^/\\]-$" ) or ""
end

--@docBegin
--Returns only the filename, without the path component.
--@param path A string representing the path.
--!@code
--!    local GHUtils =  require("GameDevHelperAPI.GHUtils");
--!    local ext = GHUtils.getFileFromFilename("Assets/image.png");
--!    --will return "image.png"
--!@endcode
function getFileFromFilename(path)
--!@docEnd
	return path:match( "[\\/]([^/\\]+)$" ) or ""
end

--!@docBegin
--!Replace all occurances of a string with another string.
--!@param str The string to use for the replace action.
--!@param toFind The string that should be replaced.
--!@param toreplace The string that should be be used.
--!@code
--!    local GHUtils =  require("GameDevHelperAPI.GHUtils");
--!    local ext = GHUtils.replaceOccuranceOfStringWithString("Assets/image.png", "png", "JPG");
--!    --will return "Assets/image.JPG"
--!@endcode
function replaceOccuranceOfStringWithString( str, tofind, toreplace )
--!@docEnd
    tofind = tofind:gsub( "[%-%^%$%(%)%%%.%[%]%*%+%-%?]", "%%%1" )
	toreplace = toreplace:gsub( "%%", "%%%1" )
	return ( str:gsub( tofind, toreplace ) )
end

--!@docBegin
--!Returns the angle in radians
--!@param angle A numeric value representing an angle in degrees.
function LHDegreesToRadians(angle)
--!@docEnd
    return angle* 0.01745329252;
end

--!@docBegin
--!Returns the angle in degrees
--!@param angle A numeric value representing an angle in radians.
function LHRadiansToDegrees(angle)
--!@docEnd
	return angle * 57.29577951; 
end

--!@docBegin
--!Given a string like "{500, 400}", returns a table like {x = 500, y = 400}
--!@param str The string representing a point value.
function pointFromString(str)
--!@docEnd

    local xStr = 0;
	local yStr = 0;
	local function pointHelper(a,b)
		xStr = tonumber(a)
		yStr = tonumber(b)
	end

	string.gsub(str, "{(.*), (.*)}", pointHelper) 
	return  { x = xStr, y = yStr}
end

--!@docBegin
--!Given a string like "{500, 400}", returns a table like {width = 500, height = 400}
--!@param str The string representing a size value.
function sizeFromString(str)
--!@docEnd

    local wStr = 0;
	local hStr = 0;
	local function sizeHelper(a,b)
		wStr = tonumber(a)
		hStr = tonumber(b)
	end

	string.gsub(str, "{(.*), (.*)}", sizeHelper) 
	return  { width = wStr, height = hStr}
end

--!@docBegin
--!Given a string like "{{500, 400},{100,100}}", returns a table like {origin={x = 500, y = 400},size={width = 100, height = 100}}
--!@param str The string representing a rect value.
function rectFromString(str)
--!@docEnd
	local xStr = 0;
	local yStr = 0;
	local wStr = 0;
	local hStr = 0;
	local function rectHelper(a,b, c, d)
		xStr = tonumber(a)
		yStr = tonumber(b)
		wStr = tonumber(c)
		hStr = tonumber(d)
	end

	string.gsub(str, "{{(.*), (.*)}, {(.*), (.*)}}", rectHelper) 
	return  { origin={x = xStr, y = yStr}, size={width = wStr, height = hStr}};
end

--!@docBegin
--!Given a string like "{{255, 200}, {255, 255}}", returns a table like {red = 255, green = 200, blue=255, alpha=255}
--!@param str The string representing a color value.
function colorFromString(str)
--!@docEnd
    local rStr = 255;
	local gStr = 255;
	local bStr = 255;
	local aStr = 255;
	local function colorHelper(a,b,c, d)
		rStr = tonumber(a)
		gStr = tonumber(b)
		bStr = tonumber(c)
		aStr = tonumber(d)
	end

	string.gsub(str, "{{(.*), (.*)}, {(.*), (.*)}}", colorHelper) 
	return  { red = rStr, green = gStr, blue = bStr, alpha = aStr}
end

--!@docBegin
--!Copies a lua table by value
function LHDeepCopy(t)
--!@docEnd
    if type(t) ~= 'table' then return t end
        local mt = getmetatable(t)
        local res = {}
        for k,v in pairs(t) do
            if type(v) == 'table' then
            v = LHDeepCopy(v)
        end
        res[k] = v
    end
    setmetatable(res,mt)
    return res
end
--------------------------------------------------------------------------------
function positionForNodeFromUnit(node, unitPos)
    
    -- LHScene* scene = (LHScene*)[node scene];
    
    -- CGSize designSize   = [scene designResolutionSize];
    -- CGPoint offset      = [scene designOffset];
    
    local designSize = {width =display.contentWidth, 
                        height=display.contentHeight};
    
    local designPos = {x = designSize.width*unitPos.x,
                       y = designSize.height*unitPos.y};
    
    -- if([node parent] == nil ||
    --   [node parent] == scene ||
    --   [node parent] == [scene gameWorldNode] ||
    --   [node parent] == [scene uiNode]  ||
    --   [node parent] == [scene backUiNode])
    -- {
        
    --     designPos.y = designSize.height + designPos.y;
    --     designPos.x += offset.x;
    --     designPos.y += offset.y;
    -- }
    -- else{
        
    --     designPos = CGPointMake(designSize.width*unitPos.x,
    --                             ([node parent].contentSize.height - designSize.height*unitPos.y));
        
    --     CCNode* p = [node parent];
    --     designPos.x += p.contentSize.width*0.5;
    --     designPos.y -= p.contentSize.height*0.5;
    -- }
    
    return designPos;
end
--------------------------------------------------------------------------------
-- Print contents of `tbl`, with indentation.
-- `indent` sets the initial level of indentation.
function tprint (tbl, indent)
	if not indent then indent = 0 end
	for k, v in pairs(tbl) do
		formatting = string.rep("  ", indent) .. k .. ": "
		if type(v) == "table" then
			print(formatting)
			--tprint(v, indent+1)
		elseif type(v) == 'boolean' then
			print(formatting .. tostring(v))   
		elseif type(v) == 'function' then
			print(formatting .. tostring(v))   
		elseif type(v) == 'userdata' then
			print(formatting .. tostring(v))   
		else
			print(formatting .. v)
		end
	end
end
--------------------------------------------------------------------------------
function LHPrintObjectInfo(object)
	local json = require "json"
	local jsonString = json.encode( object )
	print("...............................");
	print("Object:" .. tostring(object));
	tprint(object, 2);
	-- print("...............................");
	-- print("OBJECT: " .. tostring(object) .. " INFO: " .. jsonString);
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
function LHPointOnCurve(p1, p2, p3, p4, t)
	local var1
	local var2
	local var3
    local vPoint = {x = 0.0, y = 0.0}
    
    var1 = 1 - t
    var2 = var1 * var1 * var1
    var3 = t * t * t
    vPoint.x = var2*p1.x + 3*t*var1*var1*p2.x + 3*t*t*var1*p3.x + var3*p4.x
    vPoint.y = var2*p1.y + 3*t*var1*var1*p2.y + 3*t*t*var1*p3.y + var3*p4.y

	return vPoint;
end

-- Converts degrees to a normalized vector.
function LHPointForAngle(degrees)
    local a = LHDegreesToRadians(degrees);
    return {x =math.cos(a), y = math.sin(a)};
end

function LHAngleOfLineInDegree(startPoint, endPoint)

	local angle =  (math.atan2(endPoint.y - startPoint.y, endPoint.x - startPoint.x)*180.0)/math.pi;

	while ( angle < -180.0 ) do angle = angle + 360.0 end
	while ( angle >  180.0 ) do angle = angle - 360.0 end

	return angle;
end

-- Converts a vector to degrees.
function LHPointToAngle(v)
	return LHRadiansToDegrees(math.atan2(v.y, v.x));
end

function LHPointSub(ptA, ptB)
    return { x = ptA.x - ptB.x, y = ptA.y - ptB.y};
end

function LHDot(v1, v2)
        return v1.x*v2.x + v1.y*v2.y;
end

function LHLengthSQ(v)
        return LHDot(v, v);
end

function LHLength(v)
        return math.sqrt(LHLengthSQ(v));
end

function LHDistance(v1, v2)
        return LHLength(LHPointSub(v1, v2));
end


function LHNormalAbsoluteAngleDegrees(angle)
    local fAngle = math.fmod(angle, 360.0);
    if(fAngle >= 0)then
    	return fAngle;
    end
   	return fAngle + 360.0;
end
