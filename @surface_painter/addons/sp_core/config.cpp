class CfgPatches {
	class SP_Core {
		author = "zgmrvn";
		name = "Surface Painter - Core";
		units[] = {};
		weapons[] = {};
		version = 2.0.0;
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

		class Events {
			file = "x\surface_painter\addons\sp_core\functions\events";
			class Core_TryEvent {};
		};
	};
};

class CfgSurfacePainter {

	// default module class
	class DefaultModule {
		tools[]		= {};
		idc			= -1;
		extra		= 0;
		priority	= -1;
		path		= "x\surface_painter\addons\sp_core";
		icon		= "icon.paa";

		class Events {
			/*
			// core
			class OnInit {};						// run when Surface Painter dialog is opened
			class OnActivate {};					// run everytime switching this mode
			class OnDesactivate {};					// run everytime leaving this mode
			class OnMouseMove {};					// run everytime mouse move
			class OnPrimaryMouseButtonDown {};		// run when primary mouse button is pressed down
			class OnPrimaryMouseButtonUp {};		// run when primary mouse button is released
			class OnSecondaryMouseButtonDown {};	// run when secondary mouse button is pressed down
			class OnSecondaryMouseButtonUp {};		// run when secondary mouse button is released

			// pool
			class OnPoolEntryAdd {};					// run when a pool entry is added
			class OnPoolEntryDelete {};					// run when a pool entry is deleted
			class OnPoolEntryProbabilityChange {};		// run when a pool entry probability change
			class OnPoolEntryZOffsetChange {};			// run when a pool entry z offset change
			class OnPoolEntryScaleMinChange {};			// run when a pool entry min scale change
			class OnPoolEntryScaleMaxChange {};			// run when a pool entry max scale change
			class OnPoolEntryFollowTerrainChange {};	// run when a pool entry follow terrain change
			*/
		};

		class Options {};
	};

	// default extra class
	// a special type of module that is not directly related to object placement nor creation stuff
	// e.g project manager, object exporter
	// they will be created in the bottom-left corner in a dedicated list
	class DefaultExtra: DefaultModule {
		extra = 1;
	};

	// default tool class
	class DefaultTool {
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

class RscListBox;
class RscControlsGroup;
class rscPicture;
class RscText;

/*class RscEdit;
class RscCheckBox;

class RscButton;*/
//class rscPicture;
/*
#include "bases.hpp"
#include "rscOptions.hpp"
#include "rscNotification.hpp"
*/

#include "ui.hpp"
