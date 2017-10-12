#include "idcs.hpp"
#include "sizes.hpp"

#define MODULES (configFile >> "CfgSurfacePainter" >> "Modules")
/*
// camera
showCinemaBorder false;
SP_var_camera = "camera" camCreate (getposASL player);
SP_var_camera cameraEffect ["internal", "BACK"];
SP_var_camera camCommit 0;
SP_var_cameraDir	= 0; // camera direction
SP_var_cameraPitch	= 0; // camera pitch


SP_var_mouseScreenDelta		= [0.5, 0.5]; // mouse screen position during the previous frame
SP_var_mouseScreenPosition	= [0.5, 0.5]; // mouse screen position during the current frame
SP_var_mouseWorldPosition	= screenToWorld SP_var_mouseScreenPosition; // mouse world position

// special keys
SP_key_shift	= false; // is shift held ?
SP_key_ctrl		= false; // is ctrl held ?
SP_key_alt		= false; // is alt held ?

// this var will contain every created objects
// if this variable doesn't already exist, we set it to an empty array
if (isNil {SP_var_createdObjects}) then {
	SP_var_createdObjects = [];
};

// notifications
SP_var_notificationsStack 	= [];
SP_var_notificationsLoop	= false;
SP_var_notifications		= [];

// camera control keys
SP_var_cameraKeys = [];
{
	[SP_var_cameraKeys, _x, false] call BIS_fnc_setToPairs;
} forEach [
	"MoveForward",
	"MoveBack",
	"TurnLeft",
	"TurnRight",
	"LeanLeft",
	"MoveDown"
];
SP_var_while = false;
*/

//waitUntil { !isNull _this };

//systemChat str _this;


disableserialization;

waitUntil { !isNull findDisplay SP_IDD };

private _dialog	= findDisplay SP_IDD;
private _eventControl = _dialog displayCtrl SP_EVENT_CONTROL; // this is the main control for catching events

private _menuControlsGroup = _dialog displayCtrl SP_MENU_CONTROLS_GROUP;
private _modulesControlsGroup = _menuControlsGroup controlsGroupCtrl SP_MODULES_CONTROLS_GROUP;

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









// set default module if not already defined
if (isNil "SP_var_core_currentModule") then {
	SP_var_core_currentModule = _modules select 0;
};

// mouse
SP_var_core_primaryMouseButton = false;
SP_var_core_secondaryMouseButton = false;






// compile events for modules
{
	private _module = _x;
	private _path = getText (MODULES >> _module >> "path");
	private _events = ("true" configClasses (MODULES >> _module >> "Events")) apply { configName _x };

	{
		private _event = _x;
		private _script = format ["%1\events\%2", _path, getText (MODULES >> _module >> "Events" >> _event >> "script")];

		missionNamespace setVariable [
			format ["SP_event_%1_%2", _module, _event],
			compile preprocessFileLineNumbers _script
		];
	} forEach _events;
} forEach _modules;









// fill menu
{
	private _menuButton = _dialog ctrlCreate ["MenuButton", -1, _modulesControlsGroup];
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








// try OnInit events
{
	["MODULE", _x, "OnInit"] call SP_fnc_core_tryEvent;
} forEach _modules;


// on mouse button down
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


// on mouse button up
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





	/*private _module = _x;

	if (isClass (MODULES >> _module >> "Events" >> "OnInit")) then {
		format ["SP_event_%1_onInit", _module];
	};

	private _path = getText (MODULES >> _module >> "path");


	private _events = ("true" configClasses (MODULES >> _module >> "Events")) apply { configName _x };
*/




// ui logic initialization
/*
[] spawn {


	// fill modes list
	#include "events\dialogCreated.sqf";

	// exec init events for modes and tools
	#include "events\dialogModesToolsInit.sqf";

	// on key up
	_eventCtrl ctrlAddEventHandler ["KeyDown", {
		_key = _this select 1;

		// if escape pressed, exit
		if (_key == 1) exitWith { false };

		// key down behaviour
		#include "events\eventCtrlKeyDown.sqf";

		// camera behaviour
		#include "cam\keyDownCameraMouvments.sqf";

		true
	}];

	_eventCtrl ctrlAddEventHandler ["KeyUp", {
		_key = _this select 1;

		// key up behaviour
		#include "events\eventCtrlKeyUp.sqf";

		// camera behaviour
		#include "cam\keyUpCameraMouvments.sqf"

		true
	}];
	*/



/*


	// on mouse move in the main control
	_eventCtrl ctrlAddEventHandler ["MouseMoving", {
		SP_var_mouseScreenPosition = [_this select 1, _this select 2];
		SP_var_mouseWorldPosition = screenToWorld SP_var_mouseScreenPosition;

		// mouse move behaviour
		#include "events\eventCtrlMouseMove.sqf"

		if (SP_var_secondaryMouseButton) then {
			// camera behaviour
			#include "cam\mouseMovingCameraMouvments.sqf"
		};

		SP_var_mouseScreenDelta = [_this select 1, _this select 2];

		true
	}];

	// on mouse wheel change
	_eventCtrl ctrlAddEventHandler ["MouseZChanged", {
		// mouse move behaviour
		#include "events\eventCtrlMouseZChanged.sqf"

		true
	}];

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