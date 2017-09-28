#include "idcs.hpp"
#include "..\sp_core\sizes.hpp"

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

class CfgFunctions {
	class SP {
		class SurfacePainterModeSurfacePainterEvents {
			file = "x\surface_painter\addons\sp_mode_surface_painter\events";
			class SurfacePainter_Init {};
			class SurfacePainter_Activate {};
			class SurfacePainter_Desactivate {};
			class SurfacePainter_Down {};
			class SurfacePainter_Up {};
			class SurfacePainter_MouseMove {};
		};

		class SurfacePainterModeSurfacePainterFunctions {
			file = "x\surface_painter\addons\sp_mode_surface_painter\functions";
			class SurfacePainter_Paint {};
			class SurfacePainter_CreatePixel {};
			class SurfacePainter_LoadProject {};
		};
	};
};

class CfgVehicles {
	class Land_HelipadCivil_F;

	class Land_SurfaceMapPixel: Land_HelipadCivil_F {
		scope = 2;
		_generalMacro = "Land_SurfaceMapPixel";
		displayName = "Surface map pixel";
		model = "x\surface_painter\addons\sp_mode_surface_painter\pixel.p3d";
		hiddenSelections[] = {"camo"};
	};
};

class CfgSurfacePainter {
	class DefaultModule;

	class OptionHeader;
	class OptionTitle;
	class OptionText;
	class OptionList;
	class OptionButton;

	class Main;

	class Modules {
		class SurfacePainter: DefaultModule {
			tools[]		= {"Circle"};
			idc			= SP_SURFACE_PAINTER_SURFACE_PAINTER_OPTIONS_CTRL_GROUP;
			icon		= "x\surface_painter\addons\sp_mode_surface_painter\icon.paa";
			recompile	= "x\surface_painter\addons\sp_mode_surface_painter\recompile.sqf";

			class Events {
				// core
				class OnInit { function = "SP_fnc_surfacePainter_init"; };
				class OnActivate { function = "SP_fnc_surfacePainter_activate"; };
				class OnDesactivate { function = "SP_fnc_surfacePainter_desactivate"; };
				class OnPrimaryMouseButtonDown { function = "SP_fnc_surfacePainter_Down"; };
				class OnPrimaryMouseButtonUp { function = "SP_fnc_surfacePainter_Up"; };
				class OnMouseMove { function = "SP_fnc_surfacePainter_mouseMove"; };
			};

			class Options {
				#include "options.hpp"
			};
		};
	};
};
