/*
	Export - Init
	This function runs when Surface Painter interface is open.
*/

// exposed
// SP_var_export_controls = []; // contains editable controls

private _exportControl = [SP_var_export_controls, "Export"] call BIS_fnc_getFromPairs;
_exportControl ctrlAddEventHandler ["ButtonClick", {
	if (count SP_var_createdObjects > 0) then {
		call SP_fnc_export_exportTerrainBuilder;
		["OK", localize "STR_SP_EXPORT_EXPORT_NOTIFICATION_OBJECTS_COPIED"] call SP_fnc_core_pushNotification;
	} else {
		["WARNING", localize "STR_SP_EXPORT_NOTIFICATION_NO_OBJECT"] call SP_fnc_core_pushNotification;
	};
}];
