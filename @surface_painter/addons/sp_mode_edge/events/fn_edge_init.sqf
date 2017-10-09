/*
	Edge - Init
	This function runs when Surface Painter interface is open.
*/

// exposed
// SP_var_edge_controls	= []; // contains editable controls
SP_var_edge_line		= []; // contains the positions that represents the line

// inteval between objects created on the line
if (isNil "SP_var_edge_interval") then {
	SP_var_edge_interval = 10;
};

// spread of created objects according to their origin position
if (isNil "SP_var_edge_spread") then {
	SP_var_edge_spread = 0;
};

// internal

// edge mode : DRAW, LOWER, HIGHER, CLIFF
if (isNil "SP_var_edge_mode") then {
	SP_var_edge_mode = "DRAW";
};

SP_var_edge_anchor		= []; // needed to detect the direction the mouse move
SP_var_edge_tempObjects	= []; // temporary objects for the refresh when options are changed

// checkboxes
{
	_x params ["_control", "_mode"];

	_checkBoxControl = [SP_var_edge_controls, _control] call BIS_fnc_getFromPairs;

	if (SP_var_edge_mode == _mode) then {
		_checkBoxControl cbSetChecked true;
	};

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
	["Default", "DRAW"],
	["Lower", "LOWER"],
	["Higher", "HIGHER"],
	["Cliff", "CLIFF"]
];

// interval
private _intervalControl = [SP_var_edge_controls, "Interval"] call BIS_fnc_getFromPairs;
_intervalControl ctrlSetText str SP_var_edge_interval;
_intervalControl ctrlAddEventHandler ["MouseZChanged", {
	_mouseWheel	= [-1, 1] select ((_this select 1) > 0);
	_before		= parseNumber (ctrlText (_this select 0));
	_after		= (_before + _mouseWheel) max 1;

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
_spreadControl ctrlSetText str SP_var_edge_spread;
_spreadControl ctrlAddEventHandler ["MouseZChanged", {
	_mouseWheel	= [-1, 1] select ((_this select 1) > 0);
	_before		= parseNumber (ctrlText (_this select 0));
	_after		= (_before + _mouseWheel) max 0;

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
	} else {
		["NOK", localize "STR_SP_TOOL_POOL_NOTIFICATION_OBJECT_POOL_EMPTY"] spawn SP_fnc_core_pushNotification;
	};
}];
