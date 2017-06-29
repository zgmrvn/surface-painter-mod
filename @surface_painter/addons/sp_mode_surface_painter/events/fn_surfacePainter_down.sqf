/*
	Mouse down for Surface Painter mode.
	This function will run everytime mouse button is pressed.
*/

// if there is a paint loop running, exit
if (!SP_var_surfacePainter_mutex) exitWith {};

SP_var_surfacePainter_down = true;

// if Alt key is pressed
if (SP_key_alt) then {
	private _pixels = nearestObjects [SP_var_mouseWorldPosition, [], SP_var_circle_circleRadius, true];

	{
		private _pos = (getPosASL _x) vectorAdd [-0.5, -0.5, 0];
		private _key = format ["%1:%2", _pos select 0, _pos select 1];

		[SP_var_surfacePainter_pixels, _key] call BIS_fnc_removeFromPairs;

		deleteVehicle _x;
	} forEach _pixels;


} else {
	SP_var_surfacePainter_mutex = false;

	[] spawn SP_fnc_surfacePainter_paint;
}
