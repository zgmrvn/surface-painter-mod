_actions = ["MoveForward", "MoveBack", "TurnLeft", "TurnRight", "LeanLeft", "MoveDown"];

{
	if ((_this select 1) in (actionKeys _x)) then {
		[SP_var_cameraKeys, _x, false] call BIS_fnc_setToPairs;
	};
} forEach _actions;

if (({[SP_var_cameraKeys, _x] call BIS_fnc_getFromPairs} count _actions) == 0) then {
	SP_var_while = false;
};
