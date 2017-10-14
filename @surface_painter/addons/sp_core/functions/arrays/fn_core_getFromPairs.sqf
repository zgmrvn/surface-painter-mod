private _array = param [0, scriptNull, [[]]];
private _key = param [1, "", [""]];

if !(_array isEqualType []) exitWith { ["Array expected: %1", _array] call BIS_fnc_error };
if (count _array != 2) exitWith { ["Invalid array: %1", _array] call BIS_fnc_error };
if (_key == "") exitWith { ["Invalid key: %1", _key] call BIS_fnc_error };

_array params ["_keys", "_values"];

private _index = _keys find _key;

if (_index != -1) exitWith {
	_values select _index;
};

nil
