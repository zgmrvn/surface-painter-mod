#include "sizes.hpp"
#include "styles.hpp"

class RscSpNotification: RscControlsGroup {
	idc = -1;

	x = 0;
	y = -(safeZoneH * SP_NOTIFICATION_H + SP_NOTIFICATION_MARGIN);
	w = safeZoneW * SP_NOTIFICATION_W;
	h = safeZoneW * SP_NOTIFICATION_H;

	class Controls {
		class Picture: rscPicture {
			idc = 3;

			x = 0;
			y = 0;
			w = safeZoneH * SP_NOTIFICATION_H * (pixelW / pixelH);
			h = safeZoneH * SP_NOTIFICATION_H;

			text = "x\surface_painter\addons\sp_core\data\notification_green_ca.paa";
		};

		class Text: RscText {
			idc = 4;

			x = safeZoneH * SP_NOTIFICATION_H * (pixelW / pixelH);
			y = 0;
			w = safeZoneW * SP_NOTIFICATION_W - safeZoneH * SP_NOTIFICATION_H * (pixelW / pixelH);
			h = safeZoneH * SP_NOTIFICATION_H;

			text = "notification text";

			colorBackground[] = {0, 0, 0, 1};
		};
	};

	fade = 1;

	class VScrollbar {
		color[] = {0, 0, 0, 0};
		width = 0;
		autoScrollEnabled = 1;
	};

	class HScrollbar {
		color[] = {0, 0, 0, 0};
		height = 0;
	};
};
