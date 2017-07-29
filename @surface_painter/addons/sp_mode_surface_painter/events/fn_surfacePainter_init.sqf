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

// internal
if (isNil {SP_var_surfacePainter_pixels}) then {
	SP_var_surfacePainter_pixels = [];
};

if (isNil {SP_var_surfacePainter_workingFile}) then {
	_result = "corp_tls" callExtension ["setWorkingFile", ["surface"]];
	SP_var_surfacePainter_workingFile = true;
};

SP_var_surfacePainter_color		= [0, 0, 0];
SP_var_surfacePainter_colorHex	= "000000";
SP_var_surfacePainter_down		= false; // controls the brush loop
SP_var_surfacePainter_mutex		= true;
SP_var_surfacePainter_lastPos	= [0, 0, 0];
SP_var_surfacePainter_mapSize	= parseNumber ("corp_tls" callExtension "imgInfos");
SP_var_surfacePainter_pixelSize	= worldSize / SP_var_surfacePainter_mapSize;


_result = "corp_tls" callExtension "imgColorsList";
	systemChat str _result;
	diag_log _result;

// header
private _header = [_dialog, _optionsCtrlGroup, "Color", SP_MARGIN_Y] call SP_fnc_core_createHeaderOption;

// color
private _optionColorEdit = [
	_dialog,
	_optionsCtrlGroup,
	SP_SURFACE_PAINTER_SURFACE_PAINTER_OPTION_COLOR,
	"000000",
	"Color",
	(((ctrlPosition _header) select 1) / safeZoneH) + SP_OPTION_HEADER_M
] call SP_fnc_core_createEditOption;

_optionColorEdit ctrlAddEventHandler ["KeyUp", {
	SP_var_surfacePainter_color = (ctrlText (_this select 0)) call SP_fnc_surfacePainter_hexToDecColor;
	SP_var_surfacePainter_colorHex = (ctrlText (_this select 0));
}];

// colors
private _optionColorsList = [
	_dialog,
	_optionsCtrlGroup,
	SP_SURFACE_PAINTER_SURFACE_PAINTER_OPTION_COLORS,
	(((ctrlPosition _optionColorEdit) select 1) / safeZoneH) + SP_OPTION_HEADER_M,
	0.08
] call SP_fnc_core_createListOption;

{
	lbAdd [SP_SURFACE_PAINTER_SURFACE_PAINTER_OPTION_COLORS, toUpper _x];
	lbSetData [SP_SURFACE_PAINTER_SURFACE_PAINTER_OPTION_COLORS, _forEachIndex, toUpper _x];
	lbSetPicture [SP_SURFACE_PAINTER_SURFACE_PAINTER_OPTION_COLORS, _forEachIndex, "x\surface_painter\addons\sp_core\data\default.paa"];

	private _color = _x call SP_fnc_surfacePainter_hexToDecColor;
	_color pushBack 1;
	lbSetPictureColor [SP_SURFACE_PAINTER_SURFACE_PAINTER_OPTION_COLORS, _forEachIndex, _color];
} forEach (["corp_tls" callExtension "imgColorsList", "|"] call BIS_fnc_splitString);

lbSetCurSel [SP_SURFACE_PAINTER_SURFACE_PAINTER_OPTION_COLORS, 0];

_optionColorsList ctrlAddEventHandler ["LBSelChanged", {
	private _data = (_this select 0) lbData (_this select 1);

	private _color = _data call SP_fnc_surfacePainter_hexToDecColor;
	_color pushBack 1;

	SP_var_surfacePainter_color = _color;
	SP_var_surfacePainter_colorHex = _data;
}];

// world size
private _worldSize = [
	_dialog,
	_optionsCtrlGroup,
	-1,
	format ["World size : %1 x %1", str worldSize],
	((ctrlPosition _optionColorsList) select 1) / safeZoneH + SP_OPTION_CONTENT_H + SP_OPTION_CONTENT_M + 0.08 * safeZoneH
] call SP_fnc_core_createTextOption;

// map size
private _mapSize = [
	_dialog,
	_optionsCtrlGroup,
	SP_SURFACE_PAINTER_SURFACE_PAINTER_OPTION_SURFACE_MAP_SIZE,
	format ["Map size : %1 x %1", SP_var_surfacePainter_mapSize],
	((ctrlPosition _worldSize) select 1) / safeZoneH + SP_OPTION_CONTENT_H + SP_OPTION_CONTENT_M
] call SP_fnc_core_createTextOption;

// pixel size
private _pixelSize = [
	_dialog,
	_optionsCtrlGroup,
	SP_SURFACE_PAINTER_SURFACE_PAINTER_OPTION_SURFACE_PIXEL_SIZE,
	format ["Pixel size : %1", SP_var_surfacePainter_pixelSize],
	((ctrlPosition _mapSize) select 1) / safeZoneH + SP_OPTION_CONTENT_H + SP_OPTION_CONTENT_M
] call SP_fnc_core_createTextOption;

// generate
private _optionGenerateButton = [
	_dialog,
	_optionsCtrlGroup,
	SP_SURFACE_PAINTER_SURFACE_PAINTER_OPTION_GENERATE,
	"Generate",
	(((ctrlPosition _pixelSize) select 1) / safeZoneH) + SP_OPTION_CONTENT_H + SP_OPTION_CONTENT_M
] call SP_fnc_core_createButtonOption;

_optionGenerateButton ctrlAddEventHandler ["ButtonClick", {
	if ((count SP_var_surfacePainter_pixels) > 0) then {
		_pixels = [];

		{
			private _key			= _x select 0;
			private _pixel			= _x select 1;
			private _splitedString	= [_key, ":"] call BIS_fnc_splitString;

			//_pixels pushBack [parseNumber (_splitedString select 0), parseNumber (_splitedString select 1), _pixel getVariable "SP_var_pixelColor"];

			_pixels pushBack (parseNumber (_splitedString select 0));
			_pixels pushBack (parseNumber (_splitedString select 1));
			_pixels pushBack (_pixel getVariable "SP_var_pixelColor");

		} forEach SP_var_surfacePainter_pixels;

		systemChat str _pixels;

		_result = "corp_tls" callExtension ["setPixelsColor", _pixels];
		systemChat str _result;
		diag_log _result;

		_result = "corp_tls" callExtension "saveFile";
		systemChat str _result;
		diag_log _result;
	};
}];
