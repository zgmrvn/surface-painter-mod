SP_var_core_camera cameraEffect ["terminate", "back"];
camDestroy SP_var_core_camera;
showCinemaBorder false;
showHUD true;

/*
if !(isNil {SP_var_mode}) then {
	// desactivate tools
	_tools = getArray (configFile >> "CfgSurfacePainter" >> "Modules" >> SP_var_mode >> "tools");

	{
		if (isClass (configFile >> "CfgSurfacePainter" >> "Tools" >> _x >> "Events" >> "OnDesactivate")) then {
			_function = getText (configFile >> "CfgSurfacePainter" >> "Tools" >> _x >> "Events" >> "OnDesactivate" >> "function");
			call compile (format ["call %1", _function]);
		};
	} forEach _tools;

	// desactivate modules
	if (isClass (configFile >> "CfgSurfacePainter" >> "Modules" >> SP_var_mode >> "Events" >> "OnDesactivate")) then {
		_function = getText (configFile >> "CfgSurfacePainter" >> "Modules" >> SP_var_mode >> "Events" >> "OnDesactivate" >> "function");
		call compile (format ["call %1", _function]);
	};
};

SP_var_primaryMouseButton = nil;
SP_var_secondaryMouseButton = nil;
SP_var_mouseScreenDelta = nil;
SP_var_mouseScreenPosition = nil;
SP_var_cameraDir = nil;
SP_var_cameraPitch = nil;
SP_var_while = nil;
SP_var_leftPanelOpen = nil;
*/