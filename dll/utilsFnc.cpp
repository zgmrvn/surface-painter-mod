/**
----------------------------------------------------------------------------

File: utilsFnc.cpp

System: sp
Status: Version 1.0.0 Release 1
Language: C++

License: GNU Public License
Author: Hashlych
E-mail: hashlych@gmail.com

Description:
  Contains functions for general purpose like function to split a string by given delimiter and such.

----------------------------------------------------------------------------
*/

#include "stdafx.h"
#include "defines.h"


/* splitStrBy */
std::vector<std::string> splitStrBy(std::string str, char delimit)
{
	std::string token_before, token_after;
	std::vector<std::string> ret;
	size_t pos = 0;
	uint16_t i = 1;

	while (!str.empty()) {
		pos = str.find(delimit);

		if (pos != std::string::npos) {
			token_before = str.substr(0, pos);
			ret.push_back(std::string(token_before));

			str.erase(0, pos + 1);
		}
		else {
			token_after = str;
			ret.push_back(std::string(token_after));

			str.clear();
		}
	}

	return ret;
}


/* writeToLog (not used in public release. only for debuging) */
void writeToLog(std::string slog)
{
	std::ofstream out("sp.log", std::ofstream::app);
	if (!out.bad() && out.is_open()) {
		slog += "\n";

		out.write(slog.c_str(), slog.length());
		out.close();
	}
}
