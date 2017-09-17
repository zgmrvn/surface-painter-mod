#define PIXEL_BORDER_PERCENT	1
#define PIXEL_Z_MARGIN			0.2

private _position	= param [0, [0, 0, 0], [[]], 3];
private _pixelSize	= param [1, 1, [0]];
private _texture	= param [2, "#(rgb,8,8,3)color(1,1,1,1)", [""]];
private _hex		= param [3, "FFFFFF", [""]];
private _border		= _pixelSize / 100 * PIXEL_BORDER_PERCENT;

// create pixel object
private _pixel = createSimpleObject [
	"Land_SurfaceMapPixel",
	(ATLToASL _pos) vectorAdd [0, 0, PIXEL_Z_MARGIN]
];

// set pixel color
_pixel setObjectTexture [0, format [
	"#(rgb,8,8,3)color(%1,%2,%3,1)",
	SP_var_surfacePainter_color select 0,
	SP_var_surfacePainter_color select 1,
	SP_var_surfacePainter_color select 2
]];

// set pixel properties
_pixel setVariable ["SP_var_pixelPosition", _key];
_pixel setVariable ["SP_var_pixelColor", _hex];

// x, -y, -x, y translations
{
	_pixel animate [_x, (_pixelSize - 1) / 2 - _border, true];
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

	private _cornerElevation = _pixel modelToWorldVisualWorld (_xy vectorMultiply _pixelSize / 2 - _border);
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
