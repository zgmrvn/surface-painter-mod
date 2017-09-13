#define PIXEL_BORDER 0.025
#define PIXEL_Z_MARGIN 0.2

SP_var_surfacePainter_lastPos = SP_var_mouseWorldPosition;

_area = [SP_var_surfacePainter_lastPos, SP_var_circle_circleRadius, SP_var_circle_circleRadius, 0, false, -1];

// rows
for [{private _i = SP_var_circle_circleRadius}, {_i >= -SP_var_circle_circleRadius}, {_i = _i - SP_var_surfacePainter_pixelSize}] do {
	private _xPixel = round (((SP_var_surfacePainter_lastPos select 0) + _i) / SP_var_surfacePainter_pixelSize);
	private _x = _xPixel * SP_var_surfacePainter_pixelSize;

	// cols
	for [{private _ii = SP_var_circle_circleRadius}, {_ii >= -SP_var_circle_circleRadius}, {_ii = _ii - SP_var_surfacePainter_pixelSize}] do {
		private _yPixel = round (((SP_var_surfacePainter_lastPos select 1) + _ii) / SP_var_surfacePainter_pixelSize);
		private _y = _yPixel * SP_var_surfacePainter_pixelSize;

		// actual world position of the pixel object
		private _pos = [_x + SP_var_surfacePainter_pixelSize / 2, _y + SP_var_surfacePainter_pixelSize / 2, 0];

		// pixel position
		_key = format ["%1:%2", _xPixel, _yPixel];

		if (_pos inArea _area) then {
			if (([SP_var_surfacePainter_pixels, _key] call BIS_fnc_findInPairs) == -1) then {
				private _obj = createSimpleObject ["Land_SurfaceMapPixel", (ATLToASL _pos) vectorAdd [0, 0, PIXEL_Z_MARGIN]];
				_obj setObjectTexture [0, format ["#(rgb,8,8,3)color(%1,%2,%3,1)", SP_var_surfacePainter_color select 0, SP_var_surfacePainter_color select 1, SP_var_surfacePainter_color select 2]];

				{
					_obj animate [_x, (SP_var_surfacePainter_pixelSize - 1) / 2 - PIXEL_BORDER, true];
				} forEach [
					"fl_x",
					"fr_x",
					"fl_y",
					"rl_y"
				];

				{
					private _cornerElevation = _obj modelToWorldVisualWorld ((_x select 1) vectorMultiply SP_var_surfacePainter_pixelSize / 2 - PIXEL_BORDER);
					_cornerElevation set [2, 0];
					_cornerElevation = ATLToASL _cornerElevation;

					private _difference = ((ATLToASL _pos) select 2) - (_cornerElevation select 2);
					_obj animate [_x select 0, _difference + PIXEL_Z_MARGIN, true];
				} forEach [
					["fl_z", [1, 1, 0]],
					["fr_z", [-1, 1, 0]],
					["rl_z", [1, -1, 0]],
					["rr_z", [-1, -1, 0]]
				];

				_obj setVariable ["SP_var_pixelPosition", _key];
				_obj setVariable ["SP_var_pixelColor", SP_var_surfacePainter_colorHex];

				[SP_var_surfacePainter_pixels, _key, _obj] call BIS_fnc_setToPairs;
			} else {
				private _obj = [SP_var_surfacePainter_pixels, _key] call BIS_fnc_getFromPairs;
				_obj setObjectTexture [0, format ["#(rgb,8,8,3)color(%1,%2,%3,1)", SP_var_surfacePainter_color select 0, SP_var_surfacePainter_color select 1, SP_var_surfacePainter_color select 2]];
				_obj setVariable ["SP_var_pixelColor", SP_var_surfacePainter_colorHex];
			};
		};
	};
};

SP_var_surfacePainter_mutex = true;
