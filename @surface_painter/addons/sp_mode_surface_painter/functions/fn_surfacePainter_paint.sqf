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
			// color
			if (([SP_var_surfacePainter_pixels, _key] call BIS_fnc_findInPairs) == -1) then {
				// create pixel
				private _pixel = (ATLToASL _pos) call SP_fnc_surfacePainter_createPixel;

				// store pixel
				[SP_var_surfacePainter_pixels, _key, _pixel] call BIS_fnc_setToPairs;
			} else {
				private _pixel = [SP_var_surfacePainter_pixels, _key] call BIS_fnc_getFromPairs;
				_pixel setObjectTexture [0, SP_var_surfacePainter_colorProc];
				_pixel setVariable ["SP_var_pixelColor", SP_var_surfacePainter_colorHex];
			};
		};
	};
};

SP_var_surfacePainter_mutex = true;
