private _export = "";
private _count = (count SP_var_createdObjects) - 1;

private _KK_fnc_floatToString = {
    private _arr = toArray str abs (_this % 1);
    _arr set [0, 32];
    toString (toArray str (
        abs (_this - _this % 1) * _this / abs _this
    ) + _arr - [32])
};

for "_i" from 0 to _count do {
	private _object = SP_var_createdObjects select _i;

	private _model = (getModelInfo _object) select 0;
	_model = (_model splitString ".") select 0;

	private _pos = getPosATL _object;

	private _x	= _pos select 0;
	private _y	= _pos select 1;
	private _z	= _pos select 2;

	_x = (_x + 200000) call _KK_fnc_floatToString; // Terrain Builder coorinate system starts at 200000 for some reason
	_y = _y call _KK_fnc_floatToString;
	_z = _z call _KK_fnc_floatToString;

	private _vectorUp = vectorUp _object;

	private _pitch = (_vectorUp select 1) atan2 (_vectorUp select 2);
	private _roll = (_vectorUp select 0) atan2 (_vectorUp select 2);

	private _final = format ["""%1"";%2;%3;%4;%5;%6;%7;%8;",
		_model,										// model
		_x,											// x
		_y,											// y
		getDir _object,								// yaw
		[360 - _pitch, _pitch] select (_pitch > 0),	// pitch
		[_roll, 360 + _roll] select (_roll < 0),	// roll
		1,											// scale
		_z											// z
	];

	_export = _export + _final + endl;
};

copyToClipboard _export;
