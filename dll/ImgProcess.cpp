/**
----------------------------------------------------------------------------

File: ImgProcess.cpp

System: sp
Status: Version 1.0.1 Release 1
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

	
	if (fif != FIF_UNKNOWN && FreeImage_FIFSupportsReading(fif)) {
		FIBITMAP *dib = FreeImage_Load(fif, filepath, FIF_LOAD_NOPIXELS);

		if (dib) {
			infos.w = FreeImage_GetWidth(dib);
			infos.h = FreeImage_GetHeight(dib);
			infos.bpp = FreeImage_GetBPP(dib);
			infos.cl_type = FreeImage_GetColorType(dib);

			FreeImage_Unload(dib);
			return IMGPROCESS_SUCCESS;
		}
		else
			return IMGPROCESS_ERRORS::FAILED_LOAD;
	}
	else
		return IMGPROCESS_ERRORS::UNSUPPORTED_FORMAT;

	return 0;
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
	std::string path = sys_state.masks_path + fname;
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
	std::string path = sys_state.masks_path + fname;
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


/* imgConvert24To8bit */
int imgConvert24To8bit(const char *filepath)
{
	// Determine image type:
	FREE_IMAGE_FORMAT fif = FIF_UNKNOWN;
	fif = FreeImage_GetFileType(filepath, 0);

	if (fif == FIF_UNKNOWN)
		fif = FreeImage_GetFIFFromFilename(filepath);

	
	if (fif != FIF_UNKNOWN && FreeImage_FIFSupportsReading(fif)) {
		FIBITMAP *dib = FreeImage_Load(fif, filepath);

		if (dib) {
			sInfos infos = { FreeImage_GetWidth(dib), FreeImage_GetHeight(dib),
				FreeImage_GetBPP(dib), FreeImage_GetColorType(dib) };

			if (infos.bpp != 24) {
				FreeImage_Unload(dib);
				return IMGPROCESS_CONVERT_ERRORS::NOT_24BIT;
			}


			FIBITMAP *dib_8b = FreeImage_ColorQuantizeEx(dib, FIQ_LFPQUANT, 256, 0, NULL);
			FreeImage_Unload(dib);

			if (dib_8b) {
				if (FreeImage_Save(FIF_TIFF, dib_8b, filepath, TIFF_LZW)) {
					FreeImage_Unload(dib_8b);
					return IMGPROCESS_SUCCESS;
				}
				else
					return IMGPROCESS_ERRORS::FAILED_SAVE;
			}
			else
				return IMGPROCESS_CONVERT_ERRORS::FAILED_COLOR_QUANTIZE;


		}
		else
			return IMGPROCESS_CONVERT_ERRORS::FAILED_LOAD_SOURCE;
	}
	else
		return IMGPROCESS_ERRORS::UNSUPPORTED_FORMAT;

	return 0;
}


/* imgConvert32To8bit */
int imgConvert32To8bit(const char *filepath)
{
	// Determine image type:
	FREE_IMAGE_FORMAT fif = FIF_UNKNOWN;
	fif = FreeImage_GetFileType(filepath, 0);

	if (fif == FIF_UNKNOWN)
		fif = FreeImage_GetFIFFromFilename(filepath);


	if (fif != FIF_UNKNOWN && FreeImage_FIFSupportsReading(fif)) {
		FIBITMAP *dib = FreeImage_Load(fif, filepath);

		if (dib) {
			sInfos infos = { FreeImage_GetWidth(dib), FreeImage_GetHeight(dib),
				FreeImage_GetBPP(dib), FreeImage_GetColorType(dib) };

			if (infos.bpp != 32) {
				FreeImage_Unload(dib);
				return IMGPROCESS_CONVERT_ERRORS::NOT_32BIT;
			}


			FIBITMAP *dib_8b = FreeImage_ColorQuantize(dib, FIQ_LFPQUANT);
			FreeImage_Unload(dib);

			if (dib_8b) {
				if (FreeImage_Save(FIF_TIFF, dib_8b, filepath, TIFF_LZW)) {
					FreeImage_Unload(dib_8b);
					return IMGPROCESS_SUCCESS;
				}
				else
					return IMGPROCESS_ERRORS::FAILED_SAVE;
			}
			else
				return IMGPROCESS_CONVERT_ERRORS::FAILED_COLOR_QUANTIZE;


		}
		else
			return IMGPROCESS_CONVERT_ERRORS::FAILED_LOAD_SOURCE;
	}
	else
		return IMGPROCESS_ERRORS::UNSUPPORTED_FORMAT;

	return 0;
}





