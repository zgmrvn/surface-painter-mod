#include "\x\surface_painter\addons\sp_core\idcs.hpp"
#include "..\idcs.hpp"
#include "\x\surface_painter\addons\sp_core\sizes.hpp"
#include "..\sizes.hpp"

disableSerialization;

_dialog		= findDisplay SP_SURFACE_PAINTER_IDD;
_poolList 	= _dialog displayCtrl SP_SURFACE_PAINTER_POOL_LIST;

params ["_newPoolEntry", "_classname"];

_count = count SP_var_pool_pool; // we need it to correctly place and resize controls

// create new pool entry
//_newPoolEntry = _dialog ctrlCreate ["ObjectPoolEntry", SP_var_pool_uniqueIDC, _poolList];
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
_newPoolEntry ctrlSetFade 0;
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
_settingsCtrl		= _newPoolEntry controlsGroupCtrl ENTRY_SETTINGS;

_probabilityCtrl		= _settingsCtrl controlsGroupCtrl ENTRY_PROBABILITY;
_probabilityEditCtrl	= _probabilityCtrl controlsGroupCtrl ENTRY_PROBABILITY_EDIT;

_zOffsetCtrl		= _settingsCtrl controlsGroupCtrl ENTRY_Z_OFFSET;
_zOffsetEditCtrl	= _zOffsetCtrl controlsGroupCtrl ENTRY_Z_OFFSET_EDIT;

_scaleCtrl			= _settingsCtrl controlsGroupCtrl ENTRY_SCALE;
_scaleMinEditCtrl	= _scaleCtrl controlsGroupCtrl ENTRY_SCALE_EDIT_MIN;
_scaleMaxEditCtrl	= _scaleCtrl controlsGroupCtrl ENTRY_SCALE_EDIT_MAX;

_followTerrainCtrl			= _settingsCtrl controlsGroupCtrl ENTRY_FOLLOW_TERRAIN;
_followTerrainCheckBoxCtrl	= _followTerrainCtrl controlsGroupCtrl ENTRY_FOLLOW_TERRAIN_CHECKBOX;

// set sub controls
_editorPreview = getText (configfile >> "CfgVehicles" >> _classname >> "editorPreview");
if (_editorPreview != "") then {
	_pictureCtrl ctrlSetText _editorPreview;
};
_displayNameCtrl ctrlSetText getText (configFile >> "CfgVehicles" >> _classname >> "displayName");
_classNameCtrl ctrlSetText _classname;

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

/**********************
***** probability *****
**********************/
_probabilityEditCtrl ctrlAddEventHandler ["MouseZChanged", {
	_control = _this select 0;
	_probability = ctrlParentControlsGroup _control;
	_settings = ctrlParentControlsGroup _probability;
	_entry = ctrlParentControlsGroup _settings;
	_classname = _entry controlsGroupCtrl ENTRY_CLASS_NAME;
	_data = ctrlText _classname;

	_mouseWheel	= [-1, 1] select ((_this select 1) > 0);
	_before	= parseNumber (ctrlText _control);
	_after = _before + _mouseWheel * 0.1;
	_after = (_after min 1) max 0;

	if (_after != _before) then {
		[[SP_var_pool_pool, _data] call BIS_fnc_getFromPairs, "probability", _after] call BIS_fnc_setToPairs;
		SP_var_pool_finalPool = SP_var_pool_pool call SP_fnc_pool_generatePool;

		_control ctrlSetText (_after toFixed 1);

		// then exec probability event
		if (isClass (configFile >> "CfgSurfacePainter" >> "Modules" >> SP_var_mode >> "Events" >> "OnPoolEntryProbabilityChange")) then {
			_function = getText (configFile >> "CfgSurfacePainter" >> "Modules" >> SP_var_mode >> "Events" >> "OnPoolEntryProbabilityChange" >> "function");
			call compile (format ["call %1", _function]);
		};
	};
}];

/*******************
***** z offset *****
*******************/
_zOffsetEditCtrl ctrlAddEventHandler ["MouseZChanged", {
	_control = _this select 0;
	_zOffset = ctrlParentControlsGroup _control;
	_settings = ctrlParentControlsGroup _zOffset;
	_entry = ctrlParentControlsGroup _settings;
	_classname = _entry controlsGroupCtrl ENTRY_CLASS_NAME;
	_data = ctrlText _classname;

	_mouseWheel	= [-1, 1] select ((_this select 1) > 0);
	_before	= parseNumber (ctrlText _control);
	_after = _before + _mouseWheel * 0.1;
	_after = (_after min 10) max -10;

	if (_after != _before) then {
		[[SP_var_pool_pool, _data] call BIS_fnc_getFromPairs, "zOffset", _after] call BIS_fnc_setToPairs;

		_control ctrlSetText (_after toFixed 1);

		// then exec z offset event
		if (isClass (configFile >> "CfgSurfacePainter" >> "Modules" >> SP_var_mode >> "Events" >> "OnPoolEntryZOffsetChange")) then {
			_function = getText (configFile >> "CfgSurfacePainter" >> "Modules" >> SP_var_mode >> "Events" >> "OnPoolEntryZOffsetChange" >> "function");
			call compile (format ["call %1", _function]);
		};
	};
}];

