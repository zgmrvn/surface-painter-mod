#include "idcs.hpp"
#include "..\sp_core\sizes.hpp"
#include "sizes.hpp"

class RscDisplaySurfacePainterCamera {
	class controlsBackground {
		class PoolBackground: MenuBackground {
			idc = SP_SURFACE_PAINTER_POOL_BACKGROUND;

			x = safeZoneX + safeZoneW * SP_POOL_FOLDED_X;
			w = safeZoneW * SP_FOLDED_W;

			colorBackground[] = {0.1, 0.1, 0.1, 0.8};
		};
	};

	class Controls {
		class PoolExitEvent: PanelEventCheckBox {
			idc = SP_SURFACE_PAINTER_POOL_EVENT_EXIT_CTRL;
		};

		class PoolPanel: PanelControlsGroup {
			idc = SP_SURFACE_PAINTER_POOL_PANEL_CTRL_GROUP;

			x = safeZoneX + safeZoneW * (1 - SP_FOLDED_W);
			y = safeZoneY;
			w = safeZoneW * SP_FOLDED_W;
			h = safeZoneH;

			fade = 1;

			class Controls {
				class PoolSearchField: RscEdit {
					idc = SP_SURFACE_PAINTER_POOL_SEARCH_FIELD;

					x = safeZoneW * SP_MARGIN_X;
					y = safeZoneH * SP_POOL_SEARCH_Y;
					w = safeZoneW * SP_POOL_CONTENT_W;
					h = safeZoneH * SP_POOL_SEARCH_H;

					colorBackground[] = {0.1, 0.1, 0.1, 1};
					SizeEx = safezoneH / SP_OPTION_COMMON_TEXT_H_DIVIDER;
				};

				class PoolSearchResult: RscListBox {
					idc = SP_SURFACE_PAINTER_POOL_SEARCH_RESULT_LIST;

					x = safeZoneW * SP_MARGIN_X;
					y = safeZoneH * SP_POOL_RESULT_Y;
					w = safeZoneW * SP_POOL_CONTENT_W;
					h = safeZoneH * SP_POOL_RESULT_H;

					colorBackground[] = {0.1, 0.1, 0.1, 1};
					rowHeight = safeZoneH * SP_OPTION_CONTENT_H;
					SizeEx = safezoneH / SP_OPTION_COMMON_TEXT_H_DIVIDER;
				};

				class Pool: RscControlsGroup {
					idc = SP_SURFACE_PAINTER_POOL_LIST;

					x = safeZoneW * SP_MARGIN_X;
					y = safeZoneH * SP_POOL_POOL_Y;
					w = safeZoneW * SP_POOL_CONTENT_W;
					h = safeZoneH * SP_POOL_POOL_H;

					colorBackground[] = {0, 0, 0, 0.25};

					class Controls {};

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

				// MUST BE AT THE END TO BE OVER ALL OTHER CONTROLS
				class PoolEnterEvent: PanelEventCheckBox {
					idc = SP_SURFACE_PAINTER_POOL_EVENT_ENTER_CTRL;

					x = 0;
					y = 0;
					w = safeZoneW * SP_FOLDED_W;
					h = safeZoneH;
				};
			};
		};
	};
};
