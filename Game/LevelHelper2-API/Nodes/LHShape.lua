--------------------------------------------------------------------------------
--
-- LHShape.lua
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--!@docBegin
--!Get the triangle points of the shape.
local function trianglePoints(_shapeObj)
--!@docEnd
	return _shapeObj._shapeTriangles;
end

--------------------------------------------------------------------------------
--!@docBegin
--!Get the outline points of the shape.
local function outlinePoints(_shapeObj)
--!@docEnd
	return _shapeObj._outlinePoints;
end


local LHShape = {}
function LHShape:nodeWithDictionary(dict, prnt)

	if (nil == dict) then
		print("Invalid LHShape initialization!")
	end
				
	local LHUtils = require("LevelHelper2-API.Utilities.LHUtils");
    local LHNodeProtocol = require('LevelHelper2-API.Protocols.LHNodeProtocol')
    local LHPhysicsProtocol = require('LevelHelper2-API.Protocols.LHPhysicsProtocol')
    
    local object = display.newGroup();
   
    --add all LevelHelper 2 valid properties to the object
	object.nodeType = "LHShape"
	
	--add LevelHelper methods
    object.trianglePoints = trianglePoints;
    object.outlinePoints = outlinePoints;
    
    prnt:addChild(object);
	
	
	LHNodeProtocol.initNodeProtocolWithDictionary(dict, object);
	
	local convert = {x = 1.0, y = 1.0};
	
	local value = dict["colorOverlay"];
    local color = nil;
    if(value)then
        color = LHUtils.colorFromString(value);
    end
    
 	object._outlinePoints = {};
 	local vertices = {};
 	
 	local points = dict["points"];
  	for i = 1, #points do
        
        local pointDict = points[i];
        
        local vPoint = LHUtils.pointFromString(pointDict["point"]);
            
        object._outlinePoints[#object._outlinePoints+1] = {	x = vPoint.x*convert.x, 
											 				y = vPoint.y*convert.y}
							
		vertices[#vertices+1] = vPoint.x*convert.x;
		vertices[#vertices+1] = vPoint.y*convert.y;
    end        
 
 	local polygon = display.newPolygon( object, 0, 0, vertices );
 	polygon:setFillColor( color.red, color.green, color.blue, color.alpha );
 	
 	--"relativeImagePath" : "\/Game\/tile.png",
 	--"tileTexture" : true,
 	
 	local relativeImagePath = dict["relativeImagePath"];
 	if(relativeImagePath)then
		polygon.fill = { type="image", filename=relativeImagePath }
 	end
 
 	object._shapeTriangles = {};
 	local triangles = dict["triangles"];
 	
 	for i = 1, #triangles do
        
        local triangleInfo = triangles[i];
        
         local vPoint = LHUtils.pointFromString(triangleInfo["point"]);
         	
         object._shapeTriangles[#object._shapeTriangles +1] = {	x = vPoint.x*convert.x, 
         														y = vPoint.y*convert.y};
         
         --{
         --     "color" : "{{1.000000, 1.000000}, {1.000000, 1.000000}}",
         --     "alpha" : 255,
         --     "point" : "{-0.000001, -16.000000}",
         --     "uv" : "{0.890625, 0.500000}"
         --},
           
    end

	LHPhysicsProtocol.initPhysicsProtocolWithDictionary(dict["nodePhysics"], object, prnt:getScene());
	LHNodeProtocol.loadChildrenForNodeFromDictionary(object, dict);

	return object
end
--------------------------------------------------------------------------------
return LHShape;