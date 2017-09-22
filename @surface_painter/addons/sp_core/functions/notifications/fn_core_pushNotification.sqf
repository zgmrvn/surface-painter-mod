/*
	Function: SP_fnc_core_pushNotification

	Description:
		Pushes a notification in the notification stack.

	Parameters:
		_type: "OK", "WARNING", "NOK"
		_text: text that will be displayed

	Example:
		(begin example)
		["OK", "This is a notification"] call SP_fnc_core_pushNotification;
		(end)

	Returns:
		nothing

	Author:
		zgmrvn
*/

#include "..\..\idcs.hpp"
#include "..\..\sizes.hpp"

#define FADE_DURATION 0.15
#define NOTIFICATION_LIFESPAN 5

private _type = param [0, "OK", [""]];
private _text = param [1, "Text", [""]];

disableSerialization;

private _dialog					= findDisplay SP_SURFACE_PAINTER_IDD;
private _notificationsCtrlGroup	= _dialog displayCtrl SP_SURFACE_PAINTER_NOTIFICATIONS_CTRL_GROUP;

// create notification
private _notification = _dialog ctrlCreate ["RscSpNotification", -1, _notificationsCtrlGroup];
SP_var_notifications pushBack _notification;

private _imageCtrl	= _notification controlsGroupCtrl 3;
private _textCtrl	= _notification controlsGroupCtrl 4;

// set notification control group height
private _pos = ctrlPosition _notificationsCtrlGroup;
_notificationsCtrlGroup ctrlSetPosition [
	_pos select 0,
	_pos select 1,
	_pos select 2,
	safeZoneH * SP_NOTIFICATION_H * (count SP_var_notifications) + SP_NOTIFICATION_MARGIN * ((count SP_var_notifications) * 1)
];

_notificationsCtrlGroup ctrlCommit FADE_DURATION;

// set new notification
_image = switch (_type) do {
	case ("WARNING"): {"x\surface_painter\addons\sp_core\data\notification_yellow.paa"};
	case ("NOK"): {"x\surface_painter\addons\sp_core\data\notification_red.paa"};
	default {"x\surface_painter\addons\sp_core\data\notification_green.paa"};
};

_imageCtrl ctrlSetText _image;
_textCtrl ctrlSetText _text;

// delay fade out
[_notification] spawn {
	disableSerialization;

	params ["_notification"];

	sleep FADE_DURATION;
	_notification ctrlSetFade 0;
	_notification ctrlCommit FADE_DURATION;
};

// push the stack
{
	private _pos = ctrlPosition _x;

	_x ctrlSetPosition [
		0,
		(_pos select 1) + safeZoneH * SP_NOTIFICATION_H + SP_NOTIFICATION_MARGIN,
		safeZoneW * SP_NOTIFICATION_W,
		safeZoneH * SP_NOTIFICATION_H
	];

	_x ctrlCommit FADE_DURATION;
} forEach SP_var_notifications;

// timer then delete the notification
[_notification] spawn {
	disableSerialization;

	params ["_notification"];

	_dialog					= findDisplay SP_SURFACE_PAINTER_IDD;
	_notificationsCtrlGroup	= _dialog displayCtrl SP_SURFACE_PAINTER_NOTIFICATIONS_CTRL_GROUP;

	// notification lifespan
	sleep NOTIFICATION_LIFESPAN;

	// notification fade in
	_notification ctrlSetFade 1;
	_notification ctrlCommit FADE_DURATION;
	sleep FADE_DURATION;

	// delete notification
	SP_var_notifications deleteAt 0;

	_pos = ctrlPosition _notificationsCtrlGroup;

	_notificationsCtrlGroup ctrlSetPosition [
		_pos select 0,
		_pos select 1,
		_pos select 2,
		safeZoneH * SP_NOTIFICATION_H * (count SP_var_notifications) + SP_NOTIFICATION_MARGIN * ((count SP_var_notifications) * 1)
	];

	_notificationsCtrlGroup ctrlCommit 0;

	ctrlDelete _notification;
};
