/*
	Init for Brush mode.
	This function will run when Surface Painter interface is open.
*/

// exposed
// SP_var_brush_controls	= []; // contains editable controls
SP_var_brush_distance		= 0; // distance between objects option
SP_var_brush_flow			= 20; // how many objects can be created in 1 second

// internal
SP_var_brush_loop = false; // controls the brush loop

// behaviour
private _distanceControl = [SP_var_brush_controls, "Distance"] call BIS_fnc_getFromPairs;
_distanceControl ctrlAddEventHandler ["MouseZChanged", {
	_mouseWheel	= [-1, 1] select ((_this select 1) > 0);
	_distance	= parseNumber (ctrlText (_this select 0));
	_distance	= (_distance + _mouseWheel) max 0;

	SP_var_brush_distance = _distance;
	(_this select 0) ctrlSetText (str _distance);
}];

private _flowControl = [SP_var_brush_controls, "Flow"] call BIS_fnc_getFromPairs;
_flowControl ctrlAddEventHandler ["MouseZChanged", {
	_mouseWheel	= [-1, 1] select ((_this select 1) > 0);
	_flow		= parseNumber (ctrlText (_this select 0));
	_flow		= (_flow + _mouseWheel) max 1;

	SP_var_brush_flow = _flow;
	(_this select 0) ctrlSetText (str _flow);
}];
