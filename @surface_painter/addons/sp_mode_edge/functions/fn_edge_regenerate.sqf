/*
	Function: SP_fnc_edge_regenerate

	Description:
		Regenerate objects, this function is a wrapper for a pre-configured call of SP_fnc_edge_generate.

	Parameters:
		none

	Example:
		(begin example)
		call SP_fnc_edge_regenerate;
		(end)

	Returns:
		nothing

	Author:
		zgmrvn
*/

// if the temp array contains objects, delete them and regen
if ((count SP_var_edge_tempObjects) > 0) then {
	{
		deleteVehicle _x;
	} forEach SP_var_edge_tempObjects;

	SP_var_edge_tempObjects = [SP_var_edge_line, SP_var_edge_interval, SP_var_edge_spread, SP_var_pool_finalPool] call SP_fnc_edge_generate;

	if ((count SP_var_pool_finalPool) == 0) then {
		["NOK", localize "STR_SP_CORE_NOTIFICATION_OBJECT_POOL_EMPTY"] spawn SP_fnc_core_pushNotification;
	};
};
