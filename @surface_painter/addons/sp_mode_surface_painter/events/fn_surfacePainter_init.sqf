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
SP_var_surfacePainter_color = [0, 0, 0];

// internal
if (isNil {SP_var_surfacePainter_pixels}) then {
	SP_var_surfacePainter_pixels = [];
};

SP_var_surfacePainter_down		= false; // controls the brush loop
SP_var_surfacePainter_mutex		= true;
SP_var_surfacePainter_lastPos	= [0, 0, 0];
SP_var_surfacePainter_pixelSize	= 0;

// header
private _header = [_dialog, _optionsCtrlGroup, "Color", SP_MARGIN_Y] call SP_fnc_core_createHeaderOption;

// color
private _optionColorEdit = [
	_dialog,
	_optionsCtrlGroup,
	SP_SURFACE_PAINTER_SURFACE_PAINTER_OPTION_COLOR,
	"00000",
	"Color",
	(((ctrlPosition _header) select 1) / safeZoneH) + SP_OPTION_HEADER_M
] call SP_fnc_core_createEditOption;


_optionColorEdit ctrlAddEventHandler ["KeyUp", {
	SP_var_surfacePainter_color = (ctrlText (_this select 0)) call SP_fnc_surfacePainter_hexToDecColor;
}];



// map size
private _worldSize = [
	_dialog,
	_optionsCtrlGroup,
	-1,
	format ["World size : %1 x %1", str worldSize],
	((ctrlPosition _optionColorEdit) select 1) / safeZoneH + SP_OPTION_CONTENT_H + SP_OPTION_CONTENT_M
] call SP_fnc_core_createTextOption;

// surface map size
private _surfaceMapSize = [
	_dialog,
	_optionsCtrlGroup,
	SP_SURFACE_PAINTER_SURFACE_PAINTER_OPTION_SURFACE_MAP_SIZE,
	[["512 x 512", "512"], ["1024 x 1024", "1024"], ["2048 x 2048", "2048"], ["4096 x 4096", "4096"]],
	((ctrlPosition _worldSize) select 1) / safeZoneH + SP_OPTION_CONTENT_H + SP_OPTION_CONTENT_M
] call SP_fnc_core_createComboOption;

SP_var_surfacePainter_pixelSize = worldSize / (parseNumber (_surfaceMapSize lbData (lbCurSel _surfaceMapSize)));

// pixel size
private _pixelSize = [
	_dialog,
	_optionsCtrlGroup,
	SP_SURFACE_PAINTER_SURFACE_PAINTER_OPTION_SURFACE_PIXEL_SIZE,
	format ["Pixel size : %1", SP_var_surfacePainter_pixelSize],
	((ctrlPosition _surfaceMapSize) select 1) / safeZoneH + SP_OPTION_CONTENT_H + SP_OPTION_CONTENT_M
] call SP_fnc_core_createTextOption;


_surfaceMapSize ctrlAddEventHandler ["LBSelChanged", {
	private _dialog			= findDisplay SP_SURFACE_PAINTER_IDD;
	private _surfaceMapSize	= _this select 0;
	private _pixelSizeCtrl	= _dialog displayCtrl SP_SURFACE_PAINTER_SURFACE_PAINTER_OPTION_SURFACE_PIXEL_SIZE;

	SP_var_surfacePainter_pixelSize = worldSize / (parseNumber (_surfaceMapSize lbData (lbCurSel _surfaceMapSize)));
	_pixelSizeCtrl ctrlSetText (format ["Pixel size : %1", str SP_var_surfacePainter_pixelSize]);
}];




