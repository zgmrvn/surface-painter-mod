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
			class Core_AddAction { postInit = 1; recompile = 1; };
		};

		class Recompile {
			file = "x\surface_painter\addons\sp_core\functions\recompile";
			class Core_RecompileFunctions { recompile = 1; };
		};

		class Objects {
			file = "x\surface_painter\addons\sp_core\functions\objects";
			class Core_CreateSimpleObject {};
		};

		class Notifications {
			file = "x\surface_painter\addons\sp_core\functions\notifications";
			class Core_PushNotification {};
		};
	};
};

class CfgSurfacePainter {

	// default module class
	class DefaultModule {
		tools[]		= {};
		idc			= -1;
		icon		= "x\surface_painter\addons\sp_core\icon.paa";
		recompile	= "";

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

		class Options {};
	};

	// default tool class
	class DefaultTool {
		description = "Description";
		recompile	= "";

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

	#include "options.hpp"

	class Modules {};
	class Tools {};
};

class RscControlsGroup;
class RscEdit;
class RscCheckBox;
class RscText;
class RscButton;
class RscListBox;
class rscPicture;

#include "bases.hpp"
#include "rscOptions.hpp"
#include "rscNotification.hpp"

#include "ui.hpp"
