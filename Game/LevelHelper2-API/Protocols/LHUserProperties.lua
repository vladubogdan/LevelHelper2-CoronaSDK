--This file was generated automatically by LevelHelper 2
--based on the class template defined by the user.
--For more info please visit: http://www.gamedevhelper.com

module (..., package.seeall)

function customClassInstanceWithNode(__node__, __className__, __userInfo__)

	if(__className__ == nil)then return nil end;

	if(__className__ == "RobotProperty")then

		local RobotProperty = {
			_life = __userInfo__["life"],
			_myName = __userInfo__["myName"],
			_activated = __userInfo__["activated"],
			_myConnection_uuid = __userInfo__["myConnection_uuid"],
			_node = __node__
			}

		function RobotProperty:getLife() return self._life end
		function RobotProperty:setLife(__value__) self._life = __value__ end

		function RobotProperty:getMyName() return self._myName end
		function RobotProperty:setMyName(__value__) self._myName = __value__ end

		function RobotProperty:getActivated() return self._activated end
		function RobotProperty:setActivated(__value__) self._activated = __value__ end

		function RobotProperty:getMyConnection()
			if self._node ~= nil and self._myConnection_uuid ~= nil then
				return self._node:getScene():getChildNodeWithUUID(self._myConnection_uuid);
			end
			return nil
		end
		function RobotProperty:getClassName() return "RobotProperty" end

		return RobotProperty
	end

	if(__className__ == "MyOtherClass")then

		local MyOtherClass = {
			_numberProp = __userInfo__["numberProp"],
			_stringProp = __userInfo__["stringProp"],
			_boolProp = __userInfo__["boolProp"],
			_node = __node__
			}

		function MyOtherClass:getNumberProp() return self._numberProp end
		function MyOtherClass:setNumberProp(__value__) self._numberProp = __value__ end

		function MyOtherClass:getStringProp() return self._stringProp end
		function MyOtherClass:setStringProp(__value__) self._stringProp = __value__ end

		function MyOtherClass:getBoolProp() return self._boolProp end
		function MyOtherClass:setBoolProp(__value__) self._boolProp = __value__ end

		function MyOtherClass:getClassName() return "MyOtherClass" end

		return MyOtherClass
	end

	return nil
end
