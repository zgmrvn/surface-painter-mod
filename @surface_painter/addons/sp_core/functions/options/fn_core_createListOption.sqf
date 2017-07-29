#include "..\..\sizes.hpp"

private _dialog		= _this select 0;
private _ctrlGrp	= _this select 1;
private _idc		= param [2, -1, [0]];
private _y			= param [3, 0, [0]];
private _h			= param [4, 0, [0]];

private _edit = _dialog ctrlCreate ["RscListBox", _idc, _ctrlGrp];
_edit ctrlSetPosition [safeZoneW * SP_MARGIN_X, safeZoneH * _y, safeZoneW * SP_OPTIONS_CONTENT_W, safeZoneH * SP_OPTION_CONTENT_H + safeZoneH * _h];
_edit ctrlSetBackgroundColor [0, 0, 0, 0.5];
_edit ctrlCommit 0;

_edit
