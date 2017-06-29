player addAction [
	"Surface Painter",
	{ createDialog "RscDisplaySurfacePainterCamera" }
];

player addAction [
	"Compile functions",
	{ [] execVM "x\surface_painter\addons\sp_core\scripts\compileFunctions.sqf" }
];
