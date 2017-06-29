/*
	Mouse move for Edge mode.
	This function will run everytime the mouse move.
*/

#include "..\defines.hpp"

// if there is at least 1 segment in the ligne array
// (if we triggered the mouse down event handler)
if (SP_var_primaryMouseButton && {count SP_var_edge_line > 0}) then {
	// if terrain detection mode
	if (SP_var_edge_mode in ["CLIFF", "HIGHER", "LOWER"]) then {
		private _distance = SP_var_edge_anchor distance SP_var_mouseWorldPosition;

		if (_distance > SP_var_circle_circleRadius) then {
			private _dir = [SP_var_edge_anchor, SP_var_mouseWorldPosition] call BIS_fnc_dirTo;

			SP_var_edge_line pushBack ([SP_var_mouseWorldPosition, SP_var_circle_circleRadius, SP_var_edge_mode, _dir] call SP_fnc_edge_findEdge);

			// define the new position of the anchor
			SP_var_edge_anchor = SP_var_mouseWorldPosition;
		};

	// if drawn mode (default)
	} else {
		private _distance = (SP_var_edge_line select ((count SP_var_edge_line) - 1)) distance SP_var_mouseWorldPosition;

		if (_distance > SP_var_circle_circleRadius) then {
			SP_var_edge_line pushBack (SP_var_mouseWorldPosition vectorAdd [0, 0, LINE_VERTICAL_OFFSET]);
		};
	};
};
