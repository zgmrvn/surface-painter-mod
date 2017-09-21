class Header: OptionHeader {
	class Values {
		class Text: Main {
			typeName = "STRING";
			value = $STR_SP_BRUSH_HEADER;
		};
	};
};

class TitlePlacement: OptionTitle {
	class Values {
		class Title: Main {
			typeName = "STRING";
			value = $STR_SP_BRUSH_POSITIONING;
		};
	};
};

class Distance: OptionEdit {
	class Values {
		class Edit: Main {
			typeName = "NUMBER";
			value = 0;
		};

		class Text: Second {
			typeName = "STRING";
			value = $STR_SP_BRUSH_DISTANCE_BETWEEN_OBJECTS;
		};
	};
};

class Flow: OptionEdit {
	class Values {
		class Edit: Main {
			typeName = "NUMBER";
			value = 20;
		};

		class Text: Second {
			typeName = "STRING";
			value = $STR_SP_BRUSH_FLOW;
		};
	};
};
