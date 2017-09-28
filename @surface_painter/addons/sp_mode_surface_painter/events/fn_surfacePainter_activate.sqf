/*
	Surface Painter - Activation
	This function runs when switching to this mode.
*/

/************************
***** projects list *****
************************/
private _projectsControl = [SP_var_surfacePainter_controls, "Projects"] call BIS_fnc_getFromPairs;

private _projects = ("sp" callExtension "scanForProjects") splitString "|";

lbClear _projectsControl;

// if projects found, fill projects list
if (count _projects > 0) then {
	{
		_projectsControl lbAdd _x;
		_projectsControl lbSetData [_forEachIndex, _x];

		// if the var matches the list, we select this item
		if (SP_var_surfacePainter_project != "") then {
			if (SP_var_surfacePainter_project == _x) then {
				_projectsControl lbSetCurSel _forEachIndex;
			};
		};
	} forEach _projects;

	if (SP_var_surfacePainter_project == "") then {
		_projectsControl lbSetCurSel 0;
		SP_var_surfacePainter_project = _projectsControl lbData (lbCurSel _projectsControl);
		[
			"OK",
			format [localize "STR_SP_SURFACE_PAINTER_NOTIFICATION_DEFAULT_PROJECT", SP_var_surfacePainter_project]
		] spawn SP_fnc_core_pushNotification;
	};

// else, push a notification
} else {
	["NOK", localize "STR_SP_SURFACE_PAINTER_NOTIFICATION_NO_PROJECT_FOUND"] spawn SP_fnc_core_pushNotification;
};
