#include "..\..\sizes.hpp"

private _dialog		= _this select 0;
private _ctrlGrp	= _this select 1;
private _idc		= param [2, -1, [0]];
private _text		= param [3, "Option", [""]];
private _y			= param [4, 0, [0]];
private _toolTip	= param [5, nil, [""]];

private _checkBox = _dialog ctrlCreate ["RscCheckBox", _idc, _ctrlGrp];
_checkBox ctrlSetPosition [safeZoneW * SP_MARGIN_X, safeZoneH * _y, safeZoneW * SP_OPTIONS_CONTENT_W * SP_OPTION_CHECKBOX_CHECKBOX_W, safeZoneH * SP_OPTION_CONTENT_H];
_checkBox ctrlSetBackgroundColor [0, 0, 0, 0.5];
_checkBox ctrlCommit 0;

private _label = _dialog ctrlCreate ["RscText", -1, _ctrlGrp];
_label ctrlSetPosition [safeZoneW * (SP_OPTION_CHECKBOX_CHECKBOX_W * SP_OPTIONS_CONTENT_W + SP_MARGIN_X), safeZoneH * _y, safeZoneW * SP_OPTIONS_CONTENT_W * SP_OPTION_CHECKBOX_TEXT_W, safeZoneH * SP_OPTION_CONTENT_H];
_label ctrlSetBackgroundColor SP_OPTION_TEXT_BACKGROUND;
_label ctrlCommit 0;
_label ctrlSetText _text;

if (!isNil {_toolTip}) then {
	_label ctrlSetTooltip _toolTip;
};

_checkBox
