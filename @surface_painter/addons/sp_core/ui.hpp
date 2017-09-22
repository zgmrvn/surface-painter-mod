#include "idcs.hpp"
#include "sizes.hpp"

class RscDisplaySurfacePainterCamera {
	idd = SP_SURFACE_PAINTER_IDD;

	onLoad = "[] execVM 'x\surface_painter\addons\sp_core\uiStart.sqf';";
	onUnload = "[] execVM 'x\surface_painter\addons\sp_core\uiStop.sqf';";

	class controlsBackground {
		// main event control, responsible of mouse to world interactions
		class EventCtrl: RscListBox {
			idc = SP_SURFACE_PAINTER_EVENT_CTRL;
			type = CT_LISTBOX;

			x = safeZoneX;
			y = safeZoneY;
			w = safeZoneW;
			h = safeZoneH;

			colorBackground[] = {0, 0, 0, 0};
			lineSpacing = 0;
			text = "";
		};

		// modes and options background
		class ModesBackground: MenuBackground {
			idc = SP_SURFACE_PAINTER_MODES_BACKGROUND;
			type = CT_STATIC;

			x = safeZoneX;
			w = safeZoneW * SP_MODES_W;
		};

		// parent class for background controls
		class OptionsBackground: MenuBackground {
			idc = SP_SURFACE_PAINTER_OPTIONS_BACKGROUND;

			x = safeZoneX + safeZoneW * SP_FOLDED_W;
			y = safeZoneY;
			w = 0;
			h = safeZoneH;

			colorBackground[] = {0, 0, 0, 1};
		};
	};

	class Controls {
		//////////////////////////////////////////////
		//////////////////////////////////////////////
		///// LEFT PANEL /////////////////////////////
		//////////////////////////////////////////////
		//////////////////////////////////////////////

		// this control detect when you leave the left panel
		class LeftPanelExitEvent: PanelEventCheckBox {
			idc = SP_SURFACE_PAINTER_LEFT_PANEL_EVENT_EXIT_CTRL;
		};

		class LeftPanel: PanelControlsGroup {
			idc = SP_SURFACE_PAINTER_LEFT_PANEL_CTRL_GROUP;

			x = safeZoneX;
			y = safeZoneY;
			w = safeZoneW * SP_FOLDED_W;
			h = safeZoneH;

			class Controls {
				// modes list
				class Modes: RscControlsGroup {
					idc = SP_SURFACE_PAINTER_MODES_LIST;

					x = 0;
					y = 0;
					w = safeZoneW * SP_FOLDED_W;
					h = safeZoneH * 0.5;
				};

				// MUST BE AT THE END TO BE OVER ALL OTHER CONTROLS
				class LeftPanelEnterEvent: PanelEventCheckBox {
					idc = SP_SURFACE_PAINTER_LEFT_PANEL_EVENT_ENTER_CTRL;

					x = 0;
					y = 0;
					w = safeZoneW * SP_FOLDED_W;
					h = safeZoneH;
				};
			};
		};

		//////////////////////////////////////////////
		//////////////////////////////////////////////
		///// NOTIFICATION LIST //////////////////////
		//////////////////////////////////////////////
		//////////////////////////////////////////////

		class NotificationList: RscControlsGroup {
			idc = SP_SURFACE_PAINTER_NOTIFICATIONS_CTRL_GROUP;

			x = safeZoneX + safeZoneW * (0.5 - SP_NOTIFICATION_W / 2);
			y = safeZoneY + safeZoneH * SP_MARGIN_Y;
			w = safeZoneW * SP_NOTIFICATION_W;
			h = 0;

			class VScrollbar {
				color[] = {0, 0, 0, 0};
				width = 0;
				autoScrollEnabled = 0;
			};

			class HScrollbar {
				color[] = {0, 0, 0, 0};
				height = 0;
			};
		};
	};
};
