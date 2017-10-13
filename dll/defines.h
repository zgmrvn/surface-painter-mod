/**
----------------------------------------------------------------------------

File: defines.h

System: sp
Status: Version 1.0.2
Language: C++

License: GNU Public License
Author: Hashlych
E-mail: hashlych@gmail.com

Description:
  Header file for general purpose.
  Used by utilsFnc.cpp and spV2.cpp

----------------------------------------------------------------------------
*/

#ifndef DEFINES_H
#define DEFINES_H

#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <thread>
#include <chrono>

#ifndef FREEIMAGE_LIB
	#define FREEIMAGE_LIB
	#include "FreeImage.h"
#endif


/* Structures declarations */
typedef struct _sColor {		// Store Arma 3 color
	std::string name;
	RGBTRIPLE val;
} sColor;

typedef struct _sProject {		// Store project informations
	std::string name;
	std::string filepath;
	std::vector<sColor> colors;
} sProject;

typedef struct _sSystemState {	// Store system status
	bool fi_initialized;
	bool is_working;
  std::string projects_path;
	std::string project_name;
	std::string ret_str;
	int ret_code;
	std::string exec_duration;
} sSystemState;


#define SP_SUCCESS	1
#define SP_ERR		-1

enum SP_ERRORS {SYSTEM_IS_WORKING = 50, INVALID_PARAMS_COUNT, PROJECT_NOT_FOUND};


/* Functions declarations */
std::vector<std::string> splitStrBy(std::string str, char delimit);
void writeToLog(std::string slog);

#endif
