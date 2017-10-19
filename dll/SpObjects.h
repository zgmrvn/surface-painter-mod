/**
----------------------------------------------------------------------------

File: SpObjects.h

System: sp
Status: Version 1.0.0
Language: C++

License: GNU Public License
Author: Hashlych
E-mail: hashlych@gmail.com

Description:
Header file for SpObjects.cpp

----------------------------------------------------------------------------
*/

#ifndef H_SPOBJECTS
#define H_SPOBJECTS

#include <iostream>
#include <string>
#include <sstream>
#include <iomanip>
#include "defines.h"

sSpRet fnc_writeObjects(const char **args, int argsCnt, const int outputFormat = 1);

#endif
