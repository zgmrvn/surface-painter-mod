#include "idcs.hpp"
#include "sizes.hpp"

// camera
showCinemaBorder false;
SP_var_camera = "camera" camCreate (getposASL player);
SP_var_camera cameraEffect ["internal", "BACK"];
SP_var_camera camCommit 0;
SP_var_cameraDir	= 0; // camera direction
SP_var_cameraPitch	= 0; // camera pitch

// mouse
SP_var_primaryMouseButton	= false; // mouse main click mutex
SP_var_secondaryMouseButton	= false; // mouse second click mutex
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

// mode
_modes = (configFile >> "CfgSurfacePainter" >> "Modules") call BIS_fnc_getCfgSubClasses;
SP_var_mode = _modes select 0;

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

// ui logic initialization
[] spawn {
	waitUntil {!(isNull (findDisplay SP_SURFACE_PAINTER_IDD))};

	disableserialization;

	_dialog						= findDisplay SP_SURFACE_PAINTER_IDD;
	_eventCtrl					= _dialog displayCtrl SP_SURFACE_PAINTER_EVENT_CTRL; // this is the main control for catching events
	_leftPanelCtrlGroup			= _dialog displayCtrl SP_SURFACE_PAINTER_LEFT_PANEL_CTRL_GROUP;
	_modeslist					= _dialog displayCtrl SP_SURFACE_PAINTER_MODES_LIST;
	_leftPanelEnterEventCtrl	= _dialog displayCtrl SP_SURFACE_PAINTER_LEFT_PANEL_EVENT_ENTER_CTRL;
	_leftPanelExitEventCtrl		= _dialog displayCtrl SP_SURFACE_PAINTER_LEFT_PANEL_EVENT_EXIT_CTRL;

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

	// on mouse button down
	_eventCtrl ctrlAddEventHandler ["MouseButtonDown", {
		_button = _this select 1;

		// mouse buttons down behaviour
		#include "events\eventCtrlMouseDown.sqf"

		true

	}];

	// on mouse button up
	_eventCtrl ctrlAddEventHandler ["MouseButtonUp", {
		_button = _this select 1;

		// mouse buttons up behaviour
		#include "events\eventCtrlMouseUp.sqf"

		true
	}];

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
