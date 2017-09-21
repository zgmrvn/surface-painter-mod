class Header: OptionHeader {
	class values {
		class Text: Main {
			typeName = "STRING";
			value = $STR_SP_EDGE_HEADER;
		};
	};
};

class TitleMode: OptionTitle {
	class Values {
		class Title: Main {
			typeName = "STRING";
			value = $STR_SP_EDGE_TITLE_MODE;
		};
	};
};

class Default: OptionCheckBox {
	class Values {
		class CheckBox: Main {
			typeName = "BOOL";
			value = 1;
		};

		class Text: Second {
			typeName = "STRING";
			value = $STR_SP_EDGE_DEFAULT;
		};
	};
};

class Lower: OptionCheckBox {
	class Values {
		class CheckBox: Main {
			typeName = "BOOL";
			value = 0;
		};

		class Text: Second {
			typeName = "STRING";
			value = $STR_SP_EDGE_LOWER;
		};
	};
};

class Higher: OptionCheckBox {
	class Values {
		class CheckBox: Main {
			typeName = "BOOL";
			value = 0;
		};

		class Text: Second {
			typeName = "STRING";
			value = $STR_SP_EDGE_HIGHER;
		};
	};
};

class Cliff: OptionCheckBox {
	class Values {
		class CheckBox: Main {
			typeName = "BOOL";
			value = 0;
		};

		class Text: Second {
			typeName = "STRING";
			value = $STR_SP_EDGE_CLIFF;
		};
	};
};

class TitlePlacement: OptionTitle {
	class Values {
		class Title: Main {
			typeName = "STRING";
			value = $STR_SP_EDGE_POSITIONING;
		};
	};
};

class Interval: OptionEdit {
	class Values {
		class Edit: Main {
			typeName = "NUMBER";
			value = 10;
		};

		class Text: Second {
			typeName = "STRING";
			value = $STR_SP_EDGE_INTERVAL;
		};
	};
};

class Spread: OptionEdit {
	class Values {
		class Edit: Main {
			typeName = "NUMBER";
			value = 0;
		};

		class Text: Second {
			typeName = "STRING";
			value = $STR_SP_EDGE_SPREAD;
		};
	};
};

class Generate: OptionButton {
	class values {
		class Text: Main {
			typeName = "STRING";
			value = $STR_SP_EDGE_GENERATE;
		};
	};
};
