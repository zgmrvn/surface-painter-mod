/*
	Brush - Mouse down
	This function runs when mouse button is pressed down on world.
*/

#define DISTANCE_MARGIN				15
#define MAX_DISTANCE_FROM_CAMERA	1000
#define MAX_SEARCH_ITERATIONS		16

[] spawn {
	// if ALT pressed, we want to erase
	if (SP_key_alt) then {
		SP_var_brush_loop = true;

		while {SP_var_brush_loop} do {
			private _vehs = nearestObjects [SP_var_mouseWorldPosition, [], SP_var_circle_circleRadius, true];
			if ((count _vehs) > 0) then {
				_obj = selectRandom _vehs;
				SP_var_createdObjects deleteAt (SP_var_createdObjects find _obj);
				deleteVehicle _obj;
			};

			sleep (1 / SP_var_brush_flow);
		};

	// else, if ALT not pressed, we want to paint
	} else {
		// if the object pool is not empty
		if ((count SP_var_pool_finalPool) > 0) then {
			SP_var_brush_loop = true;

			while {SP_var_brush_loop} do {
				// if mouse world position is under 1000m from the camera
				if ((SP_var_camera distance SP_var_mouseWorldPosition) < MAX_DISTANCE_FROM_CAMERA) then {
					// if the distance option is > 0, we check for a free position
					private _pos = if (SP_var_brush_distance > 0) then {
						// we have MAX_SEARCH_ITERATIONS iterations to find a valid position
						for "_i" from 0 to MAX_SEARCH_ITERATIONS do {
							private _temp		= [SP_var_mouseWorldPosition, random SP_var_circle_circleRadius, random 360] call BIS_fnc_relPos;
							// todo : there should be a class to avoid bees and all non-wanted things
							private _objects	= nearestObjects [_temp, [], SP_var_brush_distance + DISTANCE_MARGIN];
							private _inArea		= _objects inAreaArray [_temp, SP_var_brush_distance, SP_var_brush_distance, 0, false, -1];

							// if no object were found in the area, we go with this position
							if ((count _inArea) == 0) exitWith { _temp };
						};

					// otherwise, we just pick a random position
					} else {
						[SP_var_mouseWorldPosition, random SP_var_circle_circleRadius, random 360] call BIS_fnc_relPos
					};

					// then we create an object only if we've got a valid position
					if (!isNil {_pos}) then {
						private _classname = selectRandom SP_var_pool_finalPool;
						private _keepHorizontal = getNumber (configFile >> "CfgVehicles" >> _classname >> "keepHorizontalPlacement");
						_keepHorizontal = [true, false] select (_keepHorizontal == 0);

						_obj = [ATLToASL _pos, _classname, _keepHorizontal] call SP_fnc_core_createSimpleObject;
						SP_var_createdObjects pushBack _obj;
					};
				};

				sleep (1 / SP_var_brush_flow);
			};

		// if the object pool is empty
		} else {
			["NOK", localize "STR_SP_CORE_NOTIFICATION_OBJECT_POOL_EMPTY"] spawn SP_fnc_core_pushNotification;
		};
	};
};
