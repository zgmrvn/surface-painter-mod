#include "..\..\sizes.hpp"

private _dialog		= _this select 0;
private _ctrlGrp	= _this select 1;
private _idc		= param [2, -1, [0]];
private _text		= param [3, "Text", [""]];
private _y			= param [4, 0, [0]];

private _rsc = _dialog ctrlCreate ["RscText", _idc, _ctrlGrp];
_rsc ctrlSetPosition [safeZoneW * SP_MARGIN_X, safeZoneH * _y, safeZoneW * SP_OPTIONS_CONTENT_W, safeZoneH * SP_OPTION_CONTENT_H];
_rsc ctrlSetBackgroundColor SP_OPTION_TEXT_BACKGROUND;
_rsc ctrlCommit 0;
_rsc ctrlSetText _text;

_rsc
