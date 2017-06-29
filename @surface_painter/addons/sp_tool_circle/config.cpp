class CfgPatches {
	class SP_Tool_Circle {
		author = "zgmrvn";
		name = "Surface Painter - Tool - Circle";
		units[] = {};
		weapons[] = {};
		version = 1.0;
		requiredaddons[] = {"SP_Core"};
	};
};

/*
class CfgFunctions {
	class SP {
		class SurfacePainterToolCircle {
			file = "x\surface_painter\addons\sp_tool_circle\events";
			class Circle_Init {};
			class Circle_Activate {};
			class Circle_Desactivate {};
			class Circle_ZChange {};
		};
	};
};
*/

class CfgSurfacePainter {
	class DefaultTool;

	class Tools {
		class Circle: DefaultTool {
			name = "Circle";
			description = "";

			class Events {
				class OnInit { function = "SP_fnc_circle_init"; };
				class OnActivate { function = "SP_fnc_circle_activate"; };
				class OnDesactivate { function = "SP_fnc_circle_desactivate"; };
				class OnMouseZChange { function = "SP_fnc_circle_zChange"; };
			};
		};
	};
};
