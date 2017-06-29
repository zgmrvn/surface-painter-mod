#include "..\..\sizes.hpp"

// todo : this could handle letters, min and max range and global variable has a reference

private _dialog		= _this select 0;
private _ctrlGrp	= _this select 1;
private _idc		= param [2, -1, [0]];
private _values		= param [3, ["null"], [[]]];
private _y			= param [4, 0, [0]];

private _edit = _dialog ctrlCreate ["RscCombo", _idc, _ctrlGrp];
_edit ctrlSetPosition [safeZoneW * SP_MARGIN_X, safeZoneH * _y, safeZoneW * SP_OPTIONS_CONTENT_W, safeZoneH * SP_OPTION_CONTENT_H];
_edit ctrlSetBackgroundColor [0, 0, 0, 0.5];
_edit ctrlCommit 0;

{
	lbAdd [_idc, _x select 0];
	lbSetData [_idc, _forEachIndex, _x select 1]
} forEach _values;

lbSetCurSel [_idc, 0];



_edit
