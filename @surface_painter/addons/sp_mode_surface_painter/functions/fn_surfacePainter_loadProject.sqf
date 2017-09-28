// set current project name
private _projectControl = [SP_var_surfacePainter_controls, "Project"] call BIS_fnc_getFromPairs;
_projectControl ctrlSetText SP_var_surfacePainter_project;

// set mask size
SP_var_surfacePainter_maskSize = parseNumber (("sp" callExtension ["getWidth", [SP_var_surfacePainter_project]]) select 0);
private _maskSizeControl = [SP_var_surfacePainter_controls, "MaskSize"] call BIS_fnc_getFromPairs;
_maskSizeControl ctrlSetText (format [localize "STR_SP_SURFACE_PAINTER_MASK_SIZE", SP_var_surfacePainter_maskSize]);

// set pixel size
SP_var_surfacePainter_pixelSize	= worldSize / SP_var_surfacePainter_maskSize;
private _pixelSizeControl = [SP_var_surfacePainter_controls, "PixelSize"] call BIS_fnc_getFromPairs;
_pixelSizeControl ctrlSetText (format [localize "STR_SP_SURFACE_PAINTER_PIXEL_SIZE", SP_var_surfacePainter_pixelSize]);

// set colors
private _colors = (("sp" callExtension ["getColors", [SP_var_surfacePainter_project]]) select 0) splitString "|";

private _maskColorsControl = [SP_var_surfacePainter_controls, "MaskColors"] call BIS_fnc_getFromPairs;

lbClear _maskColorsControl;

SP_var_surfacePainter_colorCount = count _colors;

if (SP_var_surfacePainter_colorCount > 0) then {
	private _selectedColor = false;

	{
		private _params	= _x splitString ";";
		private _name 	= _params select 0;
		private _color	= (_params select 1) splitString ":";

		_maskColorsControl lbAdd _name;
		_maskColorsControl lbSetData [_forEachIndex, str (_color apply {parseNumber _x})];
		_maskColorsControl lbSetPicture [_forEachIndex, "x\surface_painter\addons\sp_core\data\default.paa"];

		if ((str SP_var_surfacePainter_color) == (str (_color apply {parseNumber _x}))) then {
			_maskColorsControl lbSetCurSel _forEachIndex;
			_selectedColor =  true;
		};

		_color = _color apply {parseNumber _x / 255};
		_color pushBack 1;

		_maskColorsControl lbSetPictureColor [_forEachIndex, _color];
	} forEach _colors;

	// if no previous selected color found, we select the first color
	if (!_selectedColor) then {
		_maskColorsControl lbSetCurSel 0;
	};
} else {
	[
		"NOK",
		format [localize "STR_SP_SURFACE_PAINTER_NOTIFICATION_NO_COLOR", SP_var_surfacePainter_project]
	] spawn SP_fnc_core_pushNotification;
};
