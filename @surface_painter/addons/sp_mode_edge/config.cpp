#include "idcs.hpp"

class CfgPatches {
	class SP_Mode_Edge {
		author = "zgmrvn";
		name = "Surface Painter - Mode - Edge";
		units[] = {};
		weapons[] = {};
		version = 1.0;
		requiredaddons[] = {"SP_Core", "SP_Tool_Circle", "SP_Tool_Pool"};
	};
};

/*
class CfgFunctions {
	class SP {
		class SurfacePainterModeEdgeEvents {
			file = "x\surface_painter\addons\sp_mode_edge\events";
			class Edge_Init {};
			class Edge_Activate {};
			class Edge_Desactivate {};
			class Edge_MouseMove {};
			class Edge_Down {};
		};

		class SurfacePainterModeEdgeFunctions {
			file = "x\surface_painter\addons\sp_mode_edge\functions";
			class Edge_Generate {};
			class Edge_Regenerate {};
			class Edge_FindEdge {};
		};
	};
};
*/

class CfgSurfacePainter {
	class DefaultModule;

	class Modules {
		class Edge: DefaultModule {
			name	= "Edge";
			tools[]	= {"Circle", "Pool"};
			idc		= SP_SURFACE_PAINTER_EDGE_OPTIONS_CTRL_GROUP;
			icon		= "x\surface_painter\addons\sp_mode_edge\icon.paa";

			class Events {
				// core
				class OnInit { function = "SP_fnc_edge_init"; };
				class OnActivate { function = "SP_fnc_edge_activate"; };
				class OnDesactivate { function = "SP_fnc_edge_desactivate"; };
				class OnMouseMove { function = "SP_fnc_edge_mouseMove"; };
				class OnPrimaryMouseButtonDown { function = "SP_fnc_edge_down"; };

				// pool
				class OnPoolEntryAdd { function = "SP_fnc_edge_regenerate"; };
				class OnPoolEntryDelete { function = "SP_fnc_edge_regenerate"; };
				class OnPoolEntryProbabilityChange { function = "SP_fnc_edge_regenerate"; };
			};
		};
	};
};
