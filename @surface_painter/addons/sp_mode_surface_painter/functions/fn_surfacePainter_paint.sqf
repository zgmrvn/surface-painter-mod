

	SP_var_surfacePainter_lastPos = SP_var_mouseWorldPosition;

	_startPos = [
		(round (SP_var_surfacePainter_lastPos select 0)) + 0.5,
		(round (SP_var_surfacePainter_lastPos select 1)) + 0.5,
		0.1
	];


	_area = [SP_var_surfacePainter_lastPos, SP_var_circle_circleRadius, SP_var_circle_circleRadius, 0, false, -1];



	_x = SP_var_circle_circleRadius;
	_d = 0;

	_pos = _startPos;
	_add = [1, 0, 0];
	_dir = [0, 1, 0, -1, 0, 1];
	_c	= 1;
	_i = 0;
	_l = 1;

	while {_d < _x} do {
		if (_pos inArea _area) then {
			_key = format ["%1:%2", (_pos select 0) - 0.5, (_pos select 1) - 0.5];


			if (([SP_var_surfacePainter_pixels, _key] call BIS_fnc_findInPairs) == -1) then {

				systemChat _key;

				_obj = createSimpleObject ["Land_SurfaceMapPixel", ATLToASL _pos];
				_obj setObjectTexture [0, format ["#(rgb,8,8,3)color(%1,%2,%3,1)", SP_var_surfacePainter_color select 0, SP_var_surfacePainter_color select 1, SP_var_surfacePainter_color select 2]];

				[SP_var_surfacePainter_pixels, _key, _obj] call BIS_fnc_setToPairs;
			} else {
				([SP_var_surfacePainter_pixels, _key] call BIS_fnc_getFromPairs) setObjectTexture [0, format ["#(rgb,8,8,3)color(%1,%2,%3,1)", SP_var_surfacePainter_color select 0, SP_var_surfacePainter_color select 1, SP_var_surfacePainter_color select 2]];
			};
		};

		if (_i == _l) then {

			_i = 0;

			// si 2 ou 4, si on a fait 2 côté avec le même nombre de cases
			if (_c % 2 == 0) then {

				_l = _l + 1;
			};

			/*********
			 conditions pour les 2 premiers coudes qui ne respecent pas le reste du schéma
			 *************/
			if (_d == 0 && _c == 1) then {
				_l = 0;
			};

			if (_d == 0 && _c == 2) then {
				_l = 1;
			};

			/*********
			 *************/


			if (_c == 4) then {
				_d = _d + 1;
				_c = 1;
			} else {
				_c = _c + 1;
			};


			_add = [_dir select _c, _dir select (_c + 1), 0];

		} else {
			_i = _i + 1;
		};

		_pos = _pos vectorAdd _add;

	};



	SP_var_surfacePainter_mutex = true;