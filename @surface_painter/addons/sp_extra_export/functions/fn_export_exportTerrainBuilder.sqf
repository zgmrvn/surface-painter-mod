#define DECIMALS 5

private _export = "";
private _count = (count SP_var_createdObjects) - 1;

for "_i" from 0 to _count do {
	private _object = SP_var_createdObjects select _i;

	// model
	private _model = (getModelInfo _object) select 0;
	_model = (_model splitString ".") select 0;

	// x, y, z
	private _pos = getPosATL _object;
	private _x = ((_pos select 0) + 200000) toFixed DECIMALS; // Terrain Builder coorinate system starts at 200000 for some reason
	private _y = (_pos select 1) toFixed DECIMALS;
	private _z = (_pos select 2) toFixed DECIMALS;

	// pitch, roll
	private _vectorUp = vectorUp _object;
	private _pitch = (_vectorUp select 1) atan2 (_vectorUp select 2);
	private _roll = (_vectorUp select 0) atan2 (_vectorUp select 2);

	// final string
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
