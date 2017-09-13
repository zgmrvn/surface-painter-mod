#include "idcs.hpp"
#include "..\sp_core\sizes.hpp"

class CfgPatches {
	class SP_Mode_Brush {
		author = "zgmrvn";
		name = "Surface Painter - Mode - Brush";
		units[] = {};
		weapons[] = {};
		version = 1.0;
		requiredaddons[] = {"SP_Core", "SP_Tool_Circle", "SP_Tool_Pool"};
	};
};

/*
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
*/

class CfgSurfacePainter {
	class DefaultModule;

	class Modules {
		class Brush: DefaultModule {
			name		= "Brush";
			tools[]		= {"Circle", "Pool"};
			idc			= SP_SURFACE_PAINTER_BRUSH_OPTIONS_CTRL_GROUP;
			icon		= "x\surface_painter\addons\sp_mode_brush\icon.paa";

			class Events {
				class OnInit { function = "SP_fnc_brush_init"; };
				class OnPrimaryMouseButtonDown { function = "SP_fnc_brush_Down"; };
				class OnPrimaryMouseButtonUp { function = "SP_fnc_brush_Up"; };
			};

			class Options {
				class Header {
					rsc = "HeaderBase";

					values[] = {
						{3, "STRING", "Brush"}
					};
				};

				class TitlePlacement {
					rsc = "TitleBase";

					values[] = {
						{3, "STRING", "Placement"}
					};

					margin = SP_OPTION_CONTENT_M;
				};

				class Distance {
					rsc = "EditBase";
					expose = 1;

					values[] = {
						{3, "NUMBER", 0},
						{4, "STRING", "Distance between objects"}
					};

					margin = SP_OPTION_CONTENT_M_1_6TH;
				};

				class Flow {
					rsc = "EditBase";
					expose = 1;

					values[] = {
						{3, "NUMBER", 20},
						{4, "STRING", "Object flow"}
					};

					margin = SP_OPTION_CONTENT_M_1_6TH;
				};
			};
		};
	};
};
