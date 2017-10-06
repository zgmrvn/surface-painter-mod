// parent class for background controls
class MenuBackground: RscText {
	idc = -1;
	type = CT_STATIC;

	x = safeZoneX;
	y = safeZoneY;
	w = safeZoneW;
	h = safeZoneH;

	colorBackground[] = {0.1, 0.1, 0.1, 0.8};
};

// parent class for panels
// the left panel with mode and mode options use this class
class PanelControlsGroup: RscControlsGroup {
	idc = -1;

	x = safeZoneX;
	y = safeZoneY * SP_MARGIN_Y;
	w = safeZoneW;
	h = safeZoneH;

	class VScrollbar {
		arrowEmpty = "\A3\ui_f\data\gui\cfg\scrollbar\arrowEmpty_ca.paa";
		arrowFull = "\A3\ui_f\data\gui\cfg\scrollbar\arrowFull_ca.paa";
		autoScrollDelay = 5;
		autoScrollEnabled = 1;
		autoScrollRewind = 0;
		autoScrollSpeed = -1;
		border = "\A3\ui_f\data\gui\cfg\scrollbar\border_ca.paa";
		color[] = {1,1,1,1};
		colorActive[] = {1,1,1,1};
		colorDisabled[] = {1,1,1,0.3};
		height = 0;
		scrollSpeed = 0.06;
		shadow = 0;
		thumb = "\A3\ui_f\data\gui\cfg\scrollbar\thumb_ca.paa";
		width = 0.021;
	};

	class HScrollbar {
		color[] = {0, 0, 0, 0};
		height = 0;
	};
};

// parent class for controls responsible of mouse hover panel detection
class PanelEventCheckBox: RscCheckBox {
	idc = -1;

	x = safeZoneX;
	y = safeZoneY;
	w = safeZoneW;
	h = safeZoneH;

	color[] = {0, 0, 0, 0};
	colorFocused[] = {0, 0, 0, 0};
	colorHover[] = {0, 0, 0, 0};
	colorPressed[] = {0, 0, 0, 0};
	colorDisabled[] = {0, 0, 0, 0};
	colorBackgroundDisabled[] = {0, 0, 0, 0};

	textureChecked = "";
	textureUnchecked = "";
	textureFocusedChecked = "";
	textureFocusedUnchecked = "";
	textureHoverChecked = "";
	textureHoverUnchecked = "";
	texturePressedChecked = "";
	texturePressedUnchecked = "";
	textureDisabledChecked = "";
	textureDisabledUnchecked = "";
};

// mode button
class ModeButton: RscControlsGroup {
	idc = -1;

	x = 0;
	y = 0;
	w = safeZoneW * SP_MODES_W;
	h = safeZoneH * SP_MODES_H;

	class Controls {
		class Background: RscText {
			idc = 3;

			x = 0;
			y = 0;
			w = safeZoneW * SP_MODES_W;
			h = safeZoneH * SP_MODES_H;

			text = "";
			sizeEx = 0;
			colorBackground[] = {0, 0, 0, 0};
		};

		class Icon: RscPicture {
			idc = 4;

			x = 0;
			y = 0;
			w = safeZoneW * SP_MODES_W;
			h = safeZoneH * SP_MODES_H;

			text = "";
		};

		class Event: RscListBox {
			idc = 5;

			x = 0;
			y = 0;
			w = safeZoneW * SP_MODES_W;
			h = safeZoneH * SP_MODES_H;

			colorBackground[] = {0, 0, 0, 0};
			itemSpacing = 0;
			text = "";
			rowHeight = 0;
		};
	};
};
