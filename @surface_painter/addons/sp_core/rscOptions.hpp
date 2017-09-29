#include "sizes.hpp"
#include "styles.hpp"

class HeaderBase: RscControlsGroup {
	idc = -1;

	x = safeZoneW * SP_MARGIN_X;
	y = 0;
	w = safeZoneW * SP_OPTIONS_CONTENT_W;
	h = safeZoneH * 0.033;

	class Controls {
		class Text: RscText {
			idc = 3;
			style = ST_CENTER;

			x = 0;
			y = -0.007;
			w = safeZoneW * SP_OPTIONS_CONTENT_W;
			h = safeZoneH * 0.025;

			text = "text";

			SizeEx = safezoneH / SP_OPTION_HEADER_TEXT_H_DIVIDER;
		};

		class Underline: RscText {
			idc = 4;

			x = 0;
			y = safeZoneH * 0.03;
			w = safeZoneW * SP_OPTIONS_CONTENT_W;
			h = pixelH * 2;

			colorBackground[] = {
				"(profilenamespace getvariable ['GUI_BCG_RGB_R', 0.5])",
				"(profilenamespace getvariable ['GUI_BCG_RGB_G', 0.5])",
				"(profilenamespace getvariable ['GUI_BCG_RGB_B', 0.5])",
				1
			};
		};
	};
};

class TitleBase: RscControlsGroup {
	idc = -1;

	x = safeZoneW * SP_MARGIN_X;
	y = 0;
	w = safeZoneW * SP_OPTIONS_CONTENT_W;
	h = safeZoneH * 0.028;

	class Controls {
		class Text: RscText {
			idc = 3;

			x = 0;
			y = 0;
			w = safeZoneW * SP_OPTIONS_CONTENT_W;
			h = safeZoneH * 0.023;

			text = "text";

			SizeEx = safezoneH / SP_OPTION_TITLE_TEXT_H_DIVIDER;
		};

		class Underline: RscText {
			idc = 4;

			x = 0;
			y = safeZoneH * 0.025;
			w = safeZoneW * SP_OPTIONS_CONTENT_W;
			h = pixelH;

			colorBackground[] = {0.4, 0.4, 0.4, 1};
		};
	};
};

class EditBase: RscControlsGroup {
	idc = -1;

	x = safeZoneW * SP_MARGIN_X;
	y = 0;
	w = safeZoneW * SP_OPTIONS_CONTENT_W;
	h = safeZoneH * SP_OPTION_CONTENT_H + pixelH;

	class Controls {
		class Edit: RscEdit {
			idc = 3;
			style = ST_CENTER + ST_VCENTER;

			x = pixelW;
			y = pixelH;
			w = safeZoneW * SP_OPTIONS_CONTENT_W * SP_OPTION_EDIT_EDIT_W;
			h = safeZoneH * SP_OPTION_CONTENT_H;

			text = "0";

			SizeEx = safezoneH / SP_OPTION_COMMON_TEXT_H_DIVIDER;
			canModify = 0;
			colorBackground[] = {0.1, 0.1, 0.1, 1};
		};

		class Text: RscText {
			idc = 4;

			x = safeZoneW * SP_OPTION_EDIT_EDIT_W * SP_OPTIONS_CONTENT_W;
			y = 0;
			w = safeZoneW * SP_OPTIONS_CONTENT_W * SP_OPTION_EDIT_TEXT_W;
			h = safeZoneH * SP_OPTION_CONTENT_H;

			text = "text";

			SizeEx = safezoneH / SP_OPTION_COMMON_TEXT_H_DIVIDER;
			colorBackground[] = {0.1, 0.1, 0.1, 1};
		};
	};
};

class CheckBoxBase: RscControlsGroup {
	idc = -1;

	x = safeZoneW * SP_MARGIN_X;
	y = 0;
	w = safeZoneW * SP_OPTIONS_CONTENT_W;
	h = safeZoneH * SP_OPTION_CONTENT_H;

	class Controls {
		class Edit: RscCheckBox {
			idc = 3;

			x = 0;
			y = 0;
			w = safeZoneH * SP_OPTION_CONTENT_H * (pixelW / pixelH);
			h = safeZoneH * SP_OPTION_CONTENT_H;

			text = "0";

			SizeEx = safezoneH / SP_OPTION_COMMON_TEXT_H_DIVIDER;
			colorBackground[] = {0.1, 0.1, 0.1, 1};
		};

		class Text: RscText {
			idc = 4;

			x = safeZoneH * SP_OPTION_CONTENT_H * (pixelW / pixelH);
			y = 0;
			w = safeZoneW * SP_OPTIONS_CONTENT_W - safeZoneH * SP_OPTION_CONTENT_H * (pixelW / pixelH);
			h = safeZoneH * SP_OPTION_CONTENT_H;

			text = "text";

			SizeEx = safezoneH / SP_OPTION_COMMON_TEXT_H_DIVIDER;
			colorBackground[] = {0.1, 0.1, 0.1, 1};
		};
	};
};

class ButtonBase: RscControlsGroup {
	idc = -1;

	x = safeZoneW * SP_MARGIN_X;
	y = 0;
	w = safeZoneW * SP_OPTIONS_CONTENT_W;
	h = safeZoneH * 0.05;

	class Controls {
		class Button: RscButton {
			idc = 3;

			x = 0;
			y = 0;
			w = safeZoneW * SP_OPTIONS_CONTENT_W;
			h = safeZoneH * 0.05;

			text = "text";

			SizeEx = safezoneH / SP_OPTION_BUTTON_TEXT_H_DIVIDER;
			colorBackground[] = {0.2, 0.2, 0.2, 1};
			colorBackgroundActive[] = {
				"(profilenamespace getvariable ['GUI_BCG_RGB_R', 0.5])",
				"(profilenamespace getvariable ['GUI_BCG_RGB_G', 0.5])",
				"(profilenamespace getvariable ['GUI_BCG_RGB_B', 0.5])",
				1
			};
		};
	};
};

class ListBoxBase: RscControlsGroup {
	idc = -1;

	x = safeZoneW * SP_MARGIN_X;
	y = 0;
	w = safeZoneW * SP_OPTIONS_CONTENT_W;
	h = safeZoneH * SP_OPTION_CONTENT_H * 8;

	class Controls {
		class ListBox: RscListBox {
			idc = 3;

			x = 0;
			y = 0;
			w = safeZoneW * SP_OPTIONS_CONTENT_W;
			h = safeZoneH * SP_OPTION_CONTENT_H * 8;

			SizeEx = safezoneH / SP_OPTION_COMMON_TEXT_H_DIVIDER;
			colorBackground[] = {0.1, 0.1, 0.1, 1};
			rowHeight = safeZoneH * SP_OPTION_CONTENT_H;
		};
	};
};

class TextBase: RscControlsGroup {
	idc = -1;

	x = safeZoneW * SP_MARGIN_X;
	y = 0;
	w = safeZoneW * SP_OPTIONS_CONTENT_W;
	h = safeZoneH * SP_OPTION_CONTENT_H;

	class Controls {
		class Text: RscText {
			idc = 3;

			x = 0;
			y = 0;
			w = safeZoneW * SP_OPTIONS_CONTENT_W;
			h = safeZoneH * SP_OPTION_CONTENT_H;

			SizeEx = safezoneH / SP_OPTION_COMMON_TEXT_H_DIVIDER;
			colorBackground[] = {0.1, 0.1, 0.1, 1};
			text = "text";
		};
	};
};
