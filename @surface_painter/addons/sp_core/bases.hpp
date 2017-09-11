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
		color[] = {0, 0, 0, 0};
		width = 0;
		autoScrollEnabled = 0;
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
