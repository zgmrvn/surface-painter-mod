class CfgPatches {
	class SP_Tool_Circle {
		author = "zgmrvn";
		name = "Surface Painter - Tool - Circle";
		units[] = {};
		weapons[] = {};
		version = 2.0.0;
		requiredaddons[] = {"SP_Core"};
	};
};

class CfgSurfacePainter {
	class DefaultTool;

	class Tools {
		class Circle: DefaultTool {
			path = "x\surface_painter\addons\sp_tool_circle";

			class Events {
				class OnInit { script = "init.sqf"; };
				class OnActivate { script = "activate.sqf"; };
				class OnDesactivate { script = "desactivate.sqf"; };
				class OnMouseZChange { script = "mouseZChange.sqf"; };
			};
		};
	};
};
