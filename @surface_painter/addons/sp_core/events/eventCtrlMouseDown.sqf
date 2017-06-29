if (_button == 1) then {
	SP_var_secondaryMouseButton = true;
};

if (_button == 0) then {
	SP_var_primaryMouseButton = true;

	// event on mouse down according to the current mode
	if (isClass (configFile >> "CfgSurfacePainter" >> "Modules" >> SP_var_mode >> "Events" >> "OnPrimaryMouseButtonDown")) then {
		_function = getText (configFile >> "CfgSurfacePainter" >> "Modules" >> SP_var_mode >> "Events" >> "OnPrimaryMouseButtonDown" >> "function");
		call compile (format ["call %1", _function]);
	};
};
