#define PIXEL_BORDER_PERCENT	1
#define PIXEL_Z_MARGIN			0.2

if !(_this isEqualType []) exitWith {["Position array expected"] call BIS_fnc_error};
if (count _this != 3) exitWith {["3 elements expected in array"] call BIS_fnc_error};

private _border	 = SP_var_surfacePainter_pixelSize / 100 * PIXEL_BORDER_PERCENT;

// create pixel object
private _pixel = createSimpleObject [
	"Land_SurfaceMapPixel",
	(ATLToASL _pos) vectorAdd [0, 0, PIXEL_Z_MARGIN]
];

// set pixel color
_pixel setObjectTexture [0, SP_var_surfacePainter_colorProc];

// set pixel properties
_pixel setVariable ["SP_var_pixelPosition", _key];
_pixel setVariable ["SP_var_pixelColor", SP_var_surfacePainter_colorHex];

// x, -y, -x, y translations
{
	_pixel animate [_x, (SP_var_surfacePainter_pixelSize - 1) / 2 - _border, true];
} forEach [
	"fl_x",
	"fr_x",
	"fl_y",
	"rl_y"
];

// z translations
{
	private _anim	= _x select 0;
	private _xy		= _x select 1;

	private _cornerElevation = _pixel modelToWorldVisualWorld (_xy vectorMultiply SP_var_surfacePainter_pixelSize / 2 - _border);
	_cornerElevation set [2, 0];
	_cornerElevation = ATLToASL _cornerElevation;

	private _difference = ((ATLToASL _pos) select 2) - (_cornerElevation select 2);
	_pixel animate [_anim, _difference + PIXEL_Z_MARGIN, true];
} forEach [
	["fl_z", [1, 1, 0]],
	["fr_z", [-1, 1, 0]],
	["rl_z", [1, -1, 0]],
	["rr_z", [-1, -1, 0]]
];

_pixel
