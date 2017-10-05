/*
	Pool - Init
	This function runs when Surface Painter inteface is open.
*/

#include "\x\surface_painter\addons\sp_core\idcs.hpp"
#include "..\idcs.hpp"
#include "\x\surface_painter\addons\sp_core\sizes.hpp"
#include "..\sizes.hpp"

SP_var_pool_pool		= []; // represents the objects in the pool and their configuration
SP_var_pool_finalPool	= [];
SP_var_pool_uniqueIDC	= ENTRY_IDC_BEGINNING;

SP_var_pool_poolControls = [];

private _dialog					= findDisplay SP_SURFACE_PAINTER_IDD;
private _poolPanelCtrlGroup 	= _dialog displayCtrl SP_SURFACE_PAINTER_POOL_PANEL_CTRL_GROUP;
private _poolEnterEventCtrl		= _poolPanelCtrlGroup controlsGroupCtrl SP_SURFACE_PAINTER_POOL_EVENT_ENTER_CTRL;
private _poolExitEventCtrl		= _dialog displayCtrl SP_SURFACE_PAINTER_POOL_EVENT_EXIT_CTRL;
private _poolSearchField		= _dialog displayCtrl SP_SURFACE_PAINTER_POOL_SEARCH_FIELD;
private _poolSearchResult		= _dialog displayCtrl SP_SURFACE_PAINTER_POOL_SEARCH_RESULT_LIST;

// hide the exit event control
ctrlShow [SP_SURFACE_PAINTER_POOL_EVENT_EXIT_CTRL, false];

// open pool panel
_poolEnterEventCtrl ctrlAddEventHandler ["MouseEnter", {
	ctrlShow [SP_SURFACE_PAINTER_POOL_EVENT_ENTER_CTRL, false];
	ctrlShow [SP_SURFACE_PAINTER_POOL_EVENT_EXIT_CTRL, true];

	_dialog				= findDisplay SP_SURFACE_PAINTER_IDD;
	_poolPanelCtrlGroup = _dialog displayCtrl SP_SURFACE_PAINTER_POOL_PANEL_CTRL_GROUP;
	_poolBackground		= _dialog displayCtrl SP_SURFACE_PAINTER_POOL_BACKGROUND;

	_poolPanelCtrlGroup ctrlSetPosition [safeZoneX + safeZoneW * SP_POOL_UNFOLDED_X, safeZoneY, safeZoneW * SP_UNFOLDED_W, safeZoneH];
	_poolBackground ctrlSetPosition [safeZoneX + safeZoneW * SP_POOL_UNFOLDED_X, safeZoneY, safeZoneW * SP_UNFOLDED_W, safeZoneH];
	_poolBackground ctrlSetBackgroundColor [0, 0, 0, 1];
	_poolBackground ctrlSetFade 0;
	_poolPanelCtrlGroup ctrlSetFade 0;
	_poolPanelCtrlGroup ctrlCommit 0.1;
	_poolBackground ctrlCommit 0.1;
}];

// close pool panel
_poolExitEventCtrl ctrlAddEventHandler ["MouseEnter", {

	ctrlShow [SP_SURFACE_PAINTER_POOL_EVENT_EXIT_CTRL, false];
	ctrlShow [SP_SURFACE_PAINTER_POOL_EVENT_ENTER_CTRL, true];

	_dialog				= findDisplay SP_SURFACE_PAINTER_IDD;
	_eventCtrl			= _dialog displayCtrl SP_SURFACE_PAINTER_EVENT_CTRL;
	_poolPanelCtrlGroup = _dialog displayCtrl SP_SURFACE_PAINTER_POOL_PANEL_CTRL_GROUP;
	_poolBackground		= _dialog displayCtrl SP_SURFACE_PAINTER_POOL_BACKGROUND;

	ctrlSetFocus _poolPanelCtrlGroup;
	ctrlSetFocus _eventCtrl;

	_poolPanelCtrlGroup ctrlSetPosition [safeZoneX + safeZoneW * SP_POOL_FOLDED_X, safeZoneY, safeZoneW * SP_FOLDED_W, safeZoneH];
	_poolBackground ctrlSetPosition [safeZoneX + safeZoneW * SP_POOL_FOLDED_X, safeZoneY, safeZoneW * SP_FOLDED_W, safeZoneH];
	_poolBackground ctrlSetBackgroundColor [0.1, 0.1, 0.1, 1];
	_poolBackground ctrlSetFade 0.2;
	_poolPanelCtrlGroup ctrlSetFade 1;
	_poolPanelCtrlGroup ctrlCommit 0.1;
	_poolBackground ctrlCommit 0.1;
}];

