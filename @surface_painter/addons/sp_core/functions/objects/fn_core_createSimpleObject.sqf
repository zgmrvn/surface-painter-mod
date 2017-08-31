/*
	function : SP_fnc_core_createSimpleObject
	description : creates simple object

	params :
		position : ARRAY - position array, ASL format
		classname : STRING - object classname
	    keepHorizontal (optionnal) : BOOL - keep horizontal placement - Default false
*/

private _position		= param [0, [0, 0, 0], [[]], 3];
private _classname		= param [1, "", [""]];
private _keepHorizontal	= [true, _this select 2] select ((count _this) > 2);

private _object = createSimpleObject [_classname, _position];
private _verticalOffset = ((getPosWorld _object) select 2) - ((getPosASL _object) select 2) + ((getPosATL _object) select 2);
_object setPosASL (_position vectorAdd [0, 0, _verticalOffset]);
_object setDir (random 360);

if (!_keepHorizontal) then {
	_object setVectorUp (surfaceNormal _position);
};

_object
