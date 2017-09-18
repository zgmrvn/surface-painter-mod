/*
	Init for Brush mode.
	This function will run when Surface Painter interface is opened.
*/

#include "\x\surface_painter\addons\sp_core\idcs.hpp"
#include "..\idcs.hpp"
#include "\x\surface_painter\addons\sp_core\sizes.hpp"

private _dialog				= findDisplay SP_SURFACE_PAINTER_IDD;
private _leftPanelCtrlGroup	= _dialog displayCtrl SP_SURFACE_PAINTER_LEFT_PANEL_CTRL_GROUP;
private _optionsCtrlGroup	= _leftPanelCtrlGroup controlsGroupCtrl SP_SURFACE_PAINTER_SURFACE_PAINTER_OPTIONS_CTRL_GROUP;

// exposed
// SP_var_surfacePainter_controls = []; // contains editable controls

// internal
if (isNil {SP_var_surfacePainter_pixels}) then {
	SP_var_surfacePainter_pixels = [];
};

if (isNil {SP_var_surfacePainter_workingFile}) then {
	_result = "sp" callExtension ["setWorkingFile", ["surface"]];
	SP_var_surfacePainter_workingFile = true;
};

SP_var_surfacePainter_color		= [0, 0, 0];
SP_var_surfacePainter_colorHex	= "FFFFFF";
SP_var_surfacePainter_colorProc	= "#(rgb,8,8,3)color(%1,%2,%3,1)";
SP_var_surfacePainter_down		= false; // controls the brush loop
SP_var_surfacePainter_mutex		= true;
SP_var_surfacePainter_lastPos	= [0, 0, 0];
SP_var_surfacePainter_maskSize	= parseNumber ("sp" callExtension "imgInfos");
SP_var_surfacePainter_pixelSize	= worldSize / SP_var_surfacePainter_maskSize;

// colors
private _maskColorsControl = [SP_var_surfacePainter_controls, "MaskColors"] call BIS_fnc_getFromPairs;

lbClear _maskColorsControl;

private _colors = (("sp" callExtension "imgColorsList") splitString "|");

{
	_maskColorsControl lbAdd (format ["#%1", toUpper _x]);
	_maskColorsControl lbSetData [_forEachIndex, toUpper _x];
	_maskColorsControl lbSetPicture [_forEachIndex, "x\surface_painter\addons\sp_core\data\default.paa"];

	private _color = _x call SP_fnc_surfacePainter_hexToDecColor;
	_color pushBack 1;
	_maskColorsControl lbSetPictureColor [_forEachIndex, _color];
} forEach _colors;

// set default selected if a
if (count _colors > 0) then {
	_maskColorsControl lbSetCurSel 0;
	SP_var_surfacePainter_colorHex = _maskColorsControl lbData 0;

	private _color = SP_var_surfacePainter_colorHex call SP_fnc_surfacePainter_hexToDecColor;
	_color pushBack 1;
	SP_var_surfacePainter_color = _color;
	SP_var_surfacePainter_colorProc = format [
		"#(rgb,8,8,3)color(%1,%2,%3,1)",
		_color select 0,
		_color select 1,
		_color select 2
	];
};

_maskColorsControl ctrlAddEventHandler ["LBSelChanged", {
	private _data = (_this select 0) lbData (_this select 1);
	private _color = _data call SP_fnc_surfacePainter_hexToDecColor;
	_color pushBack 1;

	SP_var_surfacePainter_colorHex = _data;
	SP_var_surfacePainter_color = _color;
	SP_var_surfacePainter_colorProc = format [
		"#(rgb,8,8,3)color(%1,%2,%3,1)",
		_color select 0,
		_color select 1,
		_color select 2
	];
}];

// world size
private _worldSizeControl = [SP_var_surfacePainter_controls, "WorldSize"] call BIS_fnc_getFromPairs;
_worldSizeControl ctrlSetText (format [ctrlText _worldSizeControl, worldSize]);

// mask size
private _maskSizeControl = [SP_var_surfacePainter_controls, "MaskSize"] call BIS_fnc_getFromPairs;
_maskSizeControl ctrlSetText (format [ctrlText _maskSizeControl, SP_var_surfacePainter_maskSize]);

// pixel size
private _pixelSizeControl = [SP_var_surfacePainter_controls, "PixelSize"] call BIS_fnc_getFromPairs;
_pixelSizeControl ctrlSetText (format [ctrlText _pixelSizeControl, SP_var_surfacePainter_pixelSize]);

// generate
private _generateControl = [SP_var_surfacePainter_controls, "Generate"] call BIS_fnc_getFromPairs;
_generateControl ctrlAddEventHandler ["ButtonClick", {
	if ((count SP_var_surfacePainter_pixels) > 0) then {
		_pixels = [];

		{
			private _key			= _x select 0;
			private _pixel			= _x select 1;
			private _splitedString	= [_key, ":"] call BIS_fnc_splitString;

			_pixels pushBack (parseNumber (_splitedString select 0));
			_pixels pushBack (parseNumber (_splitedString select 1));
			_pixels pushBack (_pixel getVariable "SP_var_pixelColor");
		} forEach SP_var_surfacePainter_pixels;

		_result = "sp" callExtension ["setPixelsColor", _pixels];
		_result = "sp" callExtension "saveFile";
	};
}];
