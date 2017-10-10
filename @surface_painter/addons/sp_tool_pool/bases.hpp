#include "..\sp_core\styles.hpp"
#include "idcs.hpp"
#include "sizes.hpp"

class ObjectPoolEntry: RscControlsGroup {
	x = 0;
	y = 0;
	w = safeZoneW * SP_POOL_CONTENT_W;
	h = safeZoneH * SP_POOL_ENTRY_H;

	class VScrollbar {
		color[] = {0, 0, 0, 0};
		width = 0;
		autoScrollEnabled = 0;
	};

	fade = 1;

	class Controls {
		class Backgound {
			idc = ENTRY_BACKGROUND;
			type = CT_STATIC;
			style = ST_LEFT;

			x = 0;
			y = 0;
			w = safeZoneW * SP_POOL_CONTENT_W;
			h = safeZoneH * SP_POOL_ENTRY_H;

			colorBackground[] = {0.2, 0.2, 0.2, 0.4};
			colorText[] = {0, 0, 0, 0};
			font = GUI_FONT_NORMAL;
			sizeEx = 0;
			text = "0";
			moving = 1;
		};

		class Picture: RscPicture {
			idc = ENTRY_PICTURE;

			x = 0;
			y = 0;
			w = safeZoneH * SP_POOL_ENTRY_H * (pixelW / pixelH);
			h = safeZoneH * SP_POOL_ENTRY_H;

			text = "\A3\EditorPreviews_F\Data\CfgVehicles\Default\Prop.jpg";
		};

		class DisplayName: RscText {
			idc = ENTRY_DISPLAY_NAME;

			x = safeZoneH * SP_POOL_ENTRY_H * (pixelW / pixelH);
			y = safeZoneH * SP_POOL_ENTRY_H * 0.1;
			w = safeZoneW * SP_POOL_CONTENT_W - (SP_POOL_ENTRY_REMOVE_W + 0.01 + SP_POOL_CONTENT_W * SP_POOL_ENTRY_H);
			h = safeZoneH * SP_POOL_ENTRY_H * 0.4;

			text = "Display name";
			SizeEx = safeZoneH / SP_POOL_ENTRY_DISPLAY_NAME_DIVIDER;
		};

		class ClassName: RscText {
			idc = ENTRY_CLASS_NAME;

			x = safeZoneH * SP_POOL_ENTRY_H * (pixelW / pixelH);
			y = safeZoneH * SP_POOL_ENTRY_H * 0.5;
			w = safeZoneW * SP_POOL_CONTENT_W - (SP_POOL_ENTRY_REMOVE_W + 0.01 + SP_POOL_CONTENT_W * SP_POOL_ENTRY_H);
			h = safeZoneH * SP_POOL_ENTRY_H * 0.4;

			text = "Class name";
			colorText[] = {0.5, 0.5, 0.5, 1};
			SizeEx = safezoneH / SP_POOL_ENTRY_CLASS_NAME_DIVIDER;
		};

		class OpenClose: RscListBox {
			idc = ENTRY_OPEN_CLOSE;

			x = safeZoneH * SP_POOL_ENTRY_H * (pixelW / pixelH);
			y = 0;
			w = safeZoneW * SP_POOL_CONTENT_W - (SP_POOL_ENTRY_REMOVE_W + SP_POOL_CONTENT_W * SP_POOL_ENTRY_H);
			h = safeZoneH * SP_POOL_ENTRY_H;

			colorBackground[] = {0, 0, 0, 0};
		};

		class Remove: RscButton {
			idc = ENTRY_REMOVE;

			x = safeZoneW * SP_POOL_CONTENT_W - safeZoneW * SP_POOL_CONTENT_W * SP_POOL_ENTRY_REMOVE_W;
			y = 0;
			w = safeZoneW * SP_POOL_CONTENT_W * SP_POOL_ENTRY_REMOVE_W;
			h = safeZoneH * SP_POOL_ENTRY_H;

			text = "x";
			SizeEx = safezoneH / SP_POOL_ENTRY_REMOVE_DIVIDER;
			colorBackground[] = {0.2, 0.2, 0.2, 1};
			colorBackgroundActive[] = {0.7686, 0.098, 0.098, 1};
			period = 0;
		};

		class Settings: RscControlsGroup {
			idc = ENTRY_SETTINGS;

			x = 0;
			y = safeZoneH * SP_POOL_ENTRY_H;
			w = safeZoneW * SP_POOL_CONTENT_W;
			h = 0;

			fade = 1;

			class VScrollbar {
				color[] = {0, 0, 0, 0};
				width = 0;
				autoScrollEnabled = 0;
			};

			class Controls {
				class Backgound {
					idc = -1;
					type = CT_STATIC;
					style = ST_LEFT;

					x = 0;
					y = 0;
					w = safeZoneW * SP_POOL_CONTENT_W;
					h = safeZoneH * SP_OPTION_CONTENT_H * 4;

					colorBackground[] = {0.2, 0.2, 0.2, 0.2};
					colorText[] = {0, 0, 0, 0};
					font = GUI_FONT_NORMAL;
					sizeEx = 0;
					text = "";
					moving = 1;
				};

				class Probability: RscControlsGroup {
					idc = ENTRY_PROBABILITY;

					x = 0;
					y = 0;
					w = safeZoneW * SP_POOL_CONTENT_W;
					h = safeZoneH * SP_OPTION_CONTENT_H;

					class Controls {
						class Text: RscText {
							x = 0;
							y = 0;
							w = safeZoneW * SP_POOL_CONTENT_W * 0.9;
							h = safeZoneH * SP_OPTION_CONTENT_H;

