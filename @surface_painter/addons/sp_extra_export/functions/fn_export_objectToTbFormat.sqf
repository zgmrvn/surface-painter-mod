#define DECIMALS_POS	4
#define DECIMALS_ANG	3
#define DECIMALS_SCALE	3

// model
private _model = (getModelInfo _this) select 0;
_model = (_model splitString ".") select 0;

// x, y, z
private _pos = getPosATL _this;
// Terrain Builder coorinate system starts at 200000 for some reason
private _x = ((_pos select 0) + 200000) toFixed DECIMALS_POS;
private _y = (_pos select 1) toFixed DECIMALS_POS;
private _z = (_pos select 2) toFixed DECIMALS_POS;

// pitch, yaw, roll
private _dir = vectorDir _this;
_dir params ["_dirX"];

private _up = vectorUp _this;
_up params ["_upX", "_upY", "_upZ"];

private _side = _dir vectorCrossProduct _up;
_side params ["_sideX"];

private _pitch = -_upY atan2 _upZ;
private _roll = _upX atan2 (1 - (_upX ^ 2));
private _yaw = _dirX atan2 _sideX;

// inverting for left emisphere
if (_yaw >= 180) then {
	_pitch = -_pitch;
	_roll = -_roll;
};

// to string
_pitch = _pitch toFixed DECIMALS_ANG;
_roll = _roll toFixed DECIMALS_ANG;
_yaw = _yaw toFixed DECIMALS_ANG;

// scale
private _scale = (_this getVariable "Sp_var_scale") toFixed DECIMALS_SCALE;

// final string
private _final = format ["""%1"";%2;%3;%4;%5;%6;%7;%8;",
	_model,	// model
	_x,		// x
	_y,		// y
	_yaw,	// yaw
	_pitch,	// pitch
	_roll,	// roll
	_scale,	// scale
	_z		// z
];

_final
