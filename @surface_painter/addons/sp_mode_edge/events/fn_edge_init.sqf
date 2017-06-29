/*
	Init for Edge mode.
	This function will run when Surface Painter interface is opened.
*/

#include "\x\surface_painter\addons\sp_core\idcs.hpp"
#include "..\idcs.hpp"
#include "\x\surface_painter\addons\sp_core\sizes.hpp"

private _dialog				= findDisplay SP_SURFACE_PAINTER_IDD;
private _leftPanelCtrlGroup	= _dialog displayCtrl SP_SURFACE_PAINTER_LEFT_PANEL_CTRL_GROUP;
private _optionsCtrlGroup	= _leftPanelCtrlGroup controlsGroupCtrl SP_SURFACE_PAINTER_EDGE_OPTIONS_CTRL_GROUP;

// exposed
SP_var_edge_line		= []; // contains the positions that represents the line
SP_var_edge_interval	= 10; // inteval between objects created on the line
SP_var_edge_spread		= 0; // spread of created objects according to their origin position

// internal
SP_var_edge_mode		= "DRAW"; // edge mode : DRAW, LOWER, HIGHER, CLIFF
SP_var_edge_anchor		= []; // needed to detect the direction the mouse move
SP_var_edge_tempObjects	= []; // temporary objects for the refresh when options are changed

// header
private _header = [_dialog, _optionsCtrlGroup, "Mode", SP_MARGIN_Y] call SP_fnc_core_createHeaderOption;

// edge detection mode
{
	private _optionModeCheckbox = [
		_dialog, _optionsCtrlGroup,
		_x select 0,
		_x select 1,
		_x select 2
	] call SP_fnc_core_createCheckBoxOption;

	_optionModeCheckbox ctrlAddEventHandler ["CheckedChanged", {
		if ((_this select 1) == 1) then {
			private _dialog				= findDisplay SP_SURFACE_PAINTER_IDD;
			private _leftPanelCtrlGroup	= _dialog displayCtrl SP_SURFACE_PAINTER_LEFT_PANEL_CTRL_GROUP;
			private _optionsCtrlGroup	= _leftPanelCtrlGroup controlsGroupCtrl SP_SURFACE_PAINTER_EDGE_OPTIONS_CTRL_GROUP;

			{
				if ((_x select 0) != (_this select 0)) then {
					(_x select 0) cbSetChecked false;
				} else {
					SP_var_edge_mode = _x select 1;
				};
			} forEach [
				[_optionsCtrlGroup controlsGroupCtrl SP_SURFACE_PAINTER_EDGE_OPTION_LOWER, "LOWER"],
				[_optionsCtrlGroup controlsGroupCtrl SP_SURFACE_PAINTER_EDGE_OPTION_HIGHER, "HIGHER"],
				[_optionsCtrlGroup controlsGroupCtrl SP_SURFACE_PAINTER_EDGE_OPTION_CLIFF, "CLIFF"]
			];
		} else {
			SP_var_edge_mode = "DRAW";
		};
	}];
} forEach [
	[SP_SURFACE_PAINTER_EDGE_OPTION_LOWER, "Lower", (((ctrlPosition _header) select 1) / safeZoneH) + SP_OPTION_HEADER_M],
	[SP_SURFACE_PAINTER_EDGE_OPTION_HIGHER, "Higher", (((ctrlPosition _header) select 1) / safeZoneH) + SP_OPTION_HEADER_M + SP_OPTION_CONTENT_H + SP_OPTION_CONTENT_M],
	[SP_SURFACE_PAINTER_EDGE_OPTION_CLIFF, "Cliff", (((ctrlPosition _header) select 1) / safeZoneH) + SP_OPTION_HEADER_M + SP_OPTION_CONTENT_H * 2 + SP_OPTION_CONTENT_M * 2]
];

// header
private _header = [_dialog, _optionsCtrlGroup, "Placement", (((ctrlPosition _header) select 1) / safeZoneH) + SP_OPTION_HEADER_M + SP_OPTION_CONTENT_H * 3+ SP_OPTION_CONTENT_M * 3 + SP_MARGIN_Y] call SP_fnc_core_createHeaderOption;

// interval
private _optionIntervalEdit = [
	_dialog,
	_optionsCtrlGroup,
	SP_SURFACE_PAINTER_EDGE_OPTION_INTERVAL,
	str SP_var_edge_interval,
	"Interval placement",
	(((ctrlPosition _header) select 1) / safeZoneH) + SP_OPTION_HEADER_M
] call SP_fnc_core_createEditOption;

_optionIntervalEdit ctrlAddEventHandler ["MouseZChanged", {
	private _mouseWheel	= [-1, 1] select ((_this select 1) > 0);
	private _before		= parseNumber (ctrlText SP_SURFACE_PAINTER_EDGE_OPTION_INTERVAL);
	private _after		= (_before + _mouseWheel) max 1;

	// if the previous interval is different of the new
	if (_after != _before) then {
		SP_var_edge_interval = _after;
		ctrlSetText [SP_SURFACE_PAINTER_EDGE_OPTION_INTERVAL, str _after];

		// if the object pool is not empty
		if ((count SP_var_pool_finalPool) > 0) then {
			// regenerate temp objects
			call SP_fnc_edge_regenerate;
		};
	};
}];

// spread
private _optionSpreadEdit = [
	_dialog,
	_optionsCtrlGroup,
	SP_SURFACE_PAINTER_EDGE_OPTION_SPREAD,
	str SP_var_edge_spread,
	"Spread",
	(((ctrlPosition _optionIntervalEdit) select 1) / safeZoneH) + SP_OPTION_CONTENT_H + SP_OPTION_CONTENT_M
] call SP_fnc_core_createEditOption;

_optionSpreadEdit ctrlAddEventHandler ["MouseZChanged", {
	private _mouseWheel	= [-1, 1] select ((_this select 1) > 0);
	private _before		= parseNumber (ctrlText SP_SURFACE_PAINTER_EDGE_OPTION_SPREAD);
	private _after		= (_before + _mouseWheel) max 0;

	// if the previous spread is different of the new
	if (_after != _before) then {
		SP_var_edge_spread = _after;
		ctrlSetText [SP_SURFACE_PAINTER_EDGE_OPTION_SPREAD, str _after];

		// if the object pool is not empty
		if ((count SP_var_pool_finalPool) > 0) then {
			// regenerate temp objects
			call SP_fnc_edge_regenerate;
		};
	};
}];

// generate
private _optionGenerateButton = [
	_dialog,
	_optionsCtrlGroup,
	SP_SURFACE_PAINTER_EDGE_OPTION_GENERATE,
	"Generate",
	(((ctrlPosition _optionSpreadEdit) select 1) / safeZoneH) + SP_OPTION_CONTENT_H + SP_OPTION_CONTENT_M
] call SP_fnc_core_createButtonOption;

_optionGenerateButton ctrlAddEventHandler ["ButtonClick", {
	// if the object pool is not empty
	if ((count SP_var_pool_finalPool) > 0) then {
		// regenerate temp objects
		SP_var_edge_tempObjects = [SP_var_edge_line, SP_var_edge_interval, SP_var_edge_spread, SP_var_pool_finalPool] call SP_fnc_edge_generate;
	};
}];
