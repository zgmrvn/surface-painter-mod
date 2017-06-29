#include "..\..\sizes.hpp"

private _dialog		= _this select 0;
private _ctrlGrp	= _this select 1;
private _idc		= param [2, -1, [0]];
private _text		= param [3, "Button", [""]];
private _y			= param [4, 0, [0]];

private _button = _dialog ctrlCreate ["RscButton", _idc, _ctrlGrp];
_button ctrlSetPosition [safeZoneW * SP_MARGIN_X, safeZoneH * _y, safeZoneW * SP_OPTIONS_CONTENT_W, safeZoneH * SP_OPTION_CONTENT_H];
_button ctrlCommit 0;
_button ctrlSetText _text;

_button
