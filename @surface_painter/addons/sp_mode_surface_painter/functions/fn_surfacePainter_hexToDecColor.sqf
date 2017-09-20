/*
	Function: SP_fnc_surfacePainter_hexToDecColor.sqf

	Description:
		Convert hexadecimal color to decimal color.

	Parameters:
		_chars: hexadecimal color : "FF00FF"

	Example:
		(begin example)
		"FF00FF" call SP_fnc_surfacePainter_hexToDecColor;
		(end)

	Returns:
		_color: array of color to [0-1, 0-1, 0-1] format

	Author:
		zgmrvn
*/

#define HEXA ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F"]
#define DECI [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 ,16]

private _chars	= (toUpper _this) splitString "";
private _total	= 0;
private _final	= [];

{
	private _value = DECI select (HEXA find _x);
	_value = _value * 16^(1 - (_forEachIndex % 2));

	_total = _total + _value;

	if (((_forEachIndex + 1) % 2) == 0) then {
		_final pushBack (_total / 256);
		_total = 0;
	};
} forEach _chars;

_final