/* applyModifs */
int applyModifs(sProject &prj, std::vector<sPxModif> &modifs, sSystemState &sys_state)
{
	// Determine image type:
	const char *filepath = prj.filepath.c_str();
	FREE_IMAGE_FORMAT fif = FIF_UNKNOWN;

	fif = FreeImage_GetFileType(filepath, 0);

	if (fif == FIF_UNKNOWN)
		fif = FreeImage_GetFIFFromFilename(filepath);

	if (fif != FIF_UNKNOWN && FreeImage_FIFSupportsReading(fif)) {
		FIBITMAP *dib = FreeImage_Load(fif, filepath);

		if (dib) {
			uint32_t width = FreeImage_GetWidth(dib),
				height = FreeImage_GetHeight(dib);
			uint16_t bpp = FreeImage_GetBPP(dib);

			if (bpp != 8) {
				FreeImage_Unload(dib);

				int ret;
				if (bpp == 24)
					ret = imgConvert24To8bit(filepath);
				else if (bpp == 32)
					ret = imgConvert32To8bit(filepath);
				else
					ret = IMGPROCESS_ERRORS::UNSUPPORTED_FORMAT;

				if (ret != IMGPROCESS_SUCCESS) {
					if (ret == IMGPROCESS_CONVERT_ERRORS::NOT_24BIT || ret == IMGPROCESS_CONVERT_ERRORS::NOT_32BIT
						|| ret == IMGPROCESS_CONVERT_ERRORS::FAILED_COLOR_QUANTIZE)
						return IMGPROCESS_CONVERT_ERRORS::FAILED_CONVERT;
					else
						return ret;
				}
				else {
					dib = FreeImage_Load(fif, filepath);
					if (!dib)
						return IMGPROCESS_ERRORS::FAILED_LOAD;
				}
			}


			std::vector<RGBTRIPLE> fn_colors;
			determineUniqueColors(dib, fn_colors);

			int free_index = fn_colors.size();

			RGBQUAD *palette = FreeImage_GetPalette(dib);

			
			for (size_t n = 0; n < modifs.size(); n++) {
				sPxModif pxm = modifs[n];

				if (pxm.x > width || pxm.y > height)
					break;


				int cl_index = 0;
				bool cl_fnd = false;

				cl_fnd = false;
				for (cl_index = 0; cl_index <= 255; cl_index++) {
					if (palette[cl_index].rgbRed == pxm.color.rgbtRed
						&& palette[cl_index].rgbGreen == pxm.color.rgbtGreen
						&& palette[cl_index].rgbBlue == pxm.color.rgbtBlue) {
						cl_fnd = true;
						break;
					}
				}

				BYTE *bits = FreeImage_GetScanLine(dib, pxm.y);

				if (cl_fnd) {
					bits[pxm.x] = cl_index;
				}
				else {
					palette[free_index].rgbRed = pxm.color.rgbtRed;
					palette[free_index].rgbGreen = pxm.color.rgbtGreen;
					palette[free_index].rgbBlue = pxm.color.rgbtBlue;
					
					bits[pxm.x] = free_index;

					free_index++;
				}
			}


			int ret = 0;

			if (FreeImage_Save(FIF_TIFF, dib, filepath, TIFF_LZW)) {
				ret = IMGPROCESS_SUCCESS;
			}
			else {
				ret = IMGPROCESS_ERRORS::FAILED_SAVE;
			}

			FreeImage_Unload(dib);
			return ret;
		}
		else
			return IMGPROCESS_ERRORS::FAILED_LOAD;

	}
	else
		return IMGPROCESS_ERRORS::UNSUPPORTED_FORMAT;

	return 0;
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