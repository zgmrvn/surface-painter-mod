#include "idcs.hpp"
#include "types.hpp"
#include "styles.hpp"
#include "sizes.hpp"


class RscStatic {
	idc = -1;
	type = CT_STATIC;
	style = ST_LEFT;

	x = safeZoneX;
	y = safeZoneY;
	w = safeZoneW;
	h = safeZoneH;

	colorBackground[] = {0, 0, 0, 1};
	colorText[] = {1, 1, 1, 1};
	font = GUI_FONT_NORMAL;
	sizeEx = GUI_GRID_CENTER_H;
	text = "";
	moving = 1;
};



class RscEvent: RscListBox {
	x = safeZoneX;
	y = safeZoneY;
	w = safeZoneW;
	h = safeZoneH;

	colorBackground[] = {1, 0, 0, 0};
	lineSpacing = 0;
	rowHeight = 0;
	text = "";
};

class RscData: RscText {
	x = 0;
	y = 0;
	w = 0;
	h = 0;

	text = "";
	sizeEx = 0;
	colorBackground[] = {0, 0, 0, 0};
	colorText[] = {0, 0, 0, 0};
};



// menu button
class MenuButton: RscControlsGroupNoScrollbars {
	x = 0;
	y = 0;
	w = safeZoneW * SP_MENU_W;
	h = safeZoneW * SP_MENU_W * (safeZoneW / safeZoneH);

	class Controls {
		class Data: RscData {
			idc = SP_MENU_BUTTON_DATA;
		};

		class Icon: RscPicture {
			idc = SP_MENU_BUTTON_ICON;

			x = 0;
			y = 0;
			w = safeZoneW * SP_MENU_W;
			h = safeZoneW * SP_MENU_W * (safeZoneW / safeZoneH);
		};
	};
};


class RscDisplaySurfacePainter {
	idd = SP_IDD;

	onLoad = "[] execVM 'x\surface_painter\addons\sp_core\uiStart.sqf';";
	onUnload = "[] execVM 'x\surface_painter\addons\sp_core\uiStop.sqf';";

	class controlsBackground {
		class EventControl: RscEvent {
			idc = SP_EVENT_CONTROL;
		};
	};

	class Controls {
		class Menu: RscControlsGroupNoScrollbars {
			idc = SP_MENU_CONTROLS_GROUP;

			x = safeZoneX;
			y = safeZoneY;
			w = safeZoneW * SP_MENU_W;
			h = safeZoneH;

			fade = 1;

			class Controls {
				class Background: RscStatic {
					x = 0;
					y = 0;
					w = safeZoneW * SP_MENU_W;
					h = safeZoneH;

					colorBackground[] = {0, 0, 0, 1};
					colorText[] = {0, 0, 0, 0};
					sizeEx = 0;
				};

				class Logo: RscControlsGroupNoScrollbars {
					x = 0;
					y = 0;
					w = safeZoneW * SP_MENU_W;
					h = safeZoneW * SP_MENU_W * (safeZoneW / safeZoneH);

					class Controls {
						class Background: RscStatic {
							x = 0;
							y = 0;
							w = safeZoneW * SP_MENU_W;
							h = safeZoneW * SP_MENU_W * (safeZoneW / safeZoneH);

							colorBackground[] = {1, 1, 1, 1};
							colorText[] = {0, 0, 0, 0};
							sizeEx = 0;
						};

						class Picture: RscPicture {
							x = 0;
							y = 0;
							w = safeZoneW * SP_MENU_W;
							h = safeZoneW * SP_MENU_W * (safeZoneW / safeZoneH);

							text = "x\surface_painter\addons\sp_core\logo_ca.paa";
						};
					};
				};

				class Modules: RscControlsGroupNoScrollbars {
					idc = SP_MODULES_CONTROLS_GROUP;

					x = 0;
					y = safeZoneW * SP_MENU_W * (safeZoneW / safeZoneH);
					w = safeZoneW * SP_MENU_W;
					h = safeZoneH - safeZoneW * SP_MENU_W * (safeZoneW / safeZoneH);

					class Controls {
						class Background: RscStatic {
							idc = SP_MODULES_BUTTONS_BACKGROUND_CONTROL;

							x = 0;
							y = 0;
							w = safeZoneW * SP_MENU_W;
							h = safeZoneW * SP_MENU_W * (safeZoneW / safeZoneH);

							colorBackground[] = {0.4, 0.4, 0.4, 1};
						};

						class Separator: RscStatic {
							idc = SP_MODULES_BUTTONS_SEPARATOR_CONTROL;
							style = CT_STATIC + ST_LINE;

							x = safeZoneW * SP_MENU_W * 0.25;
							y = 0;
							w = safeZoneW * SP_MENU_W * 0.5;
							h = 0;

							colorBackground[] = {0, 0, 0, 0};
							colorText[] = {0.4, 0.4, 0.4, 1};

							fade = 1;
						};
					};
				};
			};
		};

		class Loading: RscControlsGroupNoScrollbars {
			idc = SP_LOADING_CONTROLS_GROUP;

			x = safeZoneX;
			y = safeZoneY;
			w = safeZoneW;
			h = safeZoneH;

			fade = 1;

			class Controls {
				class Background: RscStatic {
					x = 0;
					y = 0;

					colorBackground[] = {0.3, 0.3, 0.3, 1};
				};
			};
		};
	};
};





		// modes and options background
		/*class ModesBackground: MenuBackground {
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
		};*/

	/*class Controls {
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
					h = safeZoneH;
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
		};*/

		//////////////////////////////////////////////
		//////////////////////////////////////////////
		///// NOTIFICATION LIST //////////////////////
		//////////////////////////////////////////////
		//////////////////////////////////////////////

		/*class NotificationList: RscControlsGroup {
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
	};*/
