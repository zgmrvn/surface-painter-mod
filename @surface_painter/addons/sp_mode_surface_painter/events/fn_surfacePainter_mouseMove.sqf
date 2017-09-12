if (SP_var_surfacePainter_down && {SP_var_surfacePainter_mutex}) then {
	if ((SP_var_surfacePainter_lastPos distance SP_var_mouseWorldPosition) > 1) then {

		SP_var_surfacePainter_lastPos = SP_var_mouseWorldPosition;

		if (SP_key_alt) then {
			if (SP_var_surfacePainter_mutex) then {
				SP_var_surfacePainter_mutex = false;

				private _pixels = nearestObjects [SP_var_mouseWorldPosition, [], SP_var_circle_circleRadius, true];

				{
					if (((getModelInfo _x) select 0)  == "pixel.p3d") then {
						[SP_var_surfacePainter_pixels, _x getVariable "SP_var_pixelPosition"] call BIS_fnc_removeFromPairs;

						deleteVehicle _x;
					};
				} forEach _pixels;

				SP_var_surfacePainter_mutex = true;
			};
		} else {
			SP_var_surfacePainter_mutex = false;
			[] spawn SP_fnc_surfacePainter_paint;
		};
	};
};