/****************
***** scale *****
****************/
_scaleMinEditCtrl ctrlAddEventHandler ["MouseZChanged", {
	_control = _this select 0;
	_scale = ctrlParentControlsGroup _control;
	_settings = ctrlParentControlsGroup _scale;
	_entry = ctrlParentControlsGroup _settings;
	_classname = _entry controlsGroupCtrl ENTRY_CLASS_NAME;

	_data = ctrlText _classname;
	_scaleMax = _scale controlsGroupCtrl ENTRY_SCALE_EDIT_MAX;

	_mouseWheel	= [-1, 1] select ((_this select 1) > 0);
	_before	= parseNumber (ctrlText _control);
	_after = _before + _mouseWheel * 0.1;
	_after = (_after min 2) max 0;

	if (_after != _before && {parseNumber (_after toFixed 1) <= (parseNumber ctrlText _scaleMax)}) then {
		[[SP_var_pool_pool, _data] call BIS_fnc_getFromPairs, "scaleMin", _after] call BIS_fnc_setToPairs;

		_control ctrlSetText (_after toFixed 1);

		// then exec scale min event
		if (isClass (configFile >> "CfgSurfacePainter" >> "Modules" >> SP_var_mode >> "Events" >> "OnPoolEntryScaleMinChange")) then {
			_function = getText (configFile >> "CfgSurfacePainter" >> "Modules" >> SP_var_mode >> "Events" >> "OnPoolEntryScaleMinChange" >> "function");
			call compile (format ["call %1", _function]);
		};
	};
}];

_scaleMaxEditCtrl ctrlAddEventHandler ["MouseZChanged", {
	_control = _this select 0;
	_scale = ctrlParentControlsGroup _control;
	_settings = ctrlParentControlsGroup _scale;
	_entry = ctrlParentControlsGroup _settings;
	_classname = _entry controlsGroupCtrl ENTRY_CLASS_NAME;

	_data = ctrlText _classname;
	_scaleMin = _scale controlsGroupCtrl ENTRY_SCALE_EDIT_MIN;

	_mouseWheel	= [-1, 1] select ((_this select 1) > 0);
	_before	= parseNumber (ctrlText _control);
	_after = _before + _mouseWheel * 0.1;
	_after = (_after min 2) max 0;

	if (_after != _before && {parseNumber (_after toFixed 1) >= (parseNumber ctrlText _scaleMin)}) then {
		[[SP_var_pool_pool, _data] call BIS_fnc_getFromPairs, "scaleMax", _after] call BIS_fnc_setToPairs;

		_control ctrlSetText (_after toFixed 1);

		// then exec CHANGE event
		if (isClass (configFile >> "CfgSurfacePainter" >> "Modules" >> SP_var_mode >> "Events" >> "OnPoolEntryScaleMaxChange")) then {
			_function = getText (configFile >> "CfgSurfacePainter" >> "Modules" >> SP_var_mode >> "Events" >> "OnPoolEntryScaleMaxChange" >> "function");
			call compile (format ["call %1", _function]);
		};
	};
}];

/*************************
***** follow terrain *****
*************************/
_followTerrainCheckBoxCtrl ctrlAddEventHandler ["CheckedChanged", {
	_control = _this select 0;
	_followTerrain = ctrlParentControlsGroup _control;
	_settings = ctrlParentControlsGroup _followTerrain;
	_entry = ctrlParentControlsGroup _settings;
	_classname = _entry controlsGroupCtrl ENTRY_CLASS_NAME;
	_data = ctrlText _classname;
	_value = (_this select 1) == 1;

	[[SP_var_pool_pool, _data] call BIS_fnc_getFromPairs, "followTerrain", _value] call BIS_fnc_setToPairs;
	_control cbSetChecked _value;

	// then exec follow terrain event
	if (isClass (configFile >> "CfgSurfacePainter" >> "Modules" >> SP_var_mode >> "Events" >> "OnPoolEntryFollowTerrainChange")) then {
		_function = getText (configFile >> "CfgSurfacePainter" >> "Modules" >> SP_var_mode >> "Events" >> "OnPoolEntryFollowTerrainChange" >> "function");
		call compile (format ["call %1", _function]);
	};
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
