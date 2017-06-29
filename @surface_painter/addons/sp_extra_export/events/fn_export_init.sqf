/*
	Init for Export extra.
	This function will run when Surface Painter interface is opened.
*/

#include "\x\surface_painter\addons\sp_core\idcs.hpp"
#include "..\idcs.hpp"
#include "\x\surface_painter\addons\sp_core\sizes.hpp"

private _dialog				= findDisplay SP_SURFACE_PAINTER_IDD;
private _leftPanelCtrlGroup	= _dialog displayCtrl SP_SURFACE_PAINTER_LEFT_PANEL_CTRL_GROUP;
private _optionsCtrlGroup	= _leftPanelCtrlGroup controlsGroupCtrl SP_SURFACE_PAINTER_EXPORT_OPTIONS_CTRL_GROUP;

systemChat str _optionsCtrlGroup;

// header
private _header = [_dialog, _optionsCtrlGroup, "Export", SP_MARGIN_Y] call SP_fnc_core_createHeaderOption;

// export terrain builder
private _optionExportTerrainBuilderButton = [
	_dialog,
	_optionsCtrlGroup,
	SP_SURFACE_PAINTER_EXPORT_OPTIONS_CTRL_GROUP,
	"Export Terrain Builder",
	(((ctrlPosition _header) select 1) / safeZoneH) + SP_OPTION_CONTENT_H + SP_OPTION_CONTENT_M
] call SP_fnc_core_createButtonOption;

/*
_optionExportTerrainBuilderButton ctrlAddEventHandler ["ButtonClick", {
	// if the object pool is not empty
	if ((count SP_var_pool_finalPool) > 0) then {
		// regenerate temp objects
		SP_var_edge_tempObjects = [SP_var_edge_line, SP_var_edge_interval, SP_var_edge_spread, SP_var_pool_finalPool] call SP_fnc_edge_generate;
	};
}];
*/
