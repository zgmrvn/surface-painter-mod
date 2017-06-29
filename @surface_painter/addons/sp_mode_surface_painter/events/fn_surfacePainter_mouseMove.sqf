if (SP_var_surfacePainter_down && {SP_var_surfacePainter_mutex}) then {
	if ((SP_var_surfacePainter_lastPos distance SP_var_mouseWorldPosition) > 1) then {

		SP_var_surfacePainter_lastPos = SP_var_mouseWorldPosition;

		if (SP_key_alt) then {
			private _pixels = nearestObjects [SP_var_surfacePainter_lastPos, [], SP_var_circle_circleRadius, true];

			{
				private _pos = (getPosASL _x) vectorAdd [-0.5, -0.5, 0];
				private _key = format ["%1:%2", _pos select 0, _pos select 1];

				[SP_var_surfacePainter_pixels, _key] call BIS_fnc_removeFromPairs;

				deleteVehicle _x;
			} forEach _pixels;
		} else {
			SP_var_surfacePainter_mutex = false;
			[] spawn SP_fnc_surfacePainter_paint;
		};
	};
};
