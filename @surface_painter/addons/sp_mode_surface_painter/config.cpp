#include "idcs.hpp"

class CfgPatches {
	class SP_Mode_SurfacePainter {
		author = "zgmrvn";
		name = "Surface Painter - Mode - Surface Painter";
		units[] = {};
		weapons[] = {};
		version = 1.0;
		requiredaddons[] = {"A3_Structures_F_Mil_Helipads", "SP_Core"};
	};
};

/*
class CfgFunctions {
	class SP {
		class SurfacePainterModeSurfacePainterEvents {
			file = "x\surface_painter\addons\sp_mode_surface_painter\events";
			class SurfacePainter_Init {};
			class SurfacePainter_Down {};
			class SurfacePainter_Up {};
		};

		class SurfacePainterModeSurfacePainterFunctions {
			file = "x\surface_painter\addons\sp_mode_surface_painter\functions";
			class SurfacePainter_Paint {};
			class SurfacePainter_HexToDecColor {};
		};
	};
};
*/

class CfgVehicles {
	class Land_HelipadCivil_F;

	class Land_SurfaceMapPixel_1m: Land_HelipadCivil_F {
		scope = 2;
		_generalMacro = "Land_SurfaceMapPixel_1m";
		displayName = "Surface map pixel";
		model = "x\surface_painter\addons\sp_mode_surface_painter\pixels\pixel_1m.p3d";
		hiddenSelections[] = {"texture"};
	};

	class Land_SurfaceMapPixel_2m: Land_SurfaceMapPixel_1m {
		_generalMacro = "Land_SurfaceMapPixel_2m";
		displayName = "Surface map pixel";
		model = "x\surface_painter\addons\sp_mode_surface_painter\pixels\pixel_2m.p3d";
	};

	class Land_SurfaceMapPixel_3m: Land_SurfaceMapPixel_1m {
		_generalMacro = "Land_SurfaceMapPixel_3m";
		displayName = "Surface map pixel";
		model = "x\surface_painter\addons\sp_mode_surface_painter\pixels\pixel_3m.p3d";
	};

	class Land_SurfaceMapPixel_4m: Land_SurfaceMapPixel_1m {
		_generalMacro = "Land_SurfaceMapPixel_4m";
		displayName = "Surface map pixel";
		model = "x\surface_painter\addons\sp_mode_surface_painter\pixels\pixel_4m.p3d";
	};
};

class CfgSurfacePainter {
	class DefaultModule;

	class Modules {
		class SurfacePainter: DefaultModule {
			name	= "Surface Painter";
			tools[]	= {"Circle"};
			idc		= SP_SURFACE_PAINTER_SURFACE_PAINTER_OPTIONS_CTRL_GROUP;
			icon		= "x\surface_painter\addons\sp_mode_surface_painter\icon.paa";

			class Events {
				// core
				class OnInit { function = "SP_fnc_surfacePainter_init"; };
				class OnPrimaryMouseButtonDown { function = "SP_fnc_surfacePainter_Down"; };
				class OnPrimaryMouseButtonUp { function = "SP_fnc_surfacePainter_Up"; };
				/*class OnActivate { function = "SP_fnc_edge_activate"; };
				class OnDesactivate { function = "SP_fnc_edge_desactivate"; };*/
				class OnMouseMove { function = "SP_fnc_surfacePainter_mouseMove"; };

				/*
				// pool
				class OnPoolEntryAdd { function = "SP_fnc_edge_regenerate"; };
				class OnPoolEntryDelete { function = "SP_fnc_edge_regenerate"; };
				class OnPoolEntryProbabilityChange { function = "SP_fnc_edge_regenerate"; };*/
			};
		};
	};
};
