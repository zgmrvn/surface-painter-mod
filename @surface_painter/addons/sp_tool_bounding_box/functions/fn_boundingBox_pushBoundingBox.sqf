params ["_key", "_object", "_scale", "_color"];

SP_var_boundingBox_lastCreatedObject = _object;

// compute scaled box
private _boundingBox = boundingBoxReal _object;
private _boundingBoxCenter = boundingCenter _object;
_boundingBox params ["_p1", "_p2"];

// add center
_p1 = _p1 vectorAdd _boundingBoxCenter;
_p2 = _p2 vectorAdd _boundingBoxCenter;

// scale
_p1 = _p1 vectorMultiply _scale;
_p2 = _p2 vectorMultiply _scale;

// reset center
_p1 = _p1 vectorAdd (_boundingBoxCenter vectorMultiply -1);
_p2 = _p2 vectorAdd (_boundingBoxCenter vectorMultiply -1);

// extract x, y and z
_p1 params ["_x1", "_y1", "_z1"];
_p2 params ["_x2", "_y2", "_z2"];

// compute 3D lines
private _segments = [
	[_object modelToWorld [_x2, _y2, _z2], _object modelToWorld [_x2, _y2, _z1]],
	[_object modelToWorld [_x1, _y1, _z2], _object modelToWorld [_x1, _y1, _z1]],
	[_object modelToWorld [_x2, -_y2, _z2], _object modelToWorld [_x2, -_y2, _z1]],
	[_object modelToWorld [_x1, -_y1, _z2], _object modelToWorld [_x1, -_y1, _z1]],

	[_object modelToWorld [_x1, -_y1, _z2], _object modelToWorld [_x2, _y2, _z2]],
	[_object modelToWorld [_x2, -_y2, _z2], _object modelToWorld [_x1, _y1, _z2]],
	[_object modelToWorld [_x2, -_y2, _z2], _object modelToWorld [_x2, _y2, _z2]],
	[_object modelToWorld [_x1, -_y1, _z2], _object modelToWorld [_x1, _y1, _z2]]
];

// push in global bounding boxes array
[SP_var_boundingBox_boundingBoxes, _key, [_segments, _color]] call BIS_fnc_setToPairs;
