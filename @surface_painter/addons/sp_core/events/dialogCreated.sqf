#define MODULES configFile >> "CfgSurfacePainter" >> "Modules"

// every modes controls so the color can be changed on mode selection
SP_var_modes = [];

// sort modules by priority
private _modes = "true" configClasses (MODULES);
_modes = _modes apply {configName _x};
_modes = _modes apply {[getNumber (configFile >> "CfgSurfacePainter" >> "Modules" >> _x >> "priority"), _x]};
_modes sort false;
_modes = _modes apply {_x select 1};

// load modes list
private _extraCount = 0;

{
	private _mode = _x;

	private _isExtra = getNumber (configFile >> "CfgSurfacePainter" >> "Modules" >> _x >> "extra") == 1;

	private _modeEntry = _dialog ctrlCreate ["ModeButton", -1, _modeslist];
	SP_var_modes pushBack _modeEntry;

	if (_isExtra) then {
		_extraCount = _extraCount + 1;
		_modeEntry ctrlSetPosition [0, safeZoneH - safeZoneH * SP_MODES_H * _extraCount, safeZoneW * SP_MODES_W, safeZoneH * SP_MODES_H];
	} else {
		_modeEntry ctrlSetPosition [0, safeZoneH * SP_MODES_H * (_forEachIndex - _extraCount), safeZoneW * SP_MODES_W, safeZoneH * SP_MODES_H];
	};

	_modeEntry ctrlCommit 0;

	// extract sub controls
	private _backgroundCtrl = _modeEntry controlsGroupCtrl 3;
	private _pictureCtrl = _modeEntry controlsGroupCtrl 4;
	private _lbCtrl = _modeEntry controlsGroupCtrl 5;

	_pictureCtrl ctrlSetText (getText (configFile >> "CfgSurfacePainter" >> "Modules" >> _x >> "icon"));

	_backgroundCtrl ctrlSetText _x;

	if (_mode == SP_var_mode) then {
		_backgroundCtrl ctrlSetBackgroundColor [0, 0, 0, 1];
	};

	// create options control group
	private _optionsCtrlGroup = _dialog ctrlCreate ["RscControlsGroup", getNumber (configFile >> "CfgSurfacePainter" >> "Modules" >> _x >> "idc"), _leftPanelCtrlGroup];
	_optionsCtrlGroup ctrlSetPosition [safeZoneW * SP_MODES_W, 0, safeZoneW * SP_OPTIONS_W, safeZoneH];
	_optionsCtrlGroup ctrlCommit 0;







	// create options
	private _varName = format ["SP_var_%1_controls", toLower _mode];
	missionNamespace setVariable [_varName, []];

	private _options = (MODULES >> _mode >> "Options") call BIS_fnc_getCfgSubClasses;

	private _prev = objNull;

	// cycle throught options
	{
		private _classname = _x;

		private _rsc = getText (MODULES >> _mode >> "Options" >> _classname >> "rsc");

		private _optionCtrlGroup = _dialog ctrlCreate [_rsc, -1, _optionsCtrlGroup];

		if (isNull _prev) then {
			private _position = ctrlPosition _optionCtrlGroup;

			_optionCtrlGroup ctrlSetPosition [
				safeZoneW * SP_MARGIN_X,
				safeZoneH * SP_MARGIN_Y,
				safeZoneW * SP_OPTIONS_CONTENT_W,
				_position select 3
			];
		} else {
			private _positionPrevious = ctrlPosition _prev;
			private _positionCurrent = ctrlPosition _optionCtrlGroup;

			// custom option height
			_height = getNumber (MODULES >> _mode >> "Options" >> _classname >> "height");

			if (_height != 0) then {
				private _values = (MODULES >> _mode >> "Options" >> _classname >> "values") call BIS_fnc_getCfgSubClasses;

				{
					private _idc = getNumber (MODULES >> _mode >> "Options" >> _classname >> "values" >> _x >> "idc");
					private _ctrl = _optionCtrlGroup controlsGroupCtrl _idc;
					private _position = ctrlPosition _ctrl;

					_ctrl ctrlSetPosition [
						_position select 0,
						_position select 1,
						_position select 2,
						_height
					];

					_ctrl ctrlCommit 0;
				} forEach _values;
			} else {
				_height = _positionCurrent select 3;
			};

			// margin
			private _margin = getNumber (MODULES >> _mode >> "Options" >> _classname >> "margin");

			_optionCtrlGroup ctrlSetPosition [
				safeZoneW * SP_MARGIN_X,
				(_positionPrevious select 1) + (_positionPrevious select 3) + safezoneH * _margin,
				safeZoneW * SP_OPTIONS_CONTENT_W,
				_height
			];
		};

		_optionCtrlGroup ctrlCommit 0;

		private _values = (MODULES >> _mode >> "Options" >> _classname >> "values") call BIS_fnc_getCfgSubClasses;

		{
			private _idc	= getNumber (MODULES >> _mode >> "Options" >> _classname >> "values" >> _x >> "idc");
			private _type 	= getText (MODULES >> _mode >> "Options" >> _classname >> "values" >> _x >> "typeName");

			private _value = switch (true) do {
				case (_type == "STRING"): {getText (MODULES >> _mode >> "Options" >> _classname >> "values" >> _x >> "value")};
				case (_type == "NUMBER"): {getNumber (MODULES >> _mode >> "Options" >> _classname >> "values" >> _x >> "value")};
				case (_type == "LIST"): {getText (MODULES >> _mode >> "Options" >> _classname >> "values" >> _x >> "value")};
				case (_type == "BOOL"): {getNumber (MODULES >> _mode >> "Options" >> _classname >> "values" >> _x >> "value")};
			};

			private _childControl = _optionCtrlGroup controlsGroupCtrl _idc;

			private _expose = (getNumber (MODULES >> _mode >> "Options" >> _classname >> "expose")) == 1;

			if (_idc == 3 && {_expose}) then {
				(missionNamespace getVariable _varName) pushBack [_classname, _childControl];
			};

			switch (_type) do {
				case "STRING": {_childControl ctrlSetText _value};
				case "NUMBER": {_childControl ctrlSetText str _value};
				case "BOOL": {_childControl cbSetChecked (_value > 0)};
				case "LIST": {_childControl lbAdd _value};
			};
		} forEach _values;

		_prev = _optionCtrlGroup;
	} forEach _options;









	_lbCtrl ctrlAddEventHandler ["MouseButtonDown", {
		private _lbCtrl = _this select 0;

		// extract sub controls
		private _modeButton = ctrlParentControlsGroup _lbCtrl;
		private _backgroundCtrl = _modeButton controlsGroupCtrl 3;
		private _pictureCtrl = _modeButton controlsGroupCtrl 4;

		{
			(_x controlsGroupCtrl 3) ctrlSetBackgroundColor [0, 0, 0, 0];
		} forEach SP_var_modes;

		_backgroundCtrl ctrlSetBackgroundColor [0, 0, 0, 1];

		private _mode = ctrlText _backgroundCtrl;

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
