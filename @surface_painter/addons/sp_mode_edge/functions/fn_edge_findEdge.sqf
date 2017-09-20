/*
	Function: SP_fnc_edge_findEdge

	Description:
		Find a suitable position around _center according to _distance and _mode.

	Parameters:
		_center: position array
		_distance: search radius
		_mode: search mod, possible values : "DRAW", "HIGHER", "CLIFF", "LOWER"
		_dir: the direction in which to search for a suitable position

	Example:
		(begin example)
		_pos = [[5821, 2820, 0], 15, "DRAW", 45] call SP_fnc_edge_findEdge;
		(end)

	Returns:
		_position: ATL position array

	Author:
		zgmrvn, commy2, cptnnick
*/

private _center		= param [0, [0, 0, 0], [[]], 3];
private _distance	= param [1, 1, [0]];
private _mode		= param [2, "DRAW", [""]];
private _dir		= param [3, nil, [0]];

private _p = []; // possible positions
private _f = [0, 0, 0]; // final position

// if mode not DRAW (default)
if (_mode in ["HIGHER", "CLIFF", "LOWER"]) then {
	private _o = [_center, _distance, _dir - 90] call BIS_fnc_relPos;

	for [{ private _i = 0 }, { _i < _distance * 2 }, { _i = _i + 1 }] do {
		private _t = AGLToASL ([_o, _i, _dir + 90] call BIS_fnc_relPos);

		_p pushBack _t;
	};

// else, mode is DRAW
} else {
	for [{ private _i = 0; private _h = 0; }, { _i < _distance }, { _i = _i + 1; _h = _h + 45; }] do {
		private _t = AGLToASL ([_center, _i, _h] call BIS_fnc_relPos);

		_p pushBack _t;
	};
};

// sort according to edge mode
switch (_mode) do {
	case "LOWER_FIRST";
	case "LOWER": {
		_f = [0, 0, 10000];

		{
			if ((_x select 2) < (_f select 2)) then {
				_f = _x;
			};
		} forEach _p;
	};

	case "HIGHER_FIRST";
	case "HIGHER": {
		_f = [0, 0, -10000];

		{
			if ((_x select 2) > (_f select 2)) then {
				_f = _x;
			};
		} forEach _p;
	};

	case "CLIFF_FIRST";
	case "CLIFF": {
		private _a = 0;

		{
			private _acos = acos ([0,0,1] vectorDotProduct (surfaceNormal _x));

			if (_acos > _a) then {
				_a = _acos;
				_f = _x;
			};
		} forEach _p;
	};
};

_f set [2, 0];

_f
