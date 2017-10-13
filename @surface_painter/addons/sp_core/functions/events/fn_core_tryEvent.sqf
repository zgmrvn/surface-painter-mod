/*

*/

params ["_mode", "_moduleOrTool", "_event"];

if !(toUpper _mode in ["MODULE", "TOOL"]) exitWith {
	["_mode must be ""MODULE"" or ""TOOL"": %1"] call BIS_fnc_error;
};

// generate config path
private _config = configFile >> "CfgSurfacePainter";

switch (toUpper _mode) do {
	case "MODULE": { _config = _config >> "Modules" };
	case "TOOL": { _config = _config >> "Tools" };
};

_config = _config >> _moduleOrTool >> "Events" >> _event;

// try event
if (isClass _config) then {
	private _script = getText (_config >> "script");
	call compile format ["call SP_event_%1_%2", _moduleOrTool, _event];
};
