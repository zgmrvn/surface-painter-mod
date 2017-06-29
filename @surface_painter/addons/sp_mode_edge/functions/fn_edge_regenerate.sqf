// if the temp array contains objects, delete them and regen
if ((count SP_var_edge_tempObjects) > 0) then {
	{
		deleteVehicle _x;
	} forEach SP_var_edge_tempObjects;

	SP_var_edge_tempObjects = [SP_var_edge_line, SP_var_edge_interval, SP_var_edge_spread, SP_var_pool_finalPool] call SP_fnc_edge_generate;
};
