/*
	Brush - Init
	This function runs when Surface Painter interface is open.
*/

// exposed
// SP_var_brush_controls = []; // contains editable controls

// distance between objects option
if (isNil "SP_var_brush_distance") then {
	SP_var_brush_distance = 0;
};

// how many objects can be created in 1 second
if (isNil "SP_var_brush_flow") then {
	SP_var_brush_flow = 20;
};

// internal
SP_var_brush_loop = false; // controls the brush loop

// distance
private _distanceControl = [SP_var_brush_controls, "Distance"] call BIS_fnc_getFromPairs;
_distanceControl ctrlSetText str SP_var_brush_distance;
_distanceControl ctrlAddEventHandler ["MouseZChanged", {
	_mouseWheel	= [-1, 1] select ((_this select 1) > 0);
	_distance	= parseNumber (ctrlText (_this select 0));
	_distance	= (_distance + _mouseWheel) max 0;

	SP_var_brush_distance = _distance;
	(_this select 0) ctrlSetText (str _distance);
}];

// flow
private _flowControl = [SP_var_brush_controls, "Flow"] call BIS_fnc_getFromPairs;
_flowControl ctrlSetText str SP_var_brush_flow;
_flowControl ctrlAddEventHandler ["MouseZChanged", {
	_mouseWheel	= [-1, 1] select ((_this select 1) > 0);
	_flow		= parseNumber (ctrlText (_this select 0));
	_flow		= (_flow + _mouseWheel) max 1;

	SP_var_brush_flow = _flow;
	(_this select 0) ctrlSetText (str _flow);
}];
