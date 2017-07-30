#define CAMERA_STEP 0.07
#define CAMERA_SHIFT_SPEED_MULTIPLIER 3

{
	if ((_this select 1) in (actionKeys _x)) then {
		[SP_var_cameraKeys, _x, true] call BIS_fnc_setToPairs;
	};
} forEach ["MoveForward", "MoveBack", "TurnLeft", "TurnRight", "LeanLeft", "MoveDown"];

if (!SP_var_while) then {
	SP_var_while = true;

	[] spawn {
		while {SP_var_while} do {
			_newPos = [];

			{
				_action			= _x select 0;
				_translation	= _x select 1;

				if ([SP_var_cameraKeys, _action] call BIS_fnc_getFromPairs) then {
					_dX = _translation select 0;
					_dY = _translation select 1;
					_dZ	 = _translation select 2;

					if ((count _newPos) == 0) then {
						_newPos = getPosASL SP_var_camera;
					};

					_speedMultiplier = (((ASLToATL _newPos) select 2) * 0.01 + 0.05);

					if (SP_key_shift) then {
						_speedMultiplier = _speedMultiplier * CAMERA_SHIFT_SPEED_MULTIPLIER;
					};

					_dir = (direction SP_var_camera) + _dX * 90;
					_newPos = [
						(_newPos select 0) + ((sin _dir) * CAMERA_STEP * _dY * _speedMultiplier),
						(_newPos select 1) + ((cos _dir) * CAMERA_STEP * _dY * _speedMultiplier),
						(_newPos select 2) + _dZ * CAMERA_STEP * _speedMultiplier
					];
				};
			} forEach [
				["MoveForward", [0, 1, 0]],
				["MoveBack", [0, -1, 0]],
				["TurnLeft", [-1, 1, 0]],
				["TurnRight", [1, 1, 0]],
				["LeanLeft", [0, 0, 1]],
				["MoveDown", [0, 0, -1]]
			];

			if (count _newPos != 0) then {
				_newPos set [2, (_newPos select 2) max (getTerrainHeightASL (_newPos))];
				SP_var_camera setPosASL _newPos;

				// update mouse world position so if the camera mouve but the mouse stay at the same position
				// the var has the correct value anyway
				SP_var_mouseWorldPosition = screenToWorld SP_var_mouseScreenPosition;
			};
		};
	};
};
