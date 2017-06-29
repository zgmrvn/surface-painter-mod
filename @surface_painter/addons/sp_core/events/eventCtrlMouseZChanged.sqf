// tools events according to the current mode
_tools = getArray (configFile >> "CfgSurfacePainter" >> "Modules" >> SP_var_mode >> "tools");

{
	if (isClass (configFile >> "CfgSurfacePainter" >> "Tools" >> _x >> "Events" >> "OnMouseZChange")) then {
		_function = getText (configFile >> "CfgSurfacePainter" >> "Tools" >> _x >> "Events" >> "OnMouseZChange" >> "function");
		_this call compile (format ["call %1", _function]);
	};
} forEach _tools;

// mode event according to the current mode
if (isClass (configFile >> "CfgSurfacePainter" >> "Modules" >> SP_var_mode >> "Events" >> "OnMouseZChange")) then {
	_function = getText (configFile >> "CfgSurfacePainter" >> "Modules" >> SP_var_mode >> "Events" >> "OnMouseZChange" >> "function");
	_this call compile (format ["call %1", _function]);
};
