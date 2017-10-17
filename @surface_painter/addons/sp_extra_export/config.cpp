#include "idcs.hpp"

class CfgPatches {
	class SP_Extra_Export {
		author = "zgmrvn";
		name = "Surface Painter - Extra - Export";
		units[] = {};
		weapons[] = {};
		version = 2.0.0;
		requiredaddons[] = {"SP_Core"};
	};
};

class CfgFunctions {
	class SP {
		class SurfacePainterExtraExportFunctions {
			file = "x\surface_painter\addons\sp_extra_export\functions";
			class Export_ObjectToTbFormat {};
		};
	};
};

class CfgSurfacePainter {
	class DefaultExtra;

	class Modules {
		class Export: DefaultExtra {
			idc			= SP_SURFACE_PAINTER_EXPORT_OPTIONS_CTRL_GROUP;
			path		= "x\surface_painter\addons\sp_extra_export";
			icon		= "icon.paa";

			class Events {
				class OnInit { script = "init.sqf"; };
			};
		};
	};
};
