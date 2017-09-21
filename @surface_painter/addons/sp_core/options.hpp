#include "sizes.hpp"

class OptionBase {
	rsc = "HeaderBase";
	expose = 0;
	margin = 0;
};

// options types
class OptionHeader: OptionBase {
	rsc = "HeaderBase";
	expose = 0;
};

class OptionTitle: OptionBase {
	rsc = "TitleBase";
	expose = 0;
	margin = SP_OPTION_CONTENT_M;
};

class OptionEdit: OptionBase {
	rsc = "EditBase";
	expose = 1;
	margin = SP_OPTION_CONTENT_M_1_6TH;
};

class OptionButton: OptionBase {
	rsc = "ButtonBase";
	expose = 1;
	margin = SP_OPTION_CONTENT_M;
};

class OptionCheckBox: OptionBase {
	rsc = "CheckBoxBase";
	expose = 1;
	margin = SP_OPTION_CONTENT_M_1_6TH;
};

class OptionText: OptionBase {
	rsc = "TextBase";
	expose = 0;
	margin = SP_OPTION_CONTENT_M_1_6TH;
};

class OptionList: OptionBase {
	rsc = "ListBoxBase";
	expose = 1;
	margin = SP_OPTION_CONTENT_M_1_6TH;
};

// options rsc
// usually the main control, the one with data
class Main {
	idc = 3;
};

// usually a description text
class Second {
	idc = 4;
};
