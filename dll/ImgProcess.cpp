/**
----------------------------------------------------------------------------

File: ImgProcess.cpp

System: sp
Status: Version 1.0.1
Language: C++

License: GNU Public License
Author: Hashlych
E-mail: hashlych@gmail.com

Description:
  Image process functions such as pixel color manipulation, save image etc.

----------------------------------------------------------------------------
*/

#include "stdafx.h"
#include "ImgProcess.h"


/* readImageInfos */
int readImageInfos(const char *filepath, sInfos &infos)
{
	// Determine image type:
	FREE_IMAGE_FORMAT fif = FIF_UNKNOWN;
	fif = FreeImage_GetFileType(filepath, 0);

	if (fif == FIF_UNKNOWN)
		fif = FreeImage_GetFIFFromFilename(filepath);

	infos.fif = fif;


	int ret = 0;
	
	if (fif != FIF_UNKNOWN && FreeImage_FIFSupportsReading(fif)) {
		infos.is_supported = true;

		FIBITMAP *dib = FreeImage_Load(fif, filepath, FIF_LOAD_NOPIXELS);

		if (dib) {
			infos.w = FreeImage_GetWidth(dib);
			infos.h = FreeImage_GetHeight(dib);
			infos.bpp = FreeImage_GetBPP(dib);			
			infos.cl_type = FreeImage_GetColorType(dib);
			
			FreeImage_Unload(dib);
			ret = IMGPROCESS_SUCCESS;
		}
		else
			ret = IMGPROCESS_ERRORS::FAILED_LOAD;
	}
	else {
		infos.is_supported = false;
		ret = IMGPROCESS_ERRORS::UNSUPPORTED_FORMAT;
	}

	
	return ret;
}


/* imageExists */
int imageExists(const char *filepath)
{
	std::ifstream input(filepath, std::ifstream::in);

	if (input.bad() || !input.is_open())
		return IMGPROCESS_ERRORS::FAILED_OPEN;

	input.close();

	return IMGPROCESS_SUCCESS;
}


// Check image layers cfg presence:
int checkImageLayers(const char *prj_name, sSystemState &sys_state)
{
	std::string fname = prj_name + std::string(".cfg");

	// Init and open file:
	std::string path = sys_state.projects_path + fname;
	std::ifstream input(path);

	if (input.bad() || !input.is_open())
		return IMGPROCESS_ERRORS::FAILED_OPEN;

	input.close();

	return IMGPROCESS_SUCCESS;
}


// Read Image color layers cfg and retrieve colors list:
int readImageLayers(const char *prj_name, sSystemState &sys_state, std::vector<sColor> &colors)
{
	std::string fname = prj_name + std::string(".cfg");

	// Init and open file:
	std::string path = sys_state.projects_path + fname;
	std::ifstream input(path);

	if (input.bad() || !input.is_open())
		return IMGPROCESS_ERRORS::FAILED_OPEN;

	
	// Setup regex patterns:
	std::regex pattern_line(R"(\s*([a-zA-Z0-9_]+)\[\]\s*=\s*)");
	std::regex pattern_cl(R"(\{(\d{1,3}),\s*(\d{1,3}),\s*(\d{1,3})\})");
	std::regex pattern_cl_name(R"(_)");
	std::string cl_name_replacement = " ";

	std::string line, cl_name;
	std::smatch match, match_cl;
	int red = 0, green = 0, blue = 0;

	// Search and indexes:
	while (std::getline(input, line)) {
		if (std::regex_search(line, match, pattern_line) == false)
			continue;

		if (std::regex_search(line, match_cl, pattern_cl)) {
			cl_name = std::regex_replace(match[1].str(), pattern_cl_name, cl_name_replacement);

			red = atoi(match_cl[1].str().c_str());
			green = atoi(match_cl[2].str().c_str());
			blue = atoi(match_cl[3].str().c_str());

			colors.push_back({ cl_name,{ (BYTE)blue,(BYTE)green,(BYTE)red } });
		}

	}

	input.close();

	return IMGPROCESS_SUCCESS;
}


