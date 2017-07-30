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

_optionExportTerrainBuilderButton ctrlAddEventHandler ["ButtonClick", {
	call SP_fnc_export_exportTerrainBuilder;

	systemChat "Objects copied in clipboard"
}];
