#include "idcs.hpp"
#include "sizes.hpp"

// config defines
#define MODULES (configFile >> "CfgSurfacePainter" >> "Modules")
#define TOOLS (configFile >> "CfgSurfacePainter" >> "Tools")

// key down/up defines
#define ACTIONS ["cameraMoveForward", "cameraMoveBackward", "cameraMoveLeft", "cameraMoveRight", "cameraMoveUp", "cameraMoveDown"]
#define TRANSLATIONS [[0, 1, 0], [0, -1, 0], [-1, 1, 0], [1, 1, 0], [0, 0, 1], [0, 0, -1]]
#define SHORTCUTS [2, 3, 4, 5, 6, 7, 8, 9, 10]

// camera
SP_var_core_cameraTranslationKeys				= [];
SP_var_core_cameraTranslationLoop				= false;
SP_var_core_cameraRotationSensibility			= 100;
SP_var_core_cameraTranslationSensibility		= 0.07;
SP_var_core_cameraTranslationTurboMultiplier	= 3;

// mouse
SP_var_core_mouseScreenPosition					= [0.5, 0.5];
SP_var_core_mousePreviousFrameScreenPosition	= SP_var_core_mouseScreenPosition;
SP_var_core_mouseWorldPosition					= screenToWorld SP_var_core_mouseScreenPosition;

// special keys
SP_var_keyShift	= false;
SP_var_keyCtrl	= false;
SP_var_keyAlt	= false;
SP_var_keyTurbo	= false;

// ui
SP_var_menuButtonsControls = [];

/*
// this var will contain every created objects
// if this variable doesn't already exist, we set it to an empty array
if (isNil {SP_var_createdObjects}) then {
	SP_var_createdObjects = [];
};

// notifications
SP_var_notificationsStack 	= [];
SP_var_notificationsLoop	= false;
SP_var_notifications		= [];
*/

disableserialization;

waitUntil { !isNull findDisplay SP_IDD };

// controls
private _dialog	= findDisplay SP_IDD;
private _eventControl = _dialog displayCtrl SP_EVENT_CONTROL; // this is the main control for catching events

private _menuControlsGroup = _dialog displayCtrl SP_MENU_CONTROLS_GROUP;
private _modulesControlsGroup = _menuControlsGroup controlsGroupCtrl SP_MODULES_CONTROLS_GROUP;
private _buttonsBackgroundControl = _modulesControlsGroup controlsGroupCtrl SP_MODULES_BUTTONS_BACKGROUND_CONTROL;

private _loadingControlsGroup = _dialog displayCtrl SP_LOADING_CONTROLS_GROUP;

// fade loading screen in
_loadingControlsGroup ctrlSetFade 0;
_loadingControlsGroup ctrlCommit 0.1;

/*
_leftPanelCtrlGroup			= _dialog displayCtrl SP_SURFACE_PAINTER_LEFT_PANEL_CTRL_GROUP;
_modeslist					= _dialog displayCtrl SP_SURFACE_PAINTER_MODES_LIST;
_leftPanelEnterEventCtrl	= _dialog displayCtrl SP_SURFACE_PAINTER_LEFT_PANEL_EVENT_ENTER_CTRL;
_leftPanelExitEventCtrl		= _dialog displayCtrl SP_SURFACE_PAINTER_LEFT_PANEL_EVENT_EXIT_CTRL;
*/

// get modules
private _modules = ("true" configClasses MODULES) apply { configName _x };

// sort modules by priority
_modules = _modules apply { [getNumber (configFile >> "CfgSurfacePainter" >> "Modules" >> _x >> "priority"), _x] };
_modules sort false;
_modules = _modules apply { _x select 1 };

// get tools
private _tools = ("true" configClasses TOOLS) apply { configName _x };

// if current module not defined, set default module
if (isNil "SP_var_core_currentModule") then {
	SP_var_core_currentModule = _modules select 0;
};

// mouse
SP_var_core_primaryMouseButton = false;
SP_var_core_secondaryMouseButton = false;






