/*
	ASL format
	classname
*/

private _position	= param [0, [0, 0, 0], [[]], 3];
private _classname	= param [1, "", [""]];

private _object = createSimpleObject [_classname, _position];
private _verticalOffset = ((getPosWorld _object) select 2) - ((getPosASL _object) select 2) + ((getPosATL _object) select 2);
_object setPosASL (_position vectorAdd [0, 0, _verticalOffset]);
_object setDir (random 360);
// todo : this should be a param extracted from the object config
_object setVectorUp (surfaceNormal _position);

_object
