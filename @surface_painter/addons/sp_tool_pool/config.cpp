class CfgPatches {
	class SP_Tool_Pool {
		author = "zgmrvn";
		name = "Surface Painter - Tool - Pool";
		units[] = {};
		weapons[] = {};
		version = 1.0;
		requiredaddons[] = {"SP_Core"};
	};
};

class CfgFunctions {
	class SP {
		class SurfacePainterToolPoolEvents {
			file = "x\surface_painter\addons\sp_tool_pool\events";
			class Pool_Init {};
		};

		class SurfacePainterToolPoolFunctions {
			file = "x\surface_painter\addons\sp_tool_pool\functions";
			class Pool_GeneratePool {};
		};
	};
};

class CfgSurfacePainter {
	class DefaultTool;

	class Tools {
		class Pool: DefaultTool {
			description = "";
			recompile	= "x\surface_painter\addons\sp_tool_pool\recompile.sqf";

			class Events {
				class OnInit { function = "SP_fnc_pool_init"; };
			};
		};
	};
};

#include "ui.hpp"
