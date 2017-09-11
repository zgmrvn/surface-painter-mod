/*
	Init for Edge mode.
	This function will run when Surface Painter interface is open.
*/

// exposed
// SP_var_edge_controls	= 0; // contains editable controls
SP_var_edge_line		= []; // contains the positions that represents the line
SP_var_edge_interval	= 10; // inteval between objects created on the line
SP_var_edge_spread		= 0; // spread of created objects according to their origin position

// internal
SP_var_edge_mode		= "DRAW"; // edge mode : DRAW, LOWER, HIGHER, CLIFF
SP_var_edge_anchor		= []; // needed to detect the direction the mouse move
SP_var_edge_tempObjects	= []; // temporary objects for the refresh when options are changed

// checkboxes
{
	private _checkBoxControl = [SP_var_edge_controls, _x] call BIS_fnc_getFromPairs;

	_checkBoxControl ctrlAddEventHandler ["CheckedChanged", {
		{
			if ((_x select 0) != (_this select 0)) then {
				(_x select 0) cbSetChecked false;
			} else {
				(_x select 0) cbSetChecked true;
				SP_var_edge_mode = _x select 1;
			};
		} forEach [
			[[SP_var_edge_controls, "Default"] call BIS_fnc_getFromPairs, "DRAW"],
			[[SP_var_edge_controls, "Lower"] call BIS_fnc_getFromPairs, "LOWER"],
			[[SP_var_edge_controls, "Higher"] call BIS_fnc_getFromPairs, "HIGHER"],
			[[SP_var_edge_controls, "Cliff"] call BIS_fnc_getFromPairs, "CLIFF"]
		];
	}];
} forEach [
	"Default",
	"Lower",
	"Higher",
	"Cliff"
];

// interval
private _intervalControl = [SP_var_edge_controls, "Interval"] call BIS_fnc_getFromPairs;
_intervalControl ctrlAddEventHandler ["MouseZChanged", {
	private _mouseWheel	= [-1, 1] select ((_this select 1) > 0);
	private _before		= parseNumber (ctrlText (_this select 0));
	private _after		= (_before + _mouseWheel) max 1;

	// if the previous interval is different of the new
	if (_after != _before) then {
		SP_var_edge_interval = _after;
		(_this select 0) ctrlSetText (str _after);

		// if the object pool is not empty
		if ((count SP_var_pool_finalPool) > 0) then {
			// regenerate temp objects
			call SP_fnc_edge_regenerate;
		};
	};
}];

// spread
private _spreadControl = [SP_var_edge_controls, "Spread"] call BIS_fnc_getFromPairs;
_spreadControl ctrlAddEventHandler ["MouseZChanged", {
	private _mouseWheel	= [-1, 1] select ((_this select 1) > 0);
	private _before		= parseNumber (ctrlText (_this select 0));
	private _after		= (_before + _mouseWheel) max 0;

	// if the previous spread is different from the new
	if (_after != _before) then {
		SP_var_edge_spread = _after;
		(_this select 0) ctrlSetText (str _after);

		// if the object pool is not empty
		if ((count SP_var_pool_finalPool) > 0) then {
			// regenerate temp objects
			call SP_fnc_edge_regenerate;
		};
	};
}];

// generate
private _generateControl = [SP_var_edge_controls, "Generate"] call BIS_fnc_getFromPairs;
_generateControl ctrlAddEventHandler ["ButtonClick", {
	// if the object pool is not empty
	if ((count SP_var_pool_finalPool) > 0) then {
		// regenerate temp objects
		SP_var_edge_tempObjects = [SP_var_edge_line, SP_var_edge_interval, SP_var_edge_spread, SP_var_pool_finalPool] call SP_fnc_edge_generate;
	};
}];
