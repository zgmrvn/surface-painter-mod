/*
	Function: SP_fnc_edge_generate

	Description:
		Generate objects along the line.

	Parameters:
		_line: array of positions describing a line
		_interval: interval between objects
		_spread: max spread for objects
		_pool: array of possible classnames

	Example:
		(begin example)
		SP_var_edge_tempObjects = [
			[[0, 0, 0], [10, 10, 0]],
			10,
			0,
			["Land_Ficus_01_F", "Land_Ficus_02_F"]
		] call SP_fnc_edge_generate;
		(end)

	Returns:
		_objects: array of created objects

	Author:
		zgmrvn
*/

private _line		= param [0, [], [[]]];
private _interval	= param [1, 10, [0]];
private _spread		= param [2, 0, [0]];
private _pool		= param [3, [], [[]]];

private _count			= (count _line) - 1;
private _progression	= 0; // progression on the segment lenght
private _rest			= 0; // what part of the interval remains when you reached the end of a segment

private _objects = []; // objects that will be created

// iterate throught all segments of the line
for [{private _i = 0}, {_i < _count}, {_i = _i + 1}] do {
	private _current	= _line select _i;
	_current set [2, 0];
	private _next		= _line select (_i + 1);
	_next set [2, 0];
	private _distance	= [_current, _next] call BIS_fnc_distance2D;
	private _dir		= [_current, _next] call BIS_fnc_dirTo;

	// reset the progression
	_progression = 0;

	// progress along the segment as long as this variable is true
	// this variable will be true as long as the progression length is lower than the segment length
	private _loop = true;

	while {_loop} do {
		// as long as the progression + the rest of the previous iteration is lower than
		// the total distance of the segment, we create an object
		if ((_rest + _progression) < _distance) then {
			private _pos = [_current, _rest + _progression, _dir] call BIS_fnc_relPos;

			// if spread > 0, we spread the object
			if (_spread > 0) then {
				_pos = [_pos, random _spread, random 360] call BIS_fnc_relPos;
			};

			private _classname = selectRandom _pool;
			private _poolEntry = [SP_var_pool_pool, _classname] call BIS_fnc_getFromPairs;

			// zOffset and followTerrain
			private _keepHorizontal = !([_poolEntry, "followTerrain"] call BIS_fnc_getFromPairs);
			private _zOffset = [_poolEntry, "zOffset"] call BIS_fnc_getFromPairs;

			private _obj = [(ATLToASL _pos) vectorAdd [0, 0, _zOffset], _classname,  _keepHorizontal] call SP_fnc_core_createSimpleObject;

			// scale
			private _scaleMin = [_poolEntry, "scaleMin"] call BIS_fnc_getFromPairs;
			private _scaleMax = [_poolEntry, "scaleMax"] call BIS_fnc_getFromPairs;
			private _scale = _scaleMin + random (_scaleMax - _scaleMin);

			_obj setVariable ["SP_var_scale", _scale];

			// push to created objects array
			_objects pushBack _obj;

			_progression = _progression + _interval;

		// else, we calculate the rest of the interval for the next iteration
		// and we break the loop
		} else {
			_rest = _interval - (_distance - ((_rest + _progression) - _interval));
			_loop = false;
		};
	};
};

_objects
