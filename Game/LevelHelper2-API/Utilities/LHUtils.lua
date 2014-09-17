
module (..., package.seeall)

--!@docBegin
--!This file contains helper methods needed by the GameDevHelper API. Users should also find this methods useful.
--! 
--!@docEnd

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
	local function pointHelper(a,b)
		wStr = tonumber(a)
		hStr = tonumber(b)
	end

	string.gsub(str, "{(.*), (.*)}", pointHelper) 
	return  { width = wStr, height = hStr}
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
	local function pointHelper(a,b,c, d)
		rStr = tonumber(a)
		gStr = tonumber(b)
		bStr = tonumber(c)
		aStr = tonumber(d)
	end

	string.gsub(str, "{{(.*), (.*)}, {(.*), (.*)}}", pointHelper) 
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
            v = GHDeepCopy(v)
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


--function lh_sizeFromString(str)
--
--	local wStr = 0;
--	local hStr = 0;
--	
--	local function sizeHelper(a, b)
--		wStr = tonumber(a)
--		hStr = tonumber(b)
--	end
--	local retinaRatio = 1; --should be added shortly in LHSettings
--	
--	string.gsub(str, "{(.*), (.*)}", sizeHelper) 
--	return  { width = wStr/retinaRatio, height = hStr/retinaRatio}				
--end
--function lh_printSize(obj)
--
--	print("{ size = { width: " .. tostring(obj.width) .. " height: " .. tostring(obj.height) .. " }}");
--end

--------------------------------------------------------------------------------
--function lh_rectFromString(str)
--
--	local xStr = 0;
--	local yStr = 0;
--	local wStr = 0;
--	local hStr = 0;
--
--	local function rectHelper(a, b, c, d)
--		xStr = tonumber(a)
--		yStr = tonumber(b)
--		wStr = tonumber(c)
--		hStr= tonumber(d)
--	end
--
--	local retinaRatio = 1; --should be added shortly in LHSettings
--
--	string.gsub(str, "{{(.*), (.*)}, {(.*), (.*)}}", rectHelper)
--	return { origin = {x = xStr*retinaRatio, y = yStr*retinaRatio}, 
--			   size = {width = wStr*retinaRatio, height = hStr*retinaRatio}}
--end

function LHPrintObjectInfo(object)
    local json = require "json"
    local jsonString = json.encode( object )
    print("OBJECT: " .. tostring(object) .. " INFO: " .. jsonString);
end