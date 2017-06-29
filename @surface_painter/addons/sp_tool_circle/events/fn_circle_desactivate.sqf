/*
	Desactivation of Circle tool.
	This function will run everytime leaving a mode that uses this tool.
*/

systemChat "circle desactivated";

["circle", "onEachFrame"] call BIS_fnc_removeStackedEventHandler;
