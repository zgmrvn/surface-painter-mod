/*
	Circle - Activation
	This function runs when switching on a mode that uses this tool.
*/

#include "..\defines.hpp"

SP_var_circle_circle = [];

// computes relative positions of the cirle's points
// they will be vector-added to the actual world position of the mouse
for [{private _i = 0}, {_i < 360}, {_i = _i + 15}] do {
	private _a = [];

	_a set [0, (sin _i) * SP_var_circle_circleRadius];
	_a set [1, (cos _i) * SP_var_circle_circleRadius];
	_a set [2, SP_var_circle_circleDiameter * Z_FACTOR];

	SP_var_circle_circle pushBack _a;
};

// on each frame, draw the circle
["circle", "onEachFrame", {
	_color = [[0, 1, 0, 1], [1, 0.5, 0, 1]] select SP_key_alt;
	_i = (count SP_var_circle_circle) - 1;

	drawLine3D [
		SP_var_mouseWorldPosition vectorAdd (SP_var_circle_circle select _i),
		SP_var_mouseWorldPosition vectorAdd (SP_var_circle_circle select 0),
		_color
	];

	while {_i > 0} do {
		drawLine3D [
			SP_var_mouseWorldPosition vectorAdd (SP_var_circle_circle select _i),
			SP_var_mouseWorldPosition vectorAdd (SP_var_circle_circle select (_i - 1)),
			_color
		];
		_i = _i - 1;
	};
}] call BIS_fnc_addStackedEventHandler;
