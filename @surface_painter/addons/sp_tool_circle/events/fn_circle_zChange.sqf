/*
	Resize Circle when mouse wheel change.
*/

#include "..\defines.hpp"

// if shift pressed, multiplier is 10
private _multiplier = [1, 10] select SP_key_shift;

SP_var_circle_circleDiameter = (SP_var_circle_circleDiameter + (_this select 1) * _multiplier) max 1;
SP_var_circle_circleRadius = SP_var_circle_circleDiameter * 0.5;

// compute new relative positions of the cirle
for [{private _i = 0; private _a = 0;}, {_i < 24}, {_i = _i + 1; _a = _a + 15;}] do {
	private _r = [0, 0, 0];

	_r set [0, (sin _a) * SP_var_circle_circleRadius];
	_r set [1, (cos _a) * SP_var_circle_circleRadius];
	_r set [2, SP_var_circle_circleDiameter * Z_FACTOR];

	SP_var_circle_circle set [_i, _r];
};
