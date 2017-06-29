// event on mouse move according to the current mode
if (isClass (configFile >> "CfgSurfacePainter" >> "Modules" >> SP_var_mode >> "Events" >> "OnMouseMove")) then {
	_function = getText (configFile >> "CfgSurfacePainter" >> "Modules" >> SP_var_mode >> "Events" >> "OnMouseMove" >> "function");
	call compile (format ["call %1", _function]);
};
