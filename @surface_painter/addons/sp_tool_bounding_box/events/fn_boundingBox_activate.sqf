/*
	Bounding Box - Activation
	This function runs when switching on a mode that uses this tool.
*/

// on each frame, draw bounding boxes
["boundingBox", "onEachFrame", {
	{
		_x params ["", "_params"];
		_params params ["_segments", "_color"];

		{
			drawLine3D [
				(_x select 1),
				(_x select 0),
				_color
			];
		} forEach _segments;
	} forEach SP_var_boundingBox_boundingBoxes;
}] call BIS_fnc_addStackedEventHandler;
