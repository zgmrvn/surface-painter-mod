#include "\x\surface_painter\addons\sp_core\idcs.hpp"
#include "..\idcs.hpp"
#include "\x\surface_painter\addons\sp_core\sizes.hpp"
#include "..\sizes.hpp"

SP_var_pool_pool = [];
SP_var_pool_finalPool = [];

SP_var_pool_poolControls = [];

private _dialog					= findDisplay SP_SURFACE_PAINTER_IDD;
private _poolPanelCtrlGroup 	= _dialog displayCtrl SP_SURFACE_PAINTER_POOL_PANEL_CTRL_GROUP;
private _poolEnterEventCtrl		= _poolPanelCtrlGroup controlsGroupCtrl SP_SURFACE_PAINTER_POOL_EVENT_ENTER_CTRL;
private _poolExitEventCtrl		= _dialog displayCtrl SP_SURFACE_PAINTER_POOL_EVENT_EXIT_CTRL;
private _poolSearchField		= _dialog displayCtrl SP_SURFACE_PAINTER_POOL_SEARCH_FIELD;
private _poolSearchResult		= _dialog displayCtrl SP_SURFACE_PAINTER_POOL_SEARCH_RESULT_LIST;

// hide the exit event control
ctrlShow [SP_SURFACE_PAINTER_POOL_EVENT_EXIT_CTRL, false];

// open enter panel
_poolEnterEventCtrl ctrlAddEventHandler ["MouseEnter", {
	ctrlShow [SP_SURFACE_PAINTER_POOL_EVENT_ENTER_CTRL, false];
	ctrlShow [SP_SURFACE_PAINTER_POOL_EVENT_EXIT_CTRL, true];

	_dialog				= findDisplay SP_SURFACE_PAINTER_IDD;
	_poolPanelCtrlGroup = _dialog displayCtrl SP_SURFACE_PAINTER_POOL_PANEL_CTRL_GROUP;
	_poolBackground		= _dialog displayCtrl SP_SURFACE_PAINTER_POOL_BACKGROUND;

	_poolPanelCtrlGroup ctrlSetPosition [safeZoneX + safeZoneW * SP_POOL_UNFOLDED_X, safeZoneY, safeZoneW * SP_UNFOLDED_W, safeZoneH];
	_poolBackground ctrlSetPosition [safeZoneX + safeZoneW * SP_POOL_UNFOLDED_X, safeZoneY, safeZoneW * SP_UNFOLDED_W, safeZoneH];
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
	_poolPanelCtrlGroup ctrlCommit 0.1;
	_poolBackground ctrlCommit 0.1;
}];


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

_poolSearchResult ctrlAddEventHandler ["LBDblClick", {
	_dialog		= findDisplay SP_SURFACE_PAINTER_IDD;
	_poolList 	= _dialog displayCtrl SP_SURFACE_PAINTER_POOL_LIST;

	_data = (_this select 0) lbData (_this select 1);

	// if this object is not already in the pool
	if (([SP_var_pool_pool, _data] call BIS_fnc_findInPairs) == -1) then {
		_y = count SP_var_pool_pool;

		// pool entry controls group
		_idc = (count SP_var_pool_poolControls) + 1;
		_poolEntry = _dialog ctrlCreate ["RscControlsGroup", _idc, _poolList];
		_poolEntry ctrlSetPosition [0, safeZoneH * (count SP_var_pool_poolControls) * (SP_POOL_ENTRY_H + SP_POOL_ENTRY_M), safeZoneW * SP_POOL_CONTENT_W, safeZoneH * SP_POOL_ENTRY_H];
		_poolEntry ctrlCommit 0;
		SP_var_pool_poolControls pushBack _idc;

		_classname = _dialog ctrlCreate ["RscText", 9955, _poolEntry];
		_classname ctrlSetPosition [0, 0, safeZoneW * SP_POOL_ENTRY_TEXT * SP_POOL_CONTENT_W, safeZoneH * SP_POOL_ENTRY_H];
		_classname ctrlSetBackgroundColor SP_POOL_ENTRY_TEXT_BACKGROUND;
		_classname ctrlCommit 0;
		_classname ctrlSetText _data;

		_probability = _dialog ctrlCreate ["RscEdit", -1, _poolEntry];
		_probability ctrlSetPosition [safeZoneW * SP_POOL_ENTRY_TEXT * SP_POOL_CONTENT_W, 0, safeZoneW * SP_POOL_ENTRY_PROBABILITY * SP_POOL_CONTENT_W, safeZoneH * SP_POOL_ENTRY_H];
		_probability ctrlSetBackgroundColor [0, 0, 0, 1];
		_probability ctrlCommit 0;
		_probability ctrlSetText "1";

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

				_control ctrlSetText (str _after);

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
}];

