if (_button == 1) then {
	SP_var_secondaryMouseButton = false;
};

if (_button == 0) then {
	SP_var_primaryMouseButton = false;

	// event on mouse up according to the current mode
	if (isClass (configFile >> "CfgSurfacePainter" >> "Modules" >> SP_var_mode >> "Events" >> "OnPrimaryMouseButtonUp")) then {
		_function = getText (configFile >> "CfgSurfacePainter" >> "Modules" >> SP_var_mode >> "Events" >> "OnPrimaryMouseButtonUp" >> "function");
		call compile (format ["call %1", _function]);
	};
};
