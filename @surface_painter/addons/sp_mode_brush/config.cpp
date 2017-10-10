#include "idcs.hpp"
#include "..\sp_core\sizes.hpp"

class CfgPatches {
	class SP_Mode_Brush {
		author = "zgmrvn";
		name = "Surface Painter - Mode - Brush";
		units[] = {};
		weapons[] = {};
		version = 1.0.1;
		requiredaddons[] = {
			"SP_Core",
			"SP_Tool_Circle",
			"SP_Tool_Pool",
			"SP_Tool_BoundingBox"
		};
	};
};

class CfgFunctions {
	class SP {
		class SurfacePainterModeBrushEvents {
			file = "x\surface_painter\addons\sp_mode_brush\events";
			class Brush_Init {};
			class Brush_Down {};
			class Brush_Up {};
		};
	};
};

class CfgSurfacePainter {
	class DefaultModule;

	class OptionHeader;
	class OptionTitle;
	class OptionEdit;

	class Main;
	class Second;

	class Modules {
		class Brush: DefaultModule {
			tools[]		= {"Circle", "Pool", "BoundingBox"};
			idc			= SP_SURFACE_PAINTER_BRUSH_OPTIONS_CTRL_GROUP;
			priority	= 5;
			icon		= "x\surface_painter\addons\sp_mode_brush\icon.paa";
			recompile	= "x\surface_painter\addons\sp_mode_brush\recompile.sqf";

			class Events {
				class OnInit { function = "SP_fnc_brush_init"; };
				class OnPrimaryMouseButtonDown { function = "SP_fnc_brush_Down"; };
				class OnPrimaryMouseButtonUp { function = "SP_fnc_brush_Up"; };
			};

			class Options {
				#include "options.hpp"
			};
		};
	};
};
