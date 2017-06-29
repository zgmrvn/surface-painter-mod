/*
	Edge activation.
	This function will run everytime you leave this mode.
*/

// save temp objects and reset temporary objects array
if ((count SP_var_edge_tempObjects) > 0) then {
	SP_var_createdObjects append SP_var_edge_tempObjects;
	SP_var_edge_tempObjects = [];
};

// don't render the line anymore
["edge", "onEachFrame"] call BIS_fnc_removeStackedEventHandler;
