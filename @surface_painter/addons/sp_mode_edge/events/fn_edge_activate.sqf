/*
	Edge activation.
	This function will run everytime you switch on this mode.
*/

// line reset
SP_var_edge_line = [];

// draw line on each frame
["edge", "onEachFrame", {
	// draw the segment between the mouse and the last line segment
	if (SP_var_primaryMouseButton && {count SP_var_edge_line > 0}) then {
		drawLine3D [
			SP_var_edge_line select ((count SP_var_edge_line) - 1),
			SP_var_mouseWorldPosition,
			[1, 1, 1, 1]
		];
	};

	// draw all the segments
	if (count SP_var_edge_line > 1) then {
		for [{_i = (count SP_var_edge_line) - 1}, {_i > 0}, {_i = _i - 1}] do {
			drawLine3D [
				SP_var_edge_line select _i,
				SP_var_edge_line select (_i - 1),
				[1, 1, 1, 1]
			];
		};
	};
}] call BIS_fnc_addStackedEventHandler;
