#include "idcs.hpp"

class CfgPatches {
	class SP_Mode_Brush {
		author = "zgmrvn";
		name = "Surface Painter - Mode - Brush";
		units[] = {};
		weapons[] = {};
		version = 2.0.0;
		requiredaddons[] = {
			"SP_Core",
			"SP_Tool_Circle"
		};
	};
};

class CfgSurfacePainter {
	class DefaultModule;

	class Modules {
		class Brush: DefaultModule {
			tools[]		= { "Circle", "Pool" };
			idc			= SP_SURFACE_PAINTER_BRUSH_OPTIONS_CTRL_GROUP;
			priority	= 100;
			path		= "x\surface_painter\addons\sp_mode_brush";
			icon		= "icon.paa";

			class Events {
				class OnInit { script = "init.sqf"; };
				class OnPrimaryMouseButtonDown { script = "down.sqf"; };
				class OnPrimaryMouseButtonUp { script = "up.sqf"; };
			};
		};
	};
};