							text = $STR_SP_TOOL_POOL_SETTING_PROBABILITY;
							SizeEx = safezoneH / SP_OPTION_COMMON_TEXT_H_DIVIDER;
						};

						class Edit: RscEdit {
							idc = ENTRY_PROBABILITY_EDIT;
							style = ST_CENTER + ST_VCENTER;

							x = safeZoneW * SP_POOL_CONTENT_W * 0.8 + pixelW * 2;
							y = pixelH * 2;
							w = safeZoneW * SP_POOL_CONTENT_W * 0.2 - pixelW * 4;
							h = safeZoneH * SP_OPTION_CONTENT_H - pixelH * 2;

							text = "1.0";
							canModify = 0;
							SizeEx = safezoneH / SP_OPTION_COMMON_TEXT_H_DIVIDER;
						};
					};
				};

				class zOffset: RscControlsGroup {
					idc = ENTRY_Z_OFFSET;

					x = 0;
					y = safeZoneH * SP_OPTION_CONTENT_H;
					w = safeZoneW * SP_POOL_CONTENT_W;
					h = safeZoneH * SP_OPTION_CONTENT_H;

					class Controls {
						class Text: RscText {
							x = 0;
							y = 0;
							w = safeZoneW * SP_POOL_CONTENT_W * 0.9;
							h = safeZoneH * SP_OPTION_CONTENT_H;

							text = $STR_SP_TOOL_POOL_SETTING_Z_OFFSET;
							SizeEx = safezoneH / SP_OPTION_COMMON_TEXT_H_DIVIDER;
						};

						class Edit: RscEdit {
							idc = ENTRY_Z_OFFSET_EDIT;
							style = ST_CENTER + ST_VCENTER;

							x = safeZoneW * SP_POOL_CONTENT_W * 0.8 + pixelW * 2;
							y = pixelH * 2;
							w = safeZoneW * SP_POOL_CONTENT_W * 0.2 - pixelW * 4;
							h = safeZoneH * SP_OPTION_CONTENT_H - pixelH * 2;

							text = "0.0";
							canModify = 0;
							SizeEx = safezoneH / SP_OPTION_COMMON_TEXT_H_DIVIDER;
						};
					};
				};

				class Scale: RscControlsGroup {
					idc = ENTRY_SCALE;

					x = 0;
					y = safeZoneH * SP_OPTION_CONTENT_H * 2;
					w = safeZoneW * SP_POOL_CONTENT_W;
					h = safeZoneH * SP_OPTION_CONTENT_H;

					class Controls {
						class Text: RscText {
							x = 0;
							y = 0;
							w = safeZoneW * SP_POOL_CONTENT_W * 0.6;
							h = safeZoneH * SP_OPTION_CONTENT_H;

							text = $STR_SP_TOOL_POOL_SETTING_SCALE;
							SizeEx = safezoneH / SP_OPTION_COMMON_TEXT_H_DIVIDER;
						};

						class EditMin: RscEdit {
							idc = ENTRY_SCALE_EDIT_MIN;
							style = ST_CENTER + ST_VCENTER;

							x = safeZoneW * SP_POOL_CONTENT_W * 0.6 + pixelW * 2;
							y = pixelH * 2;
							w = safeZoneW * SP_POOL_CONTENT_W * 0.2 - pixelW * 4;
							h = safeZoneH * SP_OPTION_CONTENT_H - pixelH * 2;

							text = "1.0";
							canModify = 0;
							SizeEx = safezoneH / SP_OPTION_COMMON_TEXT_H_DIVIDER;
						};

						class EditMax: RscEdit {
							idc = ENTRY_SCALE_EDIT_MAX;
							style = ST_CENTER + ST_VCENTER;

							x = safeZoneW * SP_POOL_CONTENT_W * 0.8 + pixelW * 2;
							y = pixelH * 2;
							w = safeZoneW * SP_POOL_CONTENT_W * 0.2 - pixelW * 4;
							h = safeZoneH * SP_OPTION_CONTENT_H - pixelH * 2;

							text = "1.0";
							canModify = 0;
							SizeEx = safezoneH / SP_OPTION_COMMON_TEXT_H_DIVIDER;
						};
					};
				};

				class FollowTerrain: RscControlsGroup {
					idc = ENTRY_FOLLOW_TERRAIN;

					x = 0;
					y = safeZoneH * SP_OPTION_CONTENT_H * 3;
					w = safeZoneW * SP_POOL_CONTENT_W;
					h = safeZoneH * SP_OPTION_CONTENT_H;

					class Controls {
						class Text: RscText {
							x = 0;
							y = 0;
							w = safeZoneW * SP_POOL_CONTENT_W * 0.8;
							h = safeZoneH * SP_OPTION_CONTENT_H;

							text = $STR_SP_TOOL_POOL_SETTING_FOLLOW_TERRAIN;
							SizeEx = safezoneH / SP_OPTION_COMMON_TEXT_H_DIVIDER;
						};

						class CheckBox: RscCheckBox {
							idc = ENTRY_FOLLOW_TERRAIN_CHECKBOX;

							x = safeZoneW * (SP_POOL_CONTENT_W * 0.9 - SP_OPTION_CONTENT_H * (safeZoneH / safeZoneW) / 2) + pixelW * 6;
							y = 0;
							w = safeZoneH * SP_OPTION_CONTENT_H * (safeZoneH / safeZoneW);
							h = safeZoneH * SP_OPTION_CONTENT_H;
						};
					};
				};
			};
		};
	};
};
