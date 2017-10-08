/*
	Bounding Box - Init
	This function runs when Surface Painter inteface is open.
*/

if (isNil "SP_var_boundingBox_boundingBoxes") then {
	SP_var_boundingBox_boundingBoxes = [];
};

if (isNil "SP_var_boundingBox_lastCreatedObject") then {
	SP_var_boundingBox_lastCreatedObject = objNull;
};
