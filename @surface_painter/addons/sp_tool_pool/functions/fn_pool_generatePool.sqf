private _final = [];

{
	_c = _x select 0;

	for [{private _i = (_x select 1) * 10}, { _i > 0}, {_i = _i - 1}] do {
		_final pushBack _c;
	};
} forEach _this;

_final
