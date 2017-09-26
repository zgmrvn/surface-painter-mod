#define DEV true

player addAction [
	"Surface Painter",
	{ createDialog "RscDisplaySurfacePainterCamera" }
];

if (DEV) then {
	player addAction [
		"Recompile functions",
		{ [] spawn SP_fnc_core_recompileFunctions }
	];
};
