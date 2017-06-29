#include "..\..\sizes.hpp"

private _dialog		= _this select 0;
private _ctrlGrp	= _this select 1;
private _text		= param [2, "Header", [""]];
private _y			= param [3, 0, [0]];

private _header = _dialog ctrlCreate ["RscStructuredText", -1, _ctrlGrp];
_header ctrlSetPosition [safeZoneW * SP_MARGIN_X, safeZoneH * _y, safeZoneW * SP_OPTIONS_CONTENT_W, safeZoneH * SP_OPTION_CONTENT_H];
_header ctrlCommit 0;
_header ctrlSetStructuredText parseText (format ["<t size='1.2'>%1</t>", _text]);

private _background = _dialog ctrlCreate ["RscText", -1, _ctrlGrp];
_background ctrlSetPosition [safeZoneW * SP_MARGIN_X, safeZoneH * _y + SP_OPTION_HEADER_UNDERLINE_M, safeZoneW * SP_OPTIONS_CONTENT_W, safeZoneH * SP_OPTION_CONTENT_H * 0.06];

private _color = [
	profilenamespace getvariable ["GUI_BCG_RGB_R", 0.5],
	profilenamespace getvariable ["GUI_BCG_RGB_G", 0.5],
	profilenamespace getvariable ["GUI_BCG_RGB_B", 0.5],
	1
];

_background ctrlSetBackgroundColor _color;
_background ctrlCommit 0;

_header
