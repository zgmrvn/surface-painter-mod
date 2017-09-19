/*
	Mouse down for Surface Painter mode.
	This function will run everytime mouse button is pressed.
*/

// if there is a paint loop running, exit
if (!SP_var_surfacePainter_mutex) exitWith {};

SP_var_surfacePainter_down = true;

// if Alt key is pressed
if (SP_key_alt) then {
	if (SP_var_surfacePainter_mutex) then {
		SP_var_surfacePainter_mutex = false;

		private _pixels = nearestObjects [SP_var_mouseWorldPosition, [], SP_var_circle_circleRadius, true];

		{
			if (((getModelInfo _x) select 0) == "pixel.p3d") then {
				private _index = SP_var_surfacePainter_keys find (_x getVariable "SP_var_pixelPosition");
				SP_var_surfacePainter_pixels deleteAt _index;
				SP_var_surfacePainter_keys deleteAt _index;

				deleteVehicle _x;
			};
		} forEach _pixels;

		SP_var_surfacePainter_mutex = true;
	};
} else {
	SP_var_surfacePainter_mutex = false;
	[] spawn SP_fnc_surfacePainter_paint;
};
