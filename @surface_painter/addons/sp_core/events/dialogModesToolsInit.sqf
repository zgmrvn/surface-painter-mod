// initialize tools
_tools = (configFile >> "CfgSurfacePainter" >> "Tools") call BIS_fnc_getCfgSubClasses;

{
	if (isClass (configFile >> "CfgSurfacePainter" >> "Tools" >> _x >> "Events" >> "OnInit")) then {
		_function = getText (configFile >> "CfgSurfacePainter" >> "Tools" >> _x >> "Events" >> "OnInit" >> "function");
		_this call compile (format ["call %1", _function]);
	};
} forEach _tools;

// initialise modes
_modules = (configFile >> "CfgSurfacePainter" >> "Modules") call BIS_fnc_getCfgSubClasses;

{
	if (isClass (configFile >> "CfgSurfacePainter" >> "Modules" >> _x >> "Events" >> "OnInit")) then {
		_function = getText (configFile >> "CfgSurfacePainter" >> "Modules" >> _x >> "Events" >> "OnInit" >> "function");
		_this call compile (format ["call %1", _function]);
	};
} forEach _modules;