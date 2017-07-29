class CfgPatches {
	class SP_Core {
		author = "zgmrvn";
		name = "Surface Painter - Core";
		units[] = {};
		weapons[] = {};
		version = 1.0;
		requiredaddons[] = {};
	};
};

class CfgFunctions {
	class SP {
		class Actions {
			file = "x\surface_painter\addons\sp_core\functions\actions";
			class Core_AddAction { postInit = 1; };
		};

		class Objects {
			file = "x\surface_painter\addons\sp_core\functions\objects";
			class Core_CreateSimpleObject {};
		};

		class Options {
			file = "x\surface_painter\addons\sp_core\functions\options";
			class Core_CreateEditOption {};
			class Core_CreateButtonOption {};
			class Core_CreateCheckBoxOption {};
			class Core_CreateHeaderOption {};
		};

		class Compile {
			file = "x\surface_painter\addons\sp_core\functions\compile";
			class Core_CompileFunctions { postInit = 1; };
		};
	};
};

class CfgSurfacePainter {
	// default module class
	class DefaultModule {
		name		= "Module name";
		tools[]		= {};
		defaultMode	= 0;
		idc			= -1;
		icon		= "x\surface_painter\addons\sp_core\icon.paa";

		class Events {
			/*
			// core
			class OnInit {};					// run when Surface Painter dialog is opened
			class OnActivate {};				// run everytime switching this mode
			class OnDesactivate {};				// run everytime leaving this mode
			class OnMouseMove {};				// run everytime mouse move
			class OnPrimaryMouseButtonDown {};	// run when primary mouse button is pressed down
			class OnPrimaryMouseButtonUp {};	// run when primary mouse button is released

			// pool
			class OnPoolEntryAdd {};				// run when a pool entry is added
			class OnPoolEntryDelete {};				// run when a pool entry is deleted
			class OnPoolEntryProbabilityChange {};	// run when a pool entry probability change
			*/
		};
	};

	// default tool class
	class DefaultTool {
		name		= "Tool name";
		description	= "Description";

		class Events {
			/*
			// core
			class OnInit {};			// run when Surface Painter dialog is opened
			class OnActivate {};		// run everytime switching on a mode that uses this tool
			class OnDesactivate {};		// run everytime leaving a mode that uses this tool
			class OnMouseZChange {};	// run when mouse wheel change
			*/
		};
	};

	class Modules {};
	class Tools {};
};

#include "bases.hpp"

#include "ui.hpp"
