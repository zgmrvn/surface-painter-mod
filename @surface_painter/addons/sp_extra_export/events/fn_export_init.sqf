/*
	Init for Export extra.
	This function will run when Surface Painter interface is opened.
*/

// exposed
// SP_var_export_controls = []; // contains editable controls

private _exportControl = [SP_var_export_controls, "Export"] call BIS_fnc_getFromPairs;
_exportControl ctrlAddEventHandler ["ButtonClick", {
	call SP_fnc_export_exportTerrainBuilder;

	systemChat "Objects copied in clipboard"
}];
