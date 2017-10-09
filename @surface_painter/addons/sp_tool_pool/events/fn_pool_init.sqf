/*
	Pool - Init
	This function runs when Surface Painter inteface is open.
*/

#include "\x\surface_painter\addons\sp_core\idcs.hpp"
#include "..\idcs.hpp"
#include "\x\surface_painter\addons\sp_core\sizes.hpp"
#include "..\sizes.hpp"

if (isNil "SP_var_pool_pool" && {isNil "SP_var_pool_finalPool"}) then {
	SP_var_pool_pool		= []; // represents the objects in the pool and their configuration
	SP_var_pool_finalPool	= [];
};

SP_var_pool_uniqueIDC	= ENTRY_IDC_BEGINNING;

SP_var_pool_poolControls = [];

private _dialog					= findDisplay SP_SURFACE_PAINTER_IDD;
private _poolPanelCtrlGroup 	= _dialog displayCtrl SP_SURFACE_PAINTER_POOL_PANEL_CTRL_GROUP;
private _poolEnterEventCtrl		= _poolPanelCtrlGroup controlsGroupCtrl SP_SURFACE_PAINTER_POOL_EVENT_ENTER_CTRL;
private _poolExitEventCtrl		= _dialog displayCtrl SP_SURFACE_PAINTER_POOL_EVENT_EXIT_CTRL;
private _poolSearchField		= _dialog displayCtrl SP_SURFACE_PAINTER_POOL_SEARCH_FIELD;
private _poolSearchResult		= _dialog displayCtrl SP_SURFACE_PAINTER_POOL_SEARCH_RESULT_LIST;
private _poolList				= _dialog displayCtrl SP_SURFACE_PAINTER_POOL_LIST;

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
	_poolSearchResult	= _dialog displayCtrl SP_SURFACE_PAINTER_POOL_SEARCH_RESULT_LIST;

	_classes = format ["['%1', getText (_x >> 'displayName')] call BIS_fnc_inString", ctrlText _control] configClasses (configFile >> "CfgVehicles");

	lbClear _poolSearchResult;

	{
		_poolSearchResult lbAdd (getText (_x >> "displayName"));
		_poolSearchResult lbSetData [_forEachIndex, configName _x];
	} forEach _classes;
}];

/*******************************
***** restore pool entries *****
*******************************/
{
	_x params ["_classname", "_settings"];

	// create control
	_newPoolEntry = _dialog ctrlCreate ["ObjectPoolEntry", SP_var_pool_uniqueIDC, _poolList];

	// apply settings


	// apply events and set list
	_handle = [_newPoolEntry, _classname] execVM "x\surface_painter\addons\sp_tool_pool\scripts\createPoolEntry.sqf";
	waitUntil {scriptDone _handle};

	// extract sub controls of the new entry
	// and add event handlers
	_settingsCtrl = _newPoolEntry controlsGroupCtrl ENTRY_SETTINGS;

	_probabilityCtrl		= _settingsCtrl controlsGroupCtrl ENTRY_PROBABILITY;
	_probabilityEditCtrl	= _probabilityCtrl controlsGroupCtrl ENTRY_PROBABILITY_EDIT;
	_probabilityEditCtrl ctrlSetText (([[SP_var_pool_pool, _classname] call BIS_fnc_getFromPairs, "probability"] call BIS_fnc_getFromPairs) toFixed 1);

	_zOffsetCtrl		= _settingsCtrl controlsGroupCtrl ENTRY_Z_OFFSET;
	_zOffsetEditCtrl	= _zOffsetCtrl controlsGroupCtrl ENTRY_Z_OFFSET_EDIT;
	_zOffsetEditCtrl ctrlSetText (([[SP_var_pool_pool, _classname] call BIS_fnc_getFromPairs, "zOffset"] call BIS_fnc_getFromPairs) toFixed 1);

	_scaleCtrl			= _settingsCtrl controlsGroupCtrl ENTRY_SCALE;
	_scaleMinEditCtrl	= _scaleCtrl controlsGroupCtrl ENTRY_SCALE_EDIT_MIN;
	_scaleMaxEditCtrl	= _scaleCtrl controlsGroupCtrl ENTRY_SCALE_EDIT_MAX;
	_scaleMinEditCtrl ctrlSetText (([[SP_var_pool_pool, _classname] call BIS_fnc_getFromPairs, "scaleMin"] call BIS_fnc_getFromPairs) toFixed 1);
	_scaleMaxEditCtrl ctrlSetText (([[SP_var_pool_pool, _classname] call BIS_fnc_getFromPairs, "scaleMax"] call BIS_fnc_getFromPairs) toFixed 1);

	_followTerrainCtrl			= _settingsCtrl controlsGroupCtrl ENTRY_FOLLOW_TERRAIN;
	_followTerrainCheckBoxCtrl	= _followTerrainCtrl controlsGroupCtrl ENTRY_FOLLOW_TERRAIN_CHECKBOX;
	_followTerrainCheckBoxCtrl cbSetChecked ([[SP_var_pool_pool, _classname] call BIS_fnc_getFromPairs, "followTerrain"] call BIS_fnc_getFromPairs);
} forEach SP_var_pool_pool;

/*************************
***** add pool entry *****
*************************/
_poolSearchResult ctrlAddEventHandler ["LBDblClick", {
	_classname = (_this select 0) lbData (_this select 1);

	// if this classname isn't in the pool already, we can go futher
	if (([SP_var_pool_pool, _classname] call BIS_fnc_findInPairs) == -1) then {
		_dialog		= findDisplay SP_SURFACE_PAINTER_IDD;
		_poolList	= _dialog displayCtrl SP_SURFACE_PAINTER_POOL_LIST;

		_newPoolEntry = _dialog ctrlCreate ["ObjectPoolEntry", SP_var_pool_uniqueIDC, _poolList];
		[_newPoolEntry, _classname] execVM "x\surface_painter\addons\sp_tool_pool\scripts\createPoolEntry.sqf";

		_followTerrainCheckBoxCtrl = _newPoolEntry controlsGroupCtrl ENTRY_FOLLOW_TERRAIN_CHECKBOX;
		_keepHorizontal = getNumber (configFile >> "CfgVehicles" >> _classname >> "keepHorizontalPlacement");
		_followTerrain = (_keepHorizontal == 0);
		_followTerrainCheckBoxCtrl cbSetChecked _followTerrain;

		// push the new object and its default configuration in the pool
		[SP_var_pool_pool, _classname, [
			["probability", 1],
			["zOffset", 0],
			["scaleMin", 1],
			["scaleMax", 1],
			["followTerrain", _followTerrain]
		]] call BIS_fnc_setToPairs;

	};
}];
