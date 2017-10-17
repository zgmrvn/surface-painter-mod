/**
----------------------------------------------------------------------------

File: ImgProcess.h

System: sp
Status: Version 1.0.2
Language: C++

License: GNU Public License
Author: Hashlych
E-mail: hashlych@gmail.com

Description:
  Header file for ImgProcess.cpp

----------------------------------------------------------------------------
*/

#ifndef IMGPROCESS_H
#define IMGPROCESS_H

#include <iostream>
#include <vector>
#include <fstream>
#include <sstream>
#include <regex>

#ifndef FREEIMAGE_LIB
	#define FREEIMAGE_LIB
	#include "FreeImage.h"
#endif

#include "defines.h"


#define IMGPROCESS_SUCCESS	1

enum IMGPROCESS_ERRORS { FAILED_SAVE = 20, FAILED_LOAD, UNSUPPORTED_FORMAT, FAILED_OPEN};
enum IMGPROCESS_CONVERT_ERRORS {NOT_24BIT = 10, BAD_BPP, FAILED_CONVERT, FAILED_LOAD_SOURCE, FAILED_COLOR_QUANTIZE};



typedef struct _sPxModif {		// Store pixel modification
	uint32_t x;
	uint32_t y;
	RGBTRIPLE color;
} sPxModif;

typedef struct _sInfos {		// Store image infos
	uint32_t w;
	uint32_t h;
	uint16_t bpp;
	bool is_supported;
	FREE_IMAGE_FORMAT fif;
	FREE_IMAGE_COLOR_TYPE cl_type;
} sInfos;


/* Functions declarations */
int readImageInfos(const char *filepath, sInfos &infos);
int imageExists(const char *filepath);

int checkImageLayers(const char *prj_name, sSystemState &sys_state);
int readImageLayers(const char *prj_name, sSystemState &sys_state, std::vector<sColor> &colors);

int imgConvertTo8bit(const char *filepath);

int applyModifs(sProject &prj, std::vector<sPxModif> &modifs, sSystemState &sys_state);
void addPixelModif(std::string source_str, std::vector<sPxModif> &modifs);

std::vector<RGBTRIPLE> getUniqueColorsFromLines(FIBITMAP *dib, int start_line, int nb_lines);
void determineUniqueColors(FIBITMAP *dib, std::vector<RGBTRIPLE> &fn_colors);

#endif
