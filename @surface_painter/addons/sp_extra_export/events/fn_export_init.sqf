/*
	Export - Init
	This function runs when Surface Painter interface is open.
*/

// exposed
// SP_var_export_controls = []; // contains editable controls

private _copyToClipboardControl = [SP_var_export_controls, "CopyToClipboard"] call BIS_fnc_getFromPairs;
_copyToClipboardControl ctrlAddEventHandler ["ButtonClick", {
	if (count SP_var_createdObjects > 0) then {
		private _export = "objects" + endl;
		private _count = (count SP_var_createdObjects) - 1;

		for "_i" from 0 to _count do {
			private _lbtFormat = (SP_var_createdObjects select _i) call SP_fnc_export_objectToLbtFormat;

			_export = _export + _lbtFormat + endl;
		};

		_export = _export + "end objects" + endl;

		copyToClipboard _export;

		["OK", localize "STR_SP_EXPORT_NOTIFICATION_OBJECTS_COPIED"] spawn SP_fnc_core_pushNotification;
	} else {
		["NOK", localize "STR_SP_EXPORT_NOTIFICATION_NO_OBJECT"] spawn SP_fnc_core_pushNotification;
	};
}];

private _exportLbtControl = [SP_var_export_controls, "ExportLbt"] call BIS_fnc_getFromPairs;
_exportLbtControl ctrlAddEventHandler ["ButtonClick", {
	if (count SP_var_createdObjects > 0) then {
		"sp" callExtension "clearObjects";
		private _objects = [];

		{
			// we send object grouped by 1024 because of the limit of arguments of callExtension
			if (count _objects == 1024) then {
				"sp" callExtension ["pushObjects", _objects];
				_objects = [];
			};

			_objects pushBack (_x call SP_fnc_export_objectToLbtFormat);
		} forEach SP_var_createdObjects;

		// push remaining objects
		"sp" callExtension ["pushObjects", _objects];

		// write pixels
		"sp" callExtension ["writeObjectsLbt", [SP_var_surfacePainter_project]];

		["OK", localize "STR_SP_EXPORT_NOTIFICATION_OBJECTS_WRITTEN"] spawn SP_fnc_core_pushNotification;
	} else {
		["NOK", localize "STR_SP_EXPORT_NOTIFICATION_NO_OBJECT"] spawn SP_fnc_core_pushNotification;
	};
}];