/*****************
***** search *****
*****************/
_poolSearchField ctrlAddEventHandler ["KeyUp", {
	_control			= _this select 0;
	_dialog				= findDisplay SP_SURFACE_PAINTER_IDD;
	_poolSearchResult = _dialog displayCtrl SP_SURFACE_PAINTER_POOL_SEARCH_RESULT_LIST;

	_classes = format ["['%1', getText (_x >> 'displayName')] call BIS_fnc_inString", ctrlText _control] configClasses (configFile >> "CfgVehicles");

	lbClear _poolSearchResult;

	{
		_poolSearchResult lbAdd (getText (_x >> "displayName"));
		_poolSearchResult lbSetData [_forEachIndex, configName _x];
	} forEach _classes;
}];

/*************************
***** add pool entry *****
*************************/
_poolSearchResult ctrlAddEventHandler ["LBDblClick", {
	_dialog		= findDisplay SP_SURFACE_PAINTER_IDD;
	_poolList 	= _dialog displayCtrl SP_SURFACE_PAINTER_POOL_LIST;

	// extract classname from selected search list selected item
	_className = (_this select 0) lbData (_this select 1);

	// if this classname isn't in the pool already, we can go futher
	if (([SP_var_pool_pool, _className] call BIS_fnc_findInPairs) == -1) then {
		_count = count SP_var_pool_pool; // we need it to correctly place and resize controls

		// create new pool entry
		_newPoolEntry = _dialog ctrlCreate ["ObjectPoolEntry", SP_var_pool_uniqueIDC, _poolList];
		_newPoolEntryBackground = _newPoolEntry controlsGroupCtrl ENTRY_BACKGROUND;

		// we keep a trace of all existing pool entry controls
		SP_var_pool_poolControls pushBack SP_var_pool_uniqueIDC;

		// then generate a new unique IDC for later
		SP_var_pool_uniqueIDC = SP_var_pool_uniqueIDC + 1;

		// we need to know if there is an open entry
		// to correctly set the position of the new entry
		_hasOpenEntry = 0;

		{
			_currentPoolEntry = _poolList controlsGroupCtrl _x;
			_isOpen = ctrlText (_currentPoolEntry controlsGroupCtrl ENTRY_BACKGROUND) == "1";

			if (_isOpen) exitWith {
				_hasOpenEntry = 1;
			};
		} forEach SP_var_pool_poolControls;

		// set new pool entry position
		_newPoolEntry ctrlSetPosition [
			0,
			safeZoneH * ((SP_POOL_ENTRY_H + SP_POOL_ENTRY_M) * _count + (SP_OPTION_CONTENT_H * 4) * _hasOpenEntry),
			safeZoneW * SP_POOL_CONTENT_W,
			safeZoneH * SP_POOL_ENTRY_H
		];
		_newPoolEntry ctrlCommit 0;
		_newPoolEntryBackground ctrlSetText "1";

		// set entries positions
		{
			_currentPoolEntry = _poolList controlsGroupCtrl _x;
			_currentPoolEntryBackground = _currentPoolEntry controlsGroupCtrl ENTRY_BACKGROUND;
			_currentPoolEntrySettings = _currentPoolEntry controlsGroupCtrl ENTRY_SETTINGS;

			// if the current entry pool is not the one we clicked on
			// we reset its state to 0 (animation will follow)
			if (_currentPoolEntry != _newPoolEntry) then {
				_currentPoolEntryBackground ctrlSetText "0";
			};

			// set pool entry new position
			_currentPoolEntry ctrlSetPosition [
				0,
				safeZoneH * ((SP_POOL_ENTRY_H + SP_POOL_ENTRY_M) * _forEachIndex),
				safeZoneW * SP_POOL_CONTENT_W,
				safeZoneH * (SP_POOL_ENTRY_H + ((SP_OPTION_CONTENT_H * 4) * (parseNumber (ctrlText _currentPoolEntryBackground))))
			];
			_currentPoolEntry ctrlCommit 0.1;

			// settings
			_currentPoolEntrySettings ctrlSetPosition [
				0,
				safeZoneH * SP_POOL_ENTRY_H,
				safeZoneW * SP_POOL_CONTENT_W,
				safeZoneH * ((SP_OPTION_CONTENT_H * 4) * (parseNumber (ctrlText _currentPoolEntryBackground)))
			];
			_currentPoolEntrySettings ctrlSetFade parseNumber !((parseNumber ctrlText _currentPoolEntryBackground) == 1);
			_currentPoolEntrySettings ctrlCommit 0.1;
		} forEach SP_var_pool_poolControls;

		// pool list
		_poolList ctrlSetPosition [
			safeZoneW * SP_MARGIN_X,
			(ctrlPosition _poolList) select 1,
			safeZoneW * SP_POOL_CONTENT_W,
			safeZoneH * ((SP_POOL_ENTRY_H + SP_POOL_ENTRY_M) * ((count SP_var_pool_pool) + 1) + (SP_OPTION_CONTENT_H * 4))
		];
		_poolList ctrlCommit 0.1;

		// extract sub controls of the new entry
		// and add event handlers
		_pictureCtrl		= _newPoolEntry controlsGroupCtrl ENTRY_PICTURE;
		_displayNameCtrl	= _newPoolEntry controlsGroupCtrl ENTRY_DISPLAY_NAME;
		_classNameCtrl		= _newPoolEntry controlsGroupCtrl ENTRY_CLASS_NAME;
		_openCloseCtrl		= _newPoolEntry controlsGroupCtrl ENTRY_OPEN_CLOSE;
		_removeCtrl			= _newPoolEntry controlsGroupCtrl ENTRY_REMOVE;

		// set sub controls
		_editorPreview = getText (configfile >> "CfgVehicles" >> _className >> "editorPreview");
		if (_editorPreview != "") then {
			_pictureCtrl ctrlSetText _editorPreview;
		};
		_displayNameCtrl ctrlSetText getText (configFile >> "CfgVehicles" >> _className >> "displayName");
		_classNameCtrl ctrlSetText _className;

		// then we push the new object and its configuration in the pool
		[SP_var_pool_pool, _className, 1] call BIS_fnc_setToPairs;

		// then we generate the actual pool
		// the array in which tools will randomly pick an item
		SP_var_pool_finalPool = SP_var_pool_pool call SP_fnc_pool_generatePool;

		// then, if the current modules has an "OnPoolEntryAdd" event registered, we execute it
		if (isClass (configFile >> "CfgSurfacePainter" >> "Modules" >> SP_var_mode >> "Events" >> "OnPoolEntryAdd")) then {
			_function = getText (configFile >> "CfgSurfacePainter" >> "Modules" >> SP_var_mode >> "Events" >> "OnPoolEntryAdd" >> "function");
			call compile (format ["call %1", _function]);
		};

		/*********************
		***** open/close *****
		*********************/
		_openCloseCtrl ctrlAddEventHandler ["MouseButtonDown", {
			_dialog					= findDisplay SP_SURFACE_PAINTER_IDD;
			_poolList 				= _dialog displayCtrl SP_SURFACE_PAINTER_POOL_LIST;
			_poolEntry				= ctrlParentControlsGroup (_this select 0);
			_poolEntryBackground	= _poolEntry controlsGroupCtrl ENTRY_BACKGROUND;
			_poolEntrySettings		= _poolEntry controlsGroupCtrl ENTRY_SETTINGS;

			// invert entry state
			_poolEntryBackground ctrlSetText str parseNumber !((parseNumber ctrlText _poolEntryBackground) == 1);

			_PoolEntryIDC = ctrlIDC _poolEntry;

			// set entries position
			{
				_currentPoolEntry = _poolList controlsGroupCtrl _x;
				_currentPoolEntryBackground = _currentPoolEntry controlsGroupCtrl ENTRY_BACKGROUND;
				_currentPoolEntrySettings = _currentPoolEntry controlsGroupCtrl ENTRY_SETTINGS;

				// if the current entry pool is not the one we clicked on
				// we reset its state to 0 (animation will follow)
				if (_x != _PoolEntryIDC) then {
					_currentPoolEntryBackground ctrlSetText "0";
				};

				// set pool entry new position
				_currentPoolEntry ctrlSetPosition [
					0,
					safeZoneH * ((SP_POOL_ENTRY_H + SP_POOL_ENTRY_M) * _forEachIndex + ((SP_OPTION_CONTENT_H * 4) * (parseNumber (_x > _PoolEntryIDC)) * (parseNumber (ctrlText _poolEntryBackground)))),
					safeZoneW * SP_POOL_CONTENT_W,
					safeZoneH * (SP_POOL_ENTRY_H + ((SP_OPTION_CONTENT_H * 4) * (parseNumber (ctrlText _currentPoolEntryBackground))))
				];
				_currentPoolEntry ctrlCommit 0.1;

				// settings
				_currentPoolEntrySettings ctrlSetPosition [
					0,
					safeZoneH * SP_POOL_ENTRY_H,
					safeZoneW * SP_POOL_CONTENT_W,
					safeZoneH * ((SP_OPTION_CONTENT_H * 4) * (parseNumber (ctrlText _currentPoolEntryBackground)))
				];
				_poolEntrySettings ctrlSetFade parseNumber !((parseNumber ctrlText _currentPoolEntryBackground) == 1);
				_currentPoolEntrySettings ctrlCommit 0.1;
			} forEach SP_var_pool_poolControls;

			// pool list
			_poolList ctrlSetPosition [
				safeZoneW * SP_MARGIN_X,
				(ctrlPosition _poolList) select 1,
				safeZoneW * SP_POOL_CONTENT_W,
				safeZoneH * ((SP_POOL_ENTRY_H + SP_POOL_ENTRY_M) * (count SP_var_pool_pool) + ((SP_OPTION_CONTENT_H * 4) * parseNumber (ctrlText _poolEntryBackground)))
			];
			_poolList ctrlCommit 0.1;
		}];

		/*****************
		***** remove *****
		*****************/
		_removeCtrl ctrlAddEventHandler ["ButtonClick", {
			_dialog		= findDisplay SP_SURFACE_PAINTER_IDD;
			_poolList 	= _dialog displayCtrl SP_SURFACE_PAINTER_POOL_LIST;

			_poolEntry		= ctrlParentControlsGroup (_this select 0);
			_poolEntryIDC	= ctrlIDC _poolEntry;
			_classNameCtrl	= _poolEntry controlsGroupCtrl ENTRY_CLASS_NAME;
			_className		= ctrlText _classNameCtrl;

			// delete this entry from all arrays
			SP_var_pool_poolControls deleteAt (SP_var_pool_poolControls find _poolEntryIDC);
			[SP_var_pool_pool, _className] call BIS_fnc_removeFromPairs;
			SP_var_pool_finalPool = SP_var_pool_pool call SP_fnc_pool_generatePool;

			// we need to know if there is an open entry
			// to correctly set the position of the new entry
			_hasOpenEntry = 0;
			_openEntry = 0;

			{
				_currentPoolEntry = _poolList controlsGroupCtrl _x;
				_isOpen = ctrlText (_currentPoolEntry controlsGroupCtrl ENTRY_BACKGROUND) == "1";

				if (_isOpen) exitWith {
					_hasOpenEntry = 1;
					_openEntry = _x;
				};
			} forEach SP_var_pool_poolControls;

			// rearange pool list so there is no space between entries
			{
				_entry = _poolList controlsGroupCtrl _x;
				_entryBackground = _entry controlsGroupCtrl ENTRY_BACKGROUND;

				_entry ctrlSetPosition [
					0,
					safeZoneH * ((SP_POOL_ENTRY_H + SP_POOL_ENTRY_M) * _forEachIndex + ((SP_OPTION_CONTENT_H * 4) * _hasOpenEntry * parseNumber (_x > _openEntry))),
					safeZoneW * SP_POOL_CONTENT_W,
					safeZoneH * (SP_POOL_ENTRY_H + (SP_OPTION_CONTENT_H * 4) * (parseNumber (ctrlText _entryBackground)))
				];
				_entry ctrlCommit 0.1;
			} forEach SP_var_pool_poolControls;

			// resize pool list
			_count = count SP_var_pool_pool;
			_poolList ctrlSetPosition [
				safeZoneW * SP_MARGIN_X,
				(ctrlPosition _poolList) select 1,
				safeZoneW * SP_POOL_CONTENT_W,
				safeZoneH * (SP_POOL_ENTRY_H * _count + SP_POOL_ENTRY_M * (_count - 1) + SP_MARGIN_Y + (SP_OPTION_CONTENT_H * 4) * _hasOpenEntry)
			];
			_poolList ctrlCommit 0.1;

			// then, if the current modules has an "OnPoolEntryDelete" event registered, we execute it
			if (isClass (configFile >> "CfgSurfacePainter" >> "Modules" >> SP_var_mode >> "Events" >> "OnPoolEntryDelete")) then {
				_function = getText (configFile >> "CfgSurfacePainter" >> "Modules" >> SP_var_mode >> "Events" >> "OnPoolEntryDelete" >> "function");
				call compile (format ["call %1", _function]);
			};

			// finally, we delete entry control group
			ctrlDelete _poolEntry;
		}];
	};

	/*
	_dialog		= findDisplay SP_SURFACE_PAINTER_IDD;
	_poolList 	= _dialog displayCtrl SP_SURFACE_PAINTER_POOL_LIST;

	_data = (_this select 0) lbData (_this select 1);

	// if this object is not already in the pool
	if (([SP_var_pool_pool, _data] call BIS_fnc_findInPairs) == -1) then {
		_y = count SP_var_pool_pool;

		// pool entry controls group
		_idc = (count SP_var_pool_poolControls) + 1;
		_poolEntry = _dialog ctrlCreate ["RscControlsGroup", _idc, _poolList];
		_poolEntry ctrlSetPosition [
			0,
			safeZoneH * (count SP_var_pool_poolControls) * (SP_POOL_ENTRY_H + SP_POOL_ENTRY_M),
			safeZoneW * SP_POOL_CONTENT_W,
			safeZoneH * SP_POOL_ENTRY_H
		];
		_poolEntry ctrlCommit 0;
		SP_var_pool_poolControls pushBack _idc;

		_classname = _dialog ctrlCreate ["RscText", 9955, _poolEntry];
		_classname ctrlSetPosition [0, 0, safeZoneW * SP_POOL_ENTRY_TEXT * SP_POOL_CONTENT_W, safeZoneH * SP_POOL_ENTRY_H];
		_classname ctrlSetBackgroundColor [0.1, 0.1, 0.1, 1];
		_classname ctrlCommit 0;
		_classname ctrlSetText _data;

		_probability = _dialog ctrlCreate ["RscEdit", -1, _poolEntry];
		_probability ctrlSetPosition [safeZoneW * SP_POOL_ENTRY_TEXT * SP_POOL_CONTENT_W, 0, safeZoneW * SP_POOL_ENTRY_PROBABILITY * SP_POOL_CONTENT_W, safeZoneH * SP_POOL_ENTRY_H];
		_probability ctrlSetBackgroundColor [0, 0, 0, 1];
		_probability ctrlCommit 0;
		_probability ctrlSetText "1.0";

		_probability ctrlAddEventHandler ["MouseZChanged", {
			_control = _this select 0;
			_parent = ctrlParentControlsGroup _control;

			_data = ctrlText (_parent controlsGroupCtrl 9955);

			_mouseWheel	= [-1, 1] select ((_this select 1) > 0);
			_before	= parseNumber (ctrlText _control);
			_after	= _before + _mouseWheel * 0.1;
			_after = (_after min 1) max 0;

			if (_after != _before) then {
				[SP_var_pool_pool, _data, _after] call BIS_fnc_setToPairs;
				SP_var_pool_finalPool = SP_var_pool_pool call SP_fnc_pool_generatePool;

				_control ctrlSetText (_after toFixed 1);

				// then exec CHANGE event
				if (isClass (configFile >> "CfgSurfacePainter" >> "Modules" >> SP_var_mode >> "Events" >> "OnPoolEntryProbabilityChange")) then {
					_function = getText (configFile >> "CfgSurfacePainter" >> "Modules" >> SP_var_mode >> "Events" >> "OnPoolEntryProbabilityChange" >> "function");
					call compile (format ["call %1", _function]);
				};
			};
		}];

		_delete = _dialog ctrlCreate ["RscButton", -1, _poolEntry];
		_delete ctrlSetPosition [safeZoneW * (SP_POOL_ENTRY_TEXT + SP_POOL_ENTRY_PROBABILITY) * SP_POOL_CONTENT_W, 0, safeZoneW * SP_POOL_ENTRY_DELETE * SP_POOL_CONTENT_W, safeZoneH * SP_POOL_ENTRY_H];
		_delete ctrlCommit 0;
		_delete ctrlSetText "X";

		// when delete button pressed
		_delete ctrlAddEventHandler ["ButtonClick", {
			_entryCtrlGrp		= ctrlParentControlsGroup (_this select 0);
			_entryCtrlGrpIdc	= ctrlIDC _entryCtrlGrp;
			_poolCtrlGrp		= ctrlParentControlsGroup _entryCtrlGrp;
			_data				= ctrlText (_entryCtrlGrp controlsGroupCtrl 9955);

			// delete this entry from all arrays
			SP_var_pool_poolControls deleteAt (SP_var_pool_poolControls find _entryCtrlGrpIdc);
			[SP_var_pool_pool, _data] call BIS_fnc_removeFromPairs;
			SP_var_pool_finalPool = SP_var_pool_pool call SP_fnc_pool_generatePool;

			// rearange list so there is no spaces between entries
			for [{_i = (SP_var_pool_poolControls find _entryCtrlGrpIdc) + 1; _c = count SP_var_pool_poolControls; }, {_i < _c}, {_i = _i + 1}] do {
				_entry = _poolCtrlGrp controlsGroupCtrl (SP_var_pool_poolControls select _i);
				_entry ctrlSetPosition [0, safeZoneH * _i * (SP_POOL_ENTRY_H + SP_POOL_ENTRY_M), safeZoneW * SP_POOL_CONTENT_W, safeZoneH * SP_POOL_ENTRY_H];
				_entry ctrlCommit 0;
			};

			// then exec DELETE event
			if (isClass (configFile >> "CfgSurfacePainter" >> "Modules" >> SP_var_mode >> "Events" >> "OnPoolEntryDelete")) then {
				_function = getText (configFile >> "CfgSurfacePainter" >> "Modules" >> SP_var_mode >> "Events" >> "OnPoolEntryDelete" >> "function");
				call compile (format ["call %1", _function]);
			};

			// delete entry control group
			ctrlDelete _entryCtrlGrp;
		}];

		[SP_var_pool_pool, _data, 1] call BIS_fnc_setToPairs;
		SP_var_pool_finalPool = SP_var_pool_pool call SP_fnc_pool_generatePool;

		// then exec ADD event
		if (isClass (configFile >> "CfgSurfacePainter" >> "Modules" >> SP_var_mode >> "Events" >> "OnPoolEntryAdd")) then {
			_function = getText (configFile >> "CfgSurfacePainter" >> "Modules" >> SP_var_mode >> "Events" >> "OnPoolEntryAdd" >> "function");
			call compile (format ["call %1", _function]);
		};
	};
	*/


}];

