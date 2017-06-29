#include "idcs.hpp"

class CfgPatches {
	class SP_Extra_Export {
		author = "zgmrvn";
		name = "Surface Painter - Extra - Export";
		units[] = {};
		weapons[] = {};
		version = 1.0;
		requiredaddons[] = {"SP_Core"};
	};
};

/*
class CfgFunctions {
	class SP {
		class SurfacePainterExtraExportEvents {
			file = "x\surface_painter\addons\sp_extra_export\events";
			class Export_Init {};
		};

		class SurfacePainterExtraExportFunctions {
			file = "x\surface_painter\addons\sp_extra_export\functions";
			class Export_ExportTerrainBuilder {};
		};
	};
};
*/

class CfgSurfacePainter {
	class DefaultModule;

	class Modules {
		class Export: DefaultModule {
			name	= "Export";
			idc		= SP_SURFACE_PAINTER_EXPORT_OPTIONS_CTRL_GROUP;

			class Events {
				class OnInit { function = "SP_fnc_export_init"; };
			};
		};
	};
};
