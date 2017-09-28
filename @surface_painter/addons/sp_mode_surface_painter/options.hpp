#include "..\sp_core\sizes.hpp"

class Header: OptionHeader {
	class values {
		class Text: Main {
			typeName = "STRING";
			value = $STR_SP_SURFACE_PAINTER_HEADER;
		};
	};
};

class TitleProject: OptionTitle {
	class Values {
		class Title: Main {
			typeName = "STRING";
			value = $STR_SP_SURFACE_PAINTER_PROJECTS;
		};
	};
};

class Projects: OptionList {
	class Values {
		class List: Main {
			typeName = "LIST";
			value = "";
		};
	};

	height = safeZoneH * SP_OPTION_CONTENT_H * 2;
};

class Reload: OptionButton {
	class values {
		class Text: Main {
			typeName = "STRING";
			value = $STR_SP_SURFACE_PAINTER_RELOAD;
		};
	};
};

class TitleInfos: OptionTitle {
	class Values {
		class Title: Main {
			typeName = "STRING";
			value = $STR_SP_SURFACE_PAINTER_INFOS;
		};
	};
};

class WorldSize: OptionText {
	expose = 1;

	class Values {
		class Text: Main {
			typeName = "STRING";
			value = $STR_SP_SURFACE_PAINTER_WORLD_SIZE;
		};
	};

	margin = SP_OPTION_CONTENT_M_1_6TH;
};

class MaskSize: OptionText {
	expose = 1;
	margin = 0;

	class Values {
		class Text: Main {
			typeName = "STRING";
			value = $STR_SP_SURFACE_PAINTER_MASK_SIZE_NO_PROJECT;
		};
	};
};

class PixelSize: OptionText {
	expose = 1;
	margin = 0;

	class Values {
		class Text: Main {
			typeName = "STRING";
			value = $STR_SP_SURFACE_PAINTER_PIXEL_SIZE_NO_PROJECT;
		};
	};
};

class TitleMask: OptionTitle {
	class Values {
		class Title: Main {
			typeName = "STRING";
			value = $STR_SP_SURFACE_PAINTER_MASK;
		};
	};
};

class MaskColors: OptionList {
	class Values {
		class List: Main {
			typeName = "LIST";
			value = "";
		};
	};
};

class Generate: OptionButton {
	class values {
		class Text: Main {
			typeName = "STRING";
			value = $STR_SP_SURFACE_PAINTER_GENERATE;
		};
	};
};

class Clear: OptionButton {
	class values {
		class Text: Main {
			typeName = "STRING";
			value = $STR_SP_SURFACE_PAINTER_CLEAR;
		};
	};
};