/*************************************
***** compile events for modules *****
*************************************/
{
	private _module = _x;
	private _path = getText (MODULES >> _module >> "path");
	private _events = ("true" configClasses (MODULES >> _module >> "Events")) apply { configName _x };

	{
		private _event = _x;
		private _script = format ["%1\events\%2", _path, getText (MODULES >> _module >> "Events" >> _event >> "script")];

		// if on init, call immediately
		if (_event == "OnInit") then {
			call compile preprocessFileLineNumbers _script;
		} else {
			missionNamespace setVariable [
				format ["SP_event_%1_%2", _module, _event],
				compile preprocessFileLineNumbers _script
			];
		};
	} forEach _events;
} forEach _modules;





/***********************************
***** compile events for tools *****
***********************************/
{
	private _tool = _x;
	private _path = getText (TOOLS >> _tool >> "path");
	private _events = ("true" configClasses (TOOLS >> _tool >> "Events")) apply { configName _x };

	{
		private _event = _x;
		private _script = format ["%1\events\%2", _path, getText (TOOLS >> _tool >> "Events" >> _event >> "script")];

		// if on init, call immediately
		if (_event == "OnInit") then {
			call compile preprocessFileLineNumbers _script;
		} else {
			missionNamespace setVariable [
				format ["SP_event_%1_%2", _tool, _event],
				compile preprocessFileLineNumbers _script
			];
		};
	} forEach _events;
} forEach _tools;





/*************************
***** fill left menu *****
*************************/
{
	private _menuButton = _dialog ctrlCreate ["MenuButton", -1, _modulesControlsGroup];
	SP_var_menuButtonsControls pushBack _menuButton;
	private _controlPosition = ctrlPosition _menuButton;
	_menuButton ctrlSetPosition [
		0,
		safeZoneW * SP_MENU_W * (safeZoneW / safeZoneH) * _forEachIndex,
		_controlPosition select 2,
		_controlPosition select 3
	];
	_menuButton ctrlCommit 0;

	// set button icon
	private _path = getText (MODULES >> _x >> "path");
	private _icon = getText (MODULES >> _x >> "icon");
	private _menuButtonIcon = _menuButton controlsGroupCtrl SP_MENU_BUTTON_ICON;
	_menuButtonIcon ctrlSetText format ["%1\%2", _path, _icon];

	// set button data
	private _menuButtonData = _menuButton controlsGroupCtrl SP_MENU_BUTTON_DATA;
	_menuButtonData ctrlSetText _x;

	// set background position
	if (_x == SP_var_core_currentModule) then {
		_buttonsBackgroundControl ctrlSetPosition (ctrlPosition _menuButton);
		_buttonsBackgroundControl ctrlCommit 0;
	};
} forEach _modules;

// resize menu according to the number of buttons
private _controlPosition = ctrlPosition _modulesControlsGroup;
_modulesControlsGroup ctrlSetPosition [
	0,
	_controlPosition select 1,
	_controlPosition select 2,
	safeZoneW * SP_MENU_W * (safeZoneW / safeZoneH) * (count _modules)
];
_modulesControlsGroup ctrlCommit 0;





/******************************
***** on click on buttons *****
******************************/
{
	_x ctrlAddEventHandler ["MouseButtonDown", {
		params ["_menubutton"];
		private _dataControl = _menubutton controlsGroupCtrl SP_MENU_BUTTON_DATA;
		private _module = ctrlText _dataControl;

		// set new module
		SP_var_core_currentModule = _module;

		// move buttons background
		(ctrlPosition _menubutton) call SP_fnc_core_moveMenuButtonsBackground;
	}];
} forEach SP_var_menuButtonsControls; // variable defined in the step above





/*******************************
***** on mouse button down *****
*******************************/
_eventControl ctrlAddEventHandler ["MouseButtonDown", {
	params ["", "_button"];

	if (_button == 0) then {
		SP_var_core_primaryMouseButton = true;
		["MODULE", SP_var_core_currentModule, "OnPrimaryMouseButtonDown"] call SP_fnc_core_tryEvent;
	};

	if (_button == 1) then {
		SP_var_core_secondaryMouseButton = true;
	};

	true
}];





