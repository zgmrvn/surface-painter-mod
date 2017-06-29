/*
	Mouse down for Edge mode.
	This function will run everytime mouse button is pressed.
*/

#include "..\defines.hpp"

// save temp objects and reset temporary objects array
if ((count SP_var_edge_tempObjects) > 0) then {
	SP_var_createdObjects append SP_var_edge_tempObjects;
	SP_var_edge_tempObjects = [];
};

if (SP_var_edge_mode in ["LOWER", "HIGHER", "CLIFF"]) then {
	SP_var_edge_anchor = SP_var_mouseWorldPosition;

	SP_var_edge_line = [([SP_var_mouseWorldPosition, SP_var_circle_circleRadius, format ["%1_FIRST", SP_var_edge_mode]] call SP_fnc_edge_findEdge) vectorAdd [0, 0, LINE_VERTICAL_OFFSET]];
} else {
	SP_var_edge_line = [SP_var_mouseWorldPosition vectorAdd [0, 0, LINE_VERTICAL_OFFSET]];
};