/* imgConvertTo8bit */
int imgConvertTo8bit(const char *filepath)
{
	sInfos infos;
	int ret = 0;
	if ((ret = readImageInfos(filepath, infos)) != IMGPROCESS_SUCCESS)
		return ret;

	
	// Is image valid for opening:
	if (infos.fif == FIF_UNKNOWN || !infos.is_supported)
		return IMGPROCESS_ERRORS::UNSUPPORTED_FORMAT;


	// If not 24/32-bit: stop
	if (infos.bpp != 24 && infos.bpp != 32)
		return IMGPROCESS_CONVERT_ERRORS::BAD_BPP;

	
	// Try opening and loading source image:
	FIBITMAP *dib = FreeImage_Load(infos.fif, filepath);
	if (!dib)
		return IMGPROCESS_CONVERT_ERRORS::FAILED_LOAD_SOURCE;
	

	// Conversion process
	// First try with Fast algo.
	// On fail: try 2nd algo.
	FIBITMAP *dib_8b = FreeImage_ColorQuantize(dib, FIQ_LFPQUANT);	// Lossless Fast Pseudo-Quantization Algorithm by Carsten Klein
	
	bool convert_failed = false;
	if (!dib_8b) {
		if (infos.bpp != 24)
			convert_failed = true;
		else {
			dib_8b = FreeImage_ColorQuantize(dib, FIQ_NNQUANT);	// NeuQuant neural-net quantization algorithm by Anthony Dekker (24-bit only)

			if (!dib_8b)
				convert_failed = true;
		}
	}

	FreeImage_Unload(dib);	// Unload previously loaded source image

	if (convert_failed)
		return IMGPROCESS_CONVERT_ERRORS::FAILED_COLOR_QUANTIZE;


	// Conversion: ok. Save image.
	ret = 0;
	if (FreeImage_Save(FIF_TIFF, dib_8b, filepath, TIFF_LZW))
		ret = IMGPROCESS_SUCCESS;
	else
		ret = IMGPROCESS_ERRORS::FAILED_SAVE;


	FreeImage_Unload(dib_8b); // Unload previously loaded dest image
	
	return ret;
}



/* applyModifs */
int applyModifs(sProject &prj, std::vector<sPxModif> &modifs, sSystemState &sys_state)
{
	sInfos infos;
	const char *filepath = prj.filepath.c_str(),
		*prjname = prj.name.c_str();
	int ret = 0;

	if ((ret = readImageInfos(filepath, infos)) != IMGPROCESS_SUCCESS)
		return ret;


	// Test if conversion to 8-bit needed:
	if (infos.bpp != 8) {
		int ret = imgConvertTo8bit(filepath);

		if (ret != IMGPROCESS_SUCCESS) {
			switch (ret) {
			case IMGPROCESS_CONVERT_ERRORS::BAD_BPP:
			case IMGPROCESS_CONVERT_ERRORS::FAILED_COLOR_QUANTIZE:
				return IMGPROCESS_CONVERT_ERRORS::FAILED_CONVERT;
				break;
			default:
				return ret;
				break;
			}

		}
	}


	// Try opening and loading image:
	FIBITMAP *dib = FreeImage_Load(infos.fif, filepath);
	if (!dib)
		return IMGPROCESS_ERRORS::FAILED_LOAD;


	// Compare colors listed in the layers configuration file
	// to the colors used in the image.
	// If color is missing, add to the palette.
	std::vector<RGBTRIPLE> img_colors;
	std::vector<sColor> layers_colors;

	determineUniqueColors(dib, img_colors);		// colors used in the image
	readImageLayers(prjname, sys_state, layers_colors);	// colors indexed in the layers cfg file

	int free_index = img_colors.size();
	RGBQUAD *palette = FreeImage_GetPalette(dib);

	bool color_found;
	
	
	for (size_t n = 0; n < layers_colors.size(); n++) {
		
		color_found = false;
		for (size_t i = 0; i < free_index; i++) {
			if (layers_colors[n].val.rgbtRed == palette[i].rgbRed
				&& layers_colors[n].val.rgbtGreen == palette[i].rgbGreen
				&& layers_colors[n].val.rgbtBlue == palette[i].rgbBlue) {
				color_found = true;
				break;
			}
		}

		// color not found: adding
		if (!color_found) {

			if (free_index < 255) {
				palette[free_index].rgbRed = layers_colors[n].val.rgbtRed;
				palette[free_index].rgbGreen = layers_colors[n].val.rgbtGreen;
				palette[free_index].rgbBlue = layers_colors[n].val.rgbtBlue;

				free_index++;
			}
		}

	}


	// Apply pixels modifications:
	int color_index = 0;
	for (size_t n = 0; n < modifs.size(); n++) {

		// test if valid pixel position:
		if (modifs[n].x > infos.w || modifs[n].y > infos.h)
			continue;

		// determine color index:
		for (int i = 0; i <= 255; i++) {
			if (palette[i].rgbRed == modifs[n].color.rgbtRed
				&& palette[i].rgbGreen == modifs[n].color.rgbtGreen
				&& palette[i].rgbBlue == modifs[n].color.rgbtBlue) {
				color_index = i;
				break;
			}
		}


		// apply color to pixel (x,y):
		BYTE *bits = FreeImage_GetScanLine(dib, modifs[n].y);
		bits[modifs[n].x] = color_index;
	}


	// Try to save image:
	ret = 0;
	if (FreeImage_Save(FIF_TIFF, dib, filepath, TIFF_LZW)) {
		modifs.clear();
		ret = IMGPROCESS_SUCCESS;
	}
	else
		ret = IMGPROCESS_ERRORS::FAILED_SAVE;
	
	FreeImage_Unload(dib);	// Unload previously loaded image
	return ret;
}


