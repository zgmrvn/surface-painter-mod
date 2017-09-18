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

	class Modules {
		class SurfacePainter: DefaultModule {
			name	= "Surface Painter";
			tools[]	= {"Circle"};
			idc		= SP_SURFACE_PAINTER_SURFACE_PAINTER_OPTIONS_CTRL_GROUP;
			icon	= "x\surface_painter\addons\sp_mode_surface_painter\icon.paa";

			class Events {
				// core
				class OnInit { function = "SP_fnc_surfacePainter_init"; };
				class OnPrimaryMouseButtonDown { function = "SP_fnc_surfacePainter_Down"; };
				class OnPrimaryMouseButtonUp { function = "SP_fnc_surfacePainter_Up"; };
				class OnMouseMove { function = "SP_fnc_surfacePainter_mouseMove"; };
			};

			class Options {
				class Header {
					rsc = "HeaderBase";

					values[] = {
						{3, "STRING", $STR_SP_SURFACE_PAINTER_HEADER}
					};
				};

				class TitleInfos {
					rsc = "TitleBase";

					values[] = {
						{3, "STRING", $STR_SP_SURFACE_PAINTER_INFOS}
					};

					margin = SP_OPTION_CONTENT_M;
				};

				class WorldSize {
					rsc = "TextBase";
					expose = 1;

					values[] = {
						{3, "STRING", $STR_SP_SURFACE_PAINTER_WORLD_SIZE}
					};

					margin = SP_OPTION_CONTENT_M_1_6TH;
				};

				class MaskSize {
					rsc = "TextBase";
					expose = 1;

					values[] = {
						{3, "STRING", $STR_SP_SURFACE_PAINTER_MASK_SIZE}
					};

					margin = 0;
				};

				class PixelSize {
					rsc = "TextBase";
					expose = 1;

					values[] = {
						{3, "STRING", $STR_SP_SURFACE_PAINTER_PIXEL_SIZE}
					};

					margin = 0;
				};

				class TitleMask {
					rsc = "TitleBase";

					values[] = {
						{3, "STRING", $STR_SP_SURFACE_PAINTER_MASK}
					};

					margin = SP_OPTION_CONTENT_M;
				};

				class MaskColors {
					rsc = "ListBoxBase";
					expose = 1;

					values[] = {
						{3, "LIST", "FFFFFF"}
					};

					margin = SP_OPTION_CONTENT_M_1_6TH;
				};

				class Generate {
					rsc = "ButtonBase";
					expose = 1;

					values[] = {
						{3, "STRING", $STR_SP_SURFACE_PAINTER_GENERATE}
					};

					margin = SP_OPTION_CONTENT_M;
				};
			};
		};
	};
};
