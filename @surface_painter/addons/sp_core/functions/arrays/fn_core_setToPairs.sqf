private _array = param [0, scriptNull, [[]]];
private _key = param [1, "", [""]];
private _value = param [2, "", []];

if !(_array isEqualType []) exitWith { ["Array expected: %1", _array] call BIS_fnc_error };
if ((count _array % 2) != 0) exitWith { ["Invalid array: %1", _array] call BIS_fnc_error };
if (_key == "") exitWith { ["Invalid key: %1", _key] call BIS_fnc_error };

if (_array isEqualTo []) then {
	_array pushBack []; // keys
	_array pushBack []; // values
};

_array params ["_keys", "_values"];

private _index = _keys find _key;

if (_index != -1) then {
	_keys set [_index, _key];
	_values set [_index, _value];
} else {
	_keys pushBack _key;
	_values pushBack _value;
};
