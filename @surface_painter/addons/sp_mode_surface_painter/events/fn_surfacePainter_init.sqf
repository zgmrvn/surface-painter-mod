/*
	Surface Painter - Init
	This function runs when Surface Painter interface is open.
*/

// exposed
// SP_var_surfacePainter_controls = []; // contains editable controls

// internal
if (isNil "SP_var_surfacePainter_project") then {
	SP_var_surfacePainter_project = "";
};

if (isNil "SP_var_surfacePainter_keys" && {isNil "SP_var_surfacePainter_pixels"}) then {
	SP_var_surfacePainter_keys = [];
	SP_var_surfacePainter_pixels = [];
};

if (isNil "SP_var_surfacePainter_color") then {
	SP_var_surfacePainter_color			= [0, 0, 0];
	SP_var_surfacePainter_colorProc		= "#(rgb,8,8,3)color(1,1,1,1,co)";
	SP_var_surfacePainter_colorCount	= 0;
};

SP_var_surfacePainter_down			= false; // controls the brush loop
SP_var_surfacePainter_mutex			= true;
SP_var_surfacePainter_lastPos		= [0, 0, 0];

/************************
***** projects list *****
************************/
private _projectsControl = [SP_var_surfacePainter_controls, "Projects"] call BIS_fnc_getFromPairs;

// we register the event handler fist
// so when we set the default lbCurSel
// it loads automatically the corresponding project
_projectsControl ctrlAddEventHandler ["LBSelChanged", {
	SP_var_surfacePainter_project = (_this select 0) lbData (_this select 1);
	call SP_fnc_surfacePainter_loadProject;
}];

/*************************
***** reload project *****
*************************/
private _reloadControl = [SP_var_surfacePainter_controls, "Reload"] call BIS_fnc_getFromPairs;
_reloadControl ctrlAddEventHandler ["ButtonClick", {
	if (SP_var_surfacePainter_project != "") then {
		[
			"OK",
			format [localize "STR_SP_SURFACE_PAINTER_NOTIFICATION_PROJECT_RELOADED", SP_var_surfacePainter_project]
		] spawn SP_fnc_core_pushNotification;

		call SP_fnc_surfacePainter_loadProject;
	} else {
		["NOK", localize "STR_SP_SURFACE_PAINTER_NOTIFICATION_NO_PROJECT_SELECTED"] spawn SP_fnc_core_pushNotification;
	};
}];

/**********************
***** colors list *****
**********************/
private _maskColorsControl = [SP_var_surfacePainter_controls, "MaskColors"] call BIS_fnc_getFromPairs;

lbClear _maskColorsControl;

_maskColorsControl ctrlAddEventHandler ["LBSelChanged", {
	params ["_control", "_index"];

	_data = _control lbData _index;

	SP_var_surfacePainter_color = call compile _data;

	_pictureColor = SP_var_surfacePainter_color apply {_x / 255};
	_pictureColor pushBack 1;

	_control lbSetPictureColorSelected [_index, _pictureColor];

	SP_var_surfacePainter_colorProc = format [
		"#(rgb,8,8,3)color(%1,%2,%3,1,co)",
		(SP_var_surfacePainter_color select 0) / 255,
		(SP_var_surfacePainter_color select 1) / 255,
		(SP_var_surfacePainter_color select 2) / 255
	];
}];

/*********************
***** world size *****
*********************/
private _worldSizeControl = [SP_var_surfacePainter_controls, "WorldSize"] call BIS_fnc_getFromPairs;
_worldSizeControl ctrlSetText (format [ctrlText _worldSizeControl, worldSize]);

/*******************
***** generate *****
*******************/
private _generateControl = [SP_var_surfacePainter_controls, "Generate"] call BIS_fnc_getFromPairs;
_generateControl ctrlAddEventHandler ["ButtonClick", {
	_generateControl = _this select 0;

	if (SP_var_surfacePainter_project != "") then {
		if ((count SP_var_surfacePainter_pixels) > 0) then {
			// we check if image file is still there
			_imageExists = "sp" callExtension ["imageExists", [SP_var_surfacePainter_project]];

			if ((_imageExists select 1) > 0) then { // >0 means the image exists
				// lock button
				_generateControl ctrlEnable false;

				["WARNING", localize "STR_SP_SURFACE_PAINTER_NOTIFICATION_PIXELS_WRITTING_STARTED"] spawn SP_fnc_core_pushNotification;

				// prepare string
				_pixels = [];

				{
					// we send pixels grouped by 1024 because of the limit of arguments of callExtension
					if (count _pixels == 1024) then {
						"sp" callExtension ["addModifs", _pixels];
						_pixels = [];
					};

					_splitString = _x splitString ":";
					_pixel = SP_var_surfacePainter_pixels select _forEachIndex;
					_color = _pixel getVariable "SP_var_pixelColor";

					_string = format [
						"%1;%2|%3;%4;%5",
						_splitString select 0,	// x
						_splitString select 1,	// y
						_color select 0,		// r
						_color select 1,		// g
						_color select 2			// b
					];

					_pixels pushBack _string;
				} forEach SP_var_surfacePainter_keys;

				"sp" callExtension ["addModifs", _pixels];

				// write pixels
				"sp" callExtension ["applyModifs", [SP_var_surfacePainter_project]];

				// check status
				[] spawn {
					disableSerialization;

					while {true} do {
						sleep 1;

						_result = ("sp" callExtension ["checkTaskDone", []]) select 1;

						if (_result == -1) exitWith {
							["NOK", localize "STR_SP_SURFACE_PAINTER_NOTIFICATION_PIXELS_WRITTING_ERROR"] spawn SP_fnc_core_pushNotification;
						};

						if (_result == 1) exitWith {
							["OK", localize "STR_SP_SURFACE_PAINTER_NOTIFICATION_PIXELS_WRITTEN"] spawn SP_fnc_core_pushNotification;
						};
					};

					// unlock button
					_generateControl = [SP_var_surfacePainter_controls, "Generate"] call BIS_fnc_getFromPairs;
					_generateControl ctrlEnable true;
				};
			};
		} else {
			["NOK", localize "STR_SP_SURFACE_PAINTER_NOTIFICATION_NO_PIXELS"] spawn SP_fnc_core_pushNotification;
		};
	} else {
		["NOK", localize "STR_SP_SURFACE_PAINTER_NOTIFICATION_NO_PROJECT_SELECTED"] spawn SP_fnc_core_pushNotification;
	};
}];

/****************
***** clear *****
****************/
private _clearControl = [SP_var_surfacePainter_controls, "Clear"] call BIS_fnc_getFromPairs;
_clearControl ctrlAddEventHandler ["ButtonClick", {
	{
		deleteVehicle _x;
	} forEach SP_var_surfacePainter_pixels;

	SP_var_surfacePainter_pixels = [];
	SP_var_surfacePainter_keys = [];

	["OK", localize "STR_SP_SURFACE_PAINTER_NOTIFICATION_PIXELS_REMOVED"] spawn SP_fnc_core_pushNotification;
}];
