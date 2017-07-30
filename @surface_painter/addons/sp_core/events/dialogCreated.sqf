// every modes controls so the color can be changed on mode selection
SP_var_modes = [];

// load modes list
_modes = (configFile >> "CfgSurfacePainter" >> "Modules") call BIS_fnc_getCfgSubClasses;

{
	private _modeEntry = _dialog ctrlCreate ["RscStructuredText", -1, _modeslist];
	SP_var_modes pushBack _modeEntry;
	_modeEntry ctrlSetPosition [0, safeZoneH * SP_MODES_H * _forEachIndex, safeZoneW * SP_MODES_W, safeZoneH * SP_MODES_H];
	_modeEntry ctrlCommit 0;
	_modeEntry ctrlSetStructuredText (parseText format ["<t size='0'>%1:</t><t size='0.32'>&#160;</t><img image='%2' size='1' shadow='0' />", _x, getText (configFile >> "CfgSurfacePainter" >> "Modules" >> _x >> "icon")]);

	if (_x == SP_var_mode) then {
		_modeEntry ctrlSetBackgroundColor [0, 0, 0, 1];
	};

	// create options control group
	private _optionCtrlGroup = _dialog ctrlCreate ["RscControlsGroup", getNumber (configFile >> "CfgSurfacePainter" >> "Modules" >> _x >> "idc"), _leftPanelCtrlGroup];
	_optionCtrlGroup ctrlSetPosition [safeZoneW * SP_MODES_W, 0, safeZoneW * SP_OPTIONS_W, safeZoneH];
	_optionCtrlGroup ctrlCommit 0;

	_modeEntry ctrlAddEventHandler ["MouseButtonDown", {
		private _control = _this select 0;

		{
			_x ctrlSetBackgroundColor [0, 0, 0, 0];
		} forEach SP_var_modes;

		_control ctrlSetBackgroundColor [0, 0, 0, 1];

		private _mode = ctrlText _control;
		_mode = ([_mode, ":"] call BIS_fnc_splitString) select 0;

		if (_mode != SP_var_mode) then {

			_oldTools = getArray (configFile >> "CfgSurfacePainter" >> "Modules" >> SP_var_mode >> "tools");
			_newTools = getArray (configFile >> "CfgSurfacePainter" >> "Modules" >> _mode >> "tools");
			_toolsToDesactivate = [];
			_toolsToActivate = [];

			// find tools to desactivate
			{
				if !(_x in _newTools) then {
					_toolsToDesactivate pushBack _x;
				};
			} forEach _oldTools;

			// find tools to activate
			{
				if !(_x in _oldTools) then {
					_toolsToActivate pushBack _x;
				};
			} forEach _newTools;

			// desactivating tools that are not used by the next mode
			{
				if (isClass (configFile >> "CfgSurfacePainter" >> "Tools" >> _x >> "Events" >> "OnDesactivate")) then {
					_function = getText (configFile >> "CfgSurfacePainter" >> "Tools" >> _x >> "Events" >> "OnDesactivate" >> "function");
					call compile (format ["call %1", _function]);
				};
			} forEach _toolsToDesactivate;

			// desactivate old mode
			if (isClass (configFile >> "CfgSurfacePainter" >> "Modules" >> SP_var_mode >> "Events" >> "OnDesactivate")) then {
				_function = getText (configFile >> "CfgSurfacePainter" >> "Modules" >> SP_var_mode >> "Events" >> "OnDesactivate" >> "function");
				call compile (format ["call %1", _function]);
			};

			// hide old options control group
			ctrlShow [getNumber (configFile >> "CfgSurfacePainter" >> "Modules" >> SP_var_mode >> "idc"), false];

			// active new mode
			SP_var_mode = _mode;

			// activate corresponding tools
			{
				if (isClass (configFile >> "CfgSurfacePainter" >> "Tools" >> _x >> "Events" >> "OnActivate")) then {
					_function = getText (configFile >> "CfgSurfacePainter" >> "Tools" >> _x >> "Events" >> "OnActivate" >> "function");
					call compile (format ["call %1", _function]);
				};
			} forEach _toolsToActivate;

			if (isClass (configFile >> "CfgSurfacePainter" >> "Modules" >> SP_var_mode >> "Events" >> "OnActivate")) then {
				_function = getText (configFile >> "CfgSurfacePainter" >> "Modules" >> SP_var_mode >> "Events" >> "OnActivate" >> "function");
				call compile (format ["call %1", _function]);
			};

			// show correct options control group
			ctrlShow [getNumber (configFile >> "CfgSurfacePainter" >> "Modules" >> SP_var_mode >> "idc"), true];

			// retrieve focus on main control
			_dialog		= findDisplay SP_SURFACE_PAINTER_IDD;
			_eventCtrl	= _dialog displayCtrl SP_SURFACE_PAINTER_EVENT_CTRL;
			ctrlSetFocus _eventCtrl;
		};

	}];
} forEach _modes;
