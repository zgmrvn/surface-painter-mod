#include "..\..\sizes.hpp"

// todo : this could handle letters, min and max range and global variable has a reference

private _dialog		= _this select 0;
private _ctrlGrp	= _this select 1;
private _idc		= param [2, -1, [0]];
private _value		= param [3, "0", [""]];
private _text		= param [4, "Option", [""]];
private _y			= param [5, 0, [0]];
private _toolTip	= param [6, nil, [""]];

private _edit = _dialog ctrlCreate ["RscEdit", _idc, _ctrlGrp];
_edit ctrlSetPosition [safeZoneW * SP_MARGIN_X, safeZoneH * _y, safeZoneW * SP_OPTIONS_CONTENT_W * SP_OPTION_EDIT_EDIT_W, safeZoneH * SP_OPTION_CONTENT_H];
_edit ctrlSetBackgroundColor [0, 0, 0, 0.5];
_edit ctrlCommit 0;
_edit ctrlSetText _value;

private _label = _dialog ctrlCreate ["RscText", -1, _ctrlGrp];
_label ctrlSetPosition [safeZoneW * (SP_OPTION_EDIT_EDIT_W * SP_OPTIONS_CONTENT_W + SP_MARGIN_X), safeZoneH * _y, safeZoneW * SP_OPTIONS_CONTENT_W * SP_OPTION_EDIT_TEXT_W, safeZoneH * SP_OPTION_CONTENT_H];
_label ctrlSetBackgroundColor SP_OPTION_TEXT_BACKGROUND;
_label ctrlCommit 0;
_label ctrlSetText _text;

if (!isNil {_toolTip}) then {
	_label ctrlSetTooltip _toolTip;
};

_edit
