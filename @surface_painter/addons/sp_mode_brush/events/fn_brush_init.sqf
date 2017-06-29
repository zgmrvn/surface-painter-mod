/*
	Init for Brush mode.
	This function will run when Surface Painter interface is opened.
*/

#include "\x\surface_painter\addons\sp_core\idcs.hpp"
#include "..\idcs.hpp"
#include "\x\surface_painter\addons\sp_core\sizes.hpp"

private _dialog				= findDisplay SP_SURFACE_PAINTER_IDD;
private _leftPanelCtrlGroup	= _dialog displayCtrl SP_SURFACE_PAINTER_LEFT_PANEL_CTRL_GROUP;
private _optionsCtrlGroup	= _leftPanelCtrlGroup controlsGroupCtrl SP_SURFACE_PAINTER_BRUSH_OPTIONS_CTRL_GROUP;

// exposed
SP_var_brush_distance	= 0; // distance between objects option
SP_var_brush_flow		= 20; // how many objects can be created in 1 second

// internal
SP_var_brush_loop = false; // controls the brush loop

// header
private _header = [_dialog, _optionsCtrlGroup, "Placement", SP_MARGIN_Y] call SP_fnc_core_createHeaderOption;

// distance
private _optionDistanceEdit = [
	_dialog,
	_optionsCtrlGroup,
	SP_SURFACE_PAINTER_BRUSH_OPTION_DISTANCE,
	"0",
	"Object distance",
	(((ctrlPosition _header) select 1) / safeZoneH) + SP_OPTION_HEADER_M
] call SP_fnc_core_createEditOption;

_optionDistanceEdit ctrlAddEventHandler ["MouseZChanged", {
	private _mouseWheel	= [-1, 1] select ((_this select 1) > 0);
	private _distance	= parseNumber (ctrlText SP_SURFACE_PAINTER_BRUSH_OPTION_DISTANCE);
	_distance			= (_distance + _mouseWheel) max 0;

	SP_var_brush_distance = _distance;
	ctrlSetText [SP_SURFACE_PAINTER_BRUSH_OPTION_DISTANCE, str _distance];
}];

// flow
private _optionFlowEdit = [
	_dialog,
	_optionsCtrlGroup,
	SP_SURFACE_PAINTER_BRUSH_OPTION_FLOW, "20", "Flow",
	((ctrlPosition _optionDistanceEdit) select 1) / safeZoneH + SP_OPTION_CONTENT_H + SP_OPTION_CONTENT_M,
	"How many objects can be created in one second"
] call SP_fnc_core_createEditOption;

_optionFlowEdit ctrlAddEventHandler ["MouseZChanged", {
	private _mouseWheel	= [-1, 1] select ((_this select 1) > 0);
	private _flow		= parseNumber (ctrlText SP_SURFACE_PAINTER_BRUSH_OPTION_FLOW);
	_flow				= (_flow + _mouseWheel) max 1;

	SP_var_brush_flow = _flow;
	ctrlSetText [SP_SURFACE_PAINTER_BRUSH_OPTION_FLOW, str _flow];
}];
