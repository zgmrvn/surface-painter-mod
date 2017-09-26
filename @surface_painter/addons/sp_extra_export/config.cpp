#include "idcs.hpp"
#include "..\sp_core\sizes.hpp"

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

class CfgSurfacePainter {
	class DefaultModule;

	class OptionHeader;
	class OptionButton;

	class Main;

	class Modules {
		class Export: DefaultExtra {
			idc			= SP_SURFACE_PAINTER_EXPORT_OPTIONS_CTRL_GROUP;
			icon		= "x\surface_painter\addons\sp_extra_export\icon.paa";
			recompile	= "x\surface_painter\addons\sp_extra_export\recompile.sqf";

			class Events {
				class OnInit { function = "SP_fnc_export_init"; };
			};

			class Options {
				#include "options.hpp"
			};
		};
	};
};