/* addPixelModif */
void addPixelModif(std::string source_str, std::vector<sPxModif> &modifs)
{
	int x = 0, y = 0;
	uint16_t r = 0, g = 0, b = 0;

	std::vector<std::string> strs = splitStrBy(source_str, '|');

	if (strs.size() == 2) {

		std::vector<std::string> grp_xy = splitStrBy(strs[0], ';');
		if (grp_xy.size() == 2) {
			x = atoi(grp_xy[0].c_str());
			y = atoi(grp_xy[1].c_str());
		}


		std::vector<std::string> grp_color = splitStrBy(strs[1], ';');

		if (grp_color.size() == 3) {
			r = atoi(grp_color[0].c_str());
			g = atoi(grp_color[1].c_str()),
			b = atoi(grp_color[2].c_str());

			RGBTRIPLE cl = { (BYTE)b,(BYTE)g,(BYTE)r };
			modifs.push_back({ (uint32_t)x, (uint32_t)y, cl });
		}
	}
}




/* getUniqueColorsFromLines */
std::vector<RGBTRIPLE> getUniqueColorsFromLines(FIBITMAP *dib, int start_line, int nb_lines)
{
	std::vector<RGBTRIPLE> colors;

	if (dib) {
		int bpp = FreeImage_GetBPP(dib),
			width = FreeImage_GetWidth(dib),
			height = FreeImage_GetHeight(dib);
		int bytespp = 0;
		RGBQUAD *palette = NULL;

		if (bpp == 24 || bpp == 32) {
			bytespp = FreeImage_GetLine(dib) / FreeImage_GetWidth(dib);
		}
		else if (bpp == 8) {
			bytespp = 1;
			palette = FreeImage_GetPalette(dib);
		}
		else
			return colors;

		
		if (start_line < height) {

			for (int y = 0; y < nb_lines; y++) {

				BYTE *bits = FreeImage_GetScanLine(dib, (start_line + y));

				bool fnd = false;

				for (int x = 0; x < width; x++) {
					fnd = false;
					RGBTRIPLE cl = { 0,0,0 };

					if (bpp == 24 || bpp == 32) {
						cl.rgbtRed = bits[FI_RGBA_RED];
						cl.rgbtGreen = bits[FI_RGBA_GREEN];
						cl.rgbtBlue = bits[FI_RGBA_BLUE];
					}
					else if (bpp == 8) {
						int idx = bits[x];
						cl.rgbtRed = palette[idx].rgbRed;
						cl.rgbtGreen = palette[idx].rgbGreen;
						cl.rgbtBlue = palette[idx].rgbBlue;
					}


					for (int n = 0; n < colors.size(); n++) {

						if (colors[n].rgbtRed == cl.rgbtRed
							&& colors[n].rgbtGreen == cl.rgbtGreen
							&& colors[n].rgbtBlue == cl.rgbtBlue) {
							fnd = true;
							break;
						}

					}

					if (!fnd) {
						colors.push_back(cl);
					}

					if (bpp == 24 || bpp == 32)
						bits += bytespp;
				}
			}

		}
	}

	return colors;
}



/* determineUniqueColors */
void determineUniqueColors(FIBITMAP *dib, std::vector<RGBTRIPLE> &fn_colors) {
	if (dib) {
		int height = FreeImage_GetHeight(dib);
		int nb_lines = height / 4,
			reste = height % 4;

		int start_line = 0;

		std::vector<std::vector<RGBTRIPLE>> tb_colors;

		for (int i = 0; i < 4; i++) {
			std::vector<RGBTRIPLE> colors = getUniqueColorsFromLines(dib, start_line, nb_lines);
			tb_colors.push_back(colors);
			start_line += nb_lines;
		}

		if (reste != 0) {
			start_line += nb_lines;
			std::vector<RGBTRIPLE> colors = getUniqueColorsFromLines(dib, start_line, reste);
			tb_colors.push_back(colors);
		}


		bool fnd;

		for (int n = 0; n < tb_colors.size(); n++) {

			for (int o = 0; o < tb_colors[n].size(); o++) {
				fnd = false;

				for (int p = 0; p < fn_colors.size(); p++) {
					if (tb_colors[n][o].rgbtRed == fn_colors[p].rgbtRed
						&& tb_colors[n][o].rgbtGreen == fn_colors[p].rgbtGreen
						&& tb_colors[n][o].rgbtBlue == fn_colors[p].rgbtBlue) {
						fnd = true;
						break;
					}
				}

				if (!fnd)
					fn_colors.push_back(tb_colors[n][o]);
			}
		}


	}
}