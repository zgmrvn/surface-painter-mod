/*
	Function: SP_fnc_surfacePainter_paint

	Description:
		Handle if pixels should be created, called by Sp_fnc_surfacePainter_mouseMove.

	Parameters:
		none

	Example:
		(begin example)
		[] spawn SP_fnc_surfacePainter_paint;
		(end)

	Returns:
		nothing

	Author:
		zgmrvn
*/

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
			if ((SP_var_surfacePainter_keys find _key) == -1) then {
				// create pixel
				private _pixel = (ATLToASL _pos) call SP_fnc_surfacePainter_createPixel;

				// store pixel
				SP_var_surfacePainter_keys pushBack _key;
				SP_var_surfacePainter_pixels pushBack _pixel;
			} else {
				private _pixel = SP_var_surfacePainter_pixels select (SP_var_surfacePainter_keys find _key);
				_pixel setObjectTexture [0, SP_var_surfacePainter_colorProc];
				_pixel setVariable ["SP_var_pixelColor", SP_var_surfacePainter_colorHex];
			};
		};
	};
};

SP_var_surfacePainter_mutex = true;
