class CfgPatches {
	class SP_Tool_BoundingBox {
		author = "zgmrvn";
		name = "Surface Painter - Tool - Bounding Box";
		units[] = {};
		weapons[] = {};
		version = 1.1.2;
		requiredaddons[] = {"SP_Core"};
	};
};

class CfgFunctions {
	class SP {
		class SurfacePainterToolBoundingBoxEvents {
			file = "x\surface_painter\addons\sp_tool_bounding_box\events";
			class BoundingBox_Init {};
			class BoundingBox_Activate {};
			class BoundingBox_Desactivate {};
		};

		class SurfacePainterToolBoundingBoxFunctions {
			file = "x\surface_painter\addons\sp_tool_bounding_box\functions";
			class BoundingBox_pushBoundingBox {};
		};
	};
};

class CfgSurfacePainter {
	class DefaultTool;

	class Tools {
		class BoundingBox: DefaultTool {
			recompile = "x\surface_painter\addons\sp_tool_bounding_box\recompile.sqf";

			class Events {
				class OnInit { function = "SP_fnc_BoundingBox_init"; };
				class OnActivate { function = "SP_fnc_BoundingBox_activate"; };
				class OnDesactivate { function = "SP_fnc_BoundingBox_desactivate"; };
			};
		};
	};
};