/*****************************
***** on mouse button up *****
*****************************/
_eventControl ctrlAddEventHandler ["MouseButtonUp", {
	params ["", "_button"];

	if (_button == 0) then {
		SP_var_core_primaryMouseButton = false;
		["MODULE", SP_var_core_currentModule, "OnPrimaryMouseButtonUp"] call SP_fnc_core_tryEvent;
	};

	if (_button == 1) then {
		SP_var_core_secondaryMouseButton = false;
	};

	true
}];





/********************************
***** on mouse wheel change *****
********************************/
_eventControl ctrlAddEventHandler ["MouseZChanged", {
	// try OnMouseZChange for every tools the current module uses
	{
		["TOOL", _x, "OnMouseZChange"] call SP_fnc_core_tryEvent;
	} forEach getArray (configFile >> "CfgSurfacePainter" >> "Modules" >> SP_var_core_currentModule >> "tools");

	// try OnMouseZChange event for the current module
	["TOOL", _x, "OnMouseZChange"] call SP_fnc_core_tryEvent;

	true
}];





/************************
***** on mouse move *****
************************/
_eventControl ctrlAddEventHandler ["MouseMoving", {
	params ["", "_x", "_y"];

	SP_var_core_mouseScreenPosition = [_x, _y];
	SP_var_core_mouseWorldPosition = screenToWorld SP_var_core_mouseScreenPosition;

	// try OnMouseMove event
	["MODULE", SP_var_core_currentModule, "OnMouseMove"] call SP_fnc_core_tryEvent;

	// camera rotation
	if (SP_var_core_secondaryMouseButton) then {
		SP_var_core_mousePreviousFrameScreenPosition params ["_xd", "_yd"];

		// camera direction
		SP_var_core_cameraDir = SP_var_core_cameraDir + (_x - _xd) * SP_var_core_cameraRotationSensibility;
		SP_var_core_camera setDir SP_var_core_cameraDir;

		// camera pitch
		SP_var_core_cameraPitch = SP_var_core_cameraPitch - (_y - _yd) * SP_var_core_cameraRotationSensibility;
		SP_var_core_cameraPitch = SP_var_core_cameraPitch max -90 min 90;
		[SP_var_core_camera, SP_var_core_cameraPitch, 0] call bis_fnc_setpitchbank;
	};

	SP_var_core_mousePreviousFrameScreenPosition = [_x, _y];

	true
}];





/**********************
***** on key down *****
**********************/
_eventControl ctrlAddEventHandler ["KeyDown", {
	params ["", "_key"];

	// if Esc. pressed, exit
	if (_key == 1) exitWith { false };

	// special keys
	if (_key == 42) then { SP_var_keyShift = true; };
	if (_key == 29) then { SP_var_keyCtrl = true; };
	if (_key == 56) then { SP_var_keyAlt = true; };
	if (_key in (actionKeys "cameraMoveTurbo1")) then { SP_var_keyTurbo = true; };

	// camera behaviour
	{
		if (_key in (actionKeys _x)) then {
			[SP_var_core_cameraTranslationKeys, _x, true] call SP_fnc_core_setToPairs;
		};
	} forEach ACTIONS;

	if (!SP_var_core_cameraTranslationLoop) then {
		SP_var_core_cameraTranslationLoop = true;

		[_key] spawn {
			params ["_key"];

			while {SP_var_core_cameraTranslationLoop} do {
				private _newPos = getPosASL SP_var_core_camera;
				private _speedMultiplier = (((ASLToATL _newPos) select 2) * 0.01 + 0.05);

				if (SP_var_keyTurbo) then {
					_speedMultiplier = _speedMultiplier * SP_var_core_cameraTranslationTurboMultiplier;
				};

				{

					if ([SP_var_core_cameraTranslationKeys, _x] call SP_fnc_core_getFromPairs) then {
						private _translation = TRANSLATIONS select _forEachIndex;
						_translation params ["_tx", "_ty", "_tz"];

						_dir = (getDir SP_var_core_camera) + _tx * 90;
						_newPos = [
							(_newPos select 0) + ((sin _dir) * SP_var_core_cameraTranslationSensibility * _ty * _speedMultiplier),
							(_newPos select 1) + ((cos _dir) * SP_var_core_cameraTranslationSensibility * _ty * _speedMultiplier),
							(_newPos select 2) + _tz * SP_var_core_cameraTranslationSensibility * _speedMultiplier
						];
					};
				} forEach ACTIONS;

				if (count _newPos != 0) then {
					_newPos set [2, (_newPos select 2) max (getTerrainHeightASL (_newPos))];
					SP_var_core_camera setPosASL _newPos;

					// update mouse world position so if the camera move but the mouse stay at the same position
					// the var still has the correct value
					SP_var_core_mouseWorldPosition = screenToWorld SP_var_core_mouseScreenPosition;
				};
			};
		};
	};

	true
}];





