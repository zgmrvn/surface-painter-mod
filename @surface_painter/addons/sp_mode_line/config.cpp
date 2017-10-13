#include "idcs.hpp"

class CfgPatches {
	class SP_Mode_Line {
		author = "zgmrvn";
		name = "Surface Painter - Mode - Line";
		units[] = {};
		weapons[] = {};
		version = 2.0.0;
		requiredaddons[] = {
			"SP_Core",
			"SP_Tool_Circle",
			"SP_Tool_Pool"
		};
	};
};

class CfgFunctions {
	class SP {
		class SurfacePainterModeLineFunctions {
			file = "x\surface_painter\addons\sp_mode_line\functions";
			class Line_Generate {};
			class Line_Regenerate {};
			class Line_FindEdge {};
		};
	};
};

class CfgSurfacePainter {
	class DefaultModule;

	class Modules {
		class Edge: DefaultModule {
			tools[]		= {"Circle", "Pool"};
			idc			= SP_SURFACE_PAINTER_EDGE_OPTIONS_CTRL_GROUP;
			priority	= 90;
			path		= "x\surface_painter\addons\sp_mode_line";
			icon		= "icon.paa";

			class Events {
				// core
				class OnInit { script = "init.sqf"; };
				class OnActivate { script = "activate.sqf"; };
				class OnDesactivate { script = "desactivate.sqf"; };
				class OnMouseMove { script = "mouseMove.sqf"; };
				class OnPrimaryMouseButtonDown { script = "down.sqf"; };

				// pool
				/*class OnPoolEntryAdd { function = "SP_fnc_edge_regenerate"; };
				class OnPoolEntryDelete { function = "SP_fnc_edge_regenerate"; };
				class OnPoolEntryProbabilityChange { function = "SP_fnc_edge_regenerate"; };
				class OnPoolEntryZOffsetChange { function = "SP_fnc_edge_regenerate"; };
				class OnPoolEntryScaleMinChange { function = "SP_fnc_edge_regenerate"; };
				class OnPoolEntryScaleMaxChange { function = "SP_fnc_edge_regenerate"; };
				class OnPoolEntryFollowTerrainChange { function = "SP_fnc_edge_regenerate"; };*/
			};
		};
	};
};
