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
		private _pos = [_x + SP_var_surfacePainter_pixelSize / 2, _y + SP_var_surfacePainter_pixelSize / 2, 0.1];

		// pixel position
		_key = format ["%1:%2", _xPixel, _yPixel];

		if (_pos inArea _area) then {
			if (([SP_var_surfacePainter_pixels, _key] call BIS_fnc_findInPairs) == -1) then {
				private _obj = createSimpleObject ["Land_SurfaceMapPixel", ATLToASL _pos];
				_obj setObjectTexture [0, format ["#(rgb,8,8,3)color(%1,%2,%3,1)", SP_var_surfacePainter_color select 0, SP_var_surfacePainter_color select 1, SP_var_surfacePainter_color select 2]];

				{
					_obj animate [_x, (SP_var_surfacePainter_pixelSize - 1) / 2 - 0.025, true];
				} forEach [
					"fl_x",
					"fr_x",
					"fl_y",
					"rl_y"
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