/********************
***** on key up *****
********************/
_eventControl ctrlAddEventHandler ["KeyUp", {
	params ["", "_key"];

	//  special keys
	if (_key == 42) then { SP_var_keyShift = false; };
	if (_key == 29) then { SP_var_keyCtrl = false; };
	if (_key == 56) then { SP_var_keyAlt = false; };
	if (_key in (actionKeys "cameraMoveTurbo1")) then { SP_var_keyTurbo = false; };

	// modules shortcuts
	if (_key in SHORTCUTS) then {
		private _newButtonControl = SP_var_menuButtonsControls select (_key - 2);
		_newButtonDataControl = _newButtonControl controlsGroupCtrl SP_MENU_BUTTON_DATA;
		private _newModule = ctrlText _newButtonDataControl;
		SP_var_core_currentModule = _newModule;
		(ctrlPosition _newButtonControl) call SP_fnc_core_moveMenuButtonsBackground;
	};

	// camera behaviour
	{
		if (_key in (actionKeys _x)) then {
			[SP_var_core_cameraTranslationKeys, _x, false] call SP_fnc_core_setToPairs;
		};
	} forEach ACTIONS;

	if (({[SP_var_core_cameraTranslationKeys, _x] call SP_fnc_core_getFromPairs} count ACTIONS) == 0) then {
		SP_var_core_cameraTranslationLoop = false;
	};

	true
}];







// ui logic initialization
/*
[] spawn {


	// fill modes list
	#include "events\dialogCreated.sqf";

	// left panel behaviour when mouse enter and exit
	#include "events\leftPanelCtrlMouseEnterExit.sqf"

	// activate default tools
	if (!isNil { SP_var_mode }) then {
		// mode and tools activation
		#include "events\dialogModeToolsActivate.sqf"

		// show the correct options control group
		_modes = (configFile >> "CfgSurfacePainter" >> "Modules") call BIS_fnc_getCfgSubClasses;

		{
			ctrlShow [getNumber (configFile >> "CfgSurfacePainter" >> "Modules" >> _x >> "idc"), false];
		} forEach _modes;

		ctrlShow [getNumber (configFile >> "CfgSurfacePainter" >> "Modules" >> SP_var_mode >> "idc"), true];
	};
};
*/



// wait for loading screen to be completely faded in
waitUntil { ctrlFade _loadingControlsGroup == 0 };

// create camera
showCinemaBorder false;
private _cameraPosition = (player getRelPos [10, 180]);
_cameraPosition set [2, ((getPosASL player) select 2) + 6];
SP_var_core_camera = "camera" camCreate ASLToATL _cameraPosition;
SP_var_core_camera cameraEffect ["internal", "BACK"];
SP_var_core_cameraDir = (getDir player);
SP_var_core_camera setDir SP_var_core_cameraDir;
SP_var_core_cameraPitch = -20;
[SP_var_core_camera, SP_var_core_cameraPitch, 0] call BIS_fnc_setPitchBank;
SP_var_core_camera camCommit 0;

// set default state of camera translation keys
{
	[SP_var_core_cameraTranslationKeys, _x, false] call SP_fnc_core_setToPairs;
} forEach ACTIONS;

// show menu
_menuControlsGroup ctrlSetFade 0;
_menuControlsGroup ctrlCommit 0;

// fade loading screen out
_loadingControlsGroup ctrlSetFade 1;
_loadingControlsGroup ctrlCommit 0.1;
sleep 0.1;
_loadingControlsGroup ctrlEnable false;
