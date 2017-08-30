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

	private _model	= (getModelInfo _object) select 0;
	_model = (_model splitString ".") select 0;

	private _pos	= getPosATL _object;

	private _x	= _pos select 0;
	private _y	= _pos select 1;
	private _z	= _pos select 2;

	_x = (_x + 200000) call _KK_fnc_floatToString; // Terrain Builder coorinate system starts at 200000 for some reason
	_y = _y call _KK_fnc_floatToString;
	_z = _z call _KK_fnc_floatToString;

	private _vectorUp = vectorUp _object;

	private _final = format ["""%1"";%2;%3;%4;%5;%6;%7;%8;",
		_model,						// classname
		_x,							// x
		_y,							// y
		getDir _object,				// yaw
		(_vectorUp select 0) * 180,	// pitch
		(_vectorUp select 1) * 180,	// roll
		1,							// scale
		_z							// z ASL
	];

	_export = _export + _final + endl;
};

copyToClipboard _export;
