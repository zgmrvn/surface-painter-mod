private _final = [];
private ["_c"];

{
	_c = _x select 0;
	_p = [_x select 1, "probability"] call BIS_fnc_getFromPairs;

	for [{private _i = _p * 10}, { _i > 0}, {_i = _i - 1}] do {
		_final pushBack _c;
	};
} forEach _this;

_final
