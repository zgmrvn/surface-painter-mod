if (getNumber (missionconfigfile >> "allowFunctionsRecompile") == 0) exitWith {
	["allowFunctionsRecompile == 0"] call BIS_fnc_error;
};

private _start = diag_tickTime;

// core
call compile preprocessFileLineNumbers "x\surface_painter\addons\sp_core\recompile.sqf";

// modules
private _modules = (configFile >> "CfgSurfacePainter" >> "Modules") call BIS_fnc_getCfgSubClasses;

{
	private _recompile = getText (configFile >> "CfgSurfacePainter" >> "Modules" >> _x >> "recompile");

	if (_recompile != "") then {
		call compile preprocessFileLineNumbers _recompile;
	};
} forEach _modules;

// tools
private _tools = (configFile >> "CfgSurfacePainter" >> "Tools") call BIS_fnc_getCfgSubClasses;

{
	private _recompile = getText (configFile >> "CfgSurfacePainter" >> "Tools" >> _x >> "recompile");

	if (_recompile != "") then {
		call compile preprocessFileLineNumbers _recompile;
	};
} forEach _tools;

systemChat format ["functions recompiled in %1 ms", round ((diag_tickTime - _start) * 1000)];
