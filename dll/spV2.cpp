/**
----------------------------------------------------------------------------

File: spV2.cpp

System: sp
Status: Version 1.0.1
Language: C++

License: GNU Public License
Author: Hashlych
E-mail: hashlych@gmail.com

Description: 
  DLL entry point.
  Contains the 3 functions Arma 3 calls from in-game callExtension function.

  - RVExtensionVersion
  - RVExtension
  - RVExtensionArgs

----------------------------------------------------------------------------
*/

#include "stdafx.h"
#include <iostream>
#include <iomanip>    // std::fill, std::setw
#include <fstream>		// std::ifstream & ofstream
#include <sstream>		// std::stringstream
#include <string>
#include <vector>
#include <regex>
#include <Windows.h>	// DllMain & GetModuleHandleExA
#include <thread>
#include "dirent.h"		// Directory manipulations (linux adaptation)
#include <ctime>      // time, localtime

#define FREEIMAGE_LIB
#include "FreeImage.h"

#include "defines.h"
#include "ImgProcess.h"


// DLL version for Arma 3 log:
#define CURRENT_VERSION "1.0.1"


/* Global variables */
sSystemState sys_state;
std::vector<sProject> projects;
std::vector<sPxModif> modifs;
std::vector<std::string> objectsList;


/* Functions declarations */
bool initModule();
bool deInitModule();

void buildMasksPath();
void buildMasksDir();

void scanForProjects();
sProject* getProjectByName(std::string name);

void cleanStrFromArma(std::string &str);

void fnc_applyModifs(const char **args, int argsCnt);


// DLL entry point:
BOOL APIENTRY DllMain(HMODULE hModule,
	DWORD  ul_reason_for_call,
	LPVOID lpReserved
)
{
	switch (ul_reason_for_call)
	{
	case DLL_PROCESS_ATTACH:
		initModule();
		break;

	case DLL_THREAD_ATTACH:
		break;

	case DLL_THREAD_DETACH:
		break;

	case DLL_PROCESS_DETACH:
		deInitModule();
		break;
	}

	return TRUE;
}


// Arma 3 mandatory functions:
extern "C"
{
	__declspec(dllexport) void __stdcall RVExtensionVersion(char *output, int outputSize);
	__declspec(dllexport) void __stdcall RVExtension(char *output, int outputSize, const char *function);
	__declspec(dllexport) int __stdcall RVExtensionArgs(char *output, int outputSize, const char *function, const char **args, int argsCnt);
}





// Mandatory function. Handles FreeImage initialization and some other init.
bool initModule()
{
	if (sys_state.fi_initialized == true) return false;

	FreeImage_Initialise();

	buildMasksPath();
	buildMasksDir();

	sys_state.fi_initialized = true;
	sys_state.project_name = "";
	sys_state.ret_code = 0;
	sys_state.ret_str = "";

	return true;
}


// Mandatory function. Handles FreeImage de-initialization and some other de-init.
bool deInitModule()
{
	if (sys_state.fi_initialized == false
		|| sys_state.is_working == true) return false;

	FreeImage_DeInitialise();
	
	sys_state.fi_initialized = false;

	return true;
}


// Build masks path base on DLL path:
void buildMasksPath()
{
	HMODULE hm = NULL;
	char dllpath[MAX_PATH];

	GetModuleHandleExA(GET_MODULE_HANDLE_EX_FLAG_FROM_ADDRESS |
		GET_MODULE_HANDLE_EX_FLAG_UNCHANGED_REFCOUNT, (LPCSTR)&initModule, &hm);
	GetModuleFileNameA(hm, dllpath, MAX_PATH);


	std::string path(dllpath);
	size_t pos = path.find("sp.dll"), lgt = std::string("sp.dll").length();

	if (pos == std::string::npos) {
		pos = path.find("sp_x64.dll");
		lgt = std::string("sp_x64.dll").length();
	}

	if (pos != std::string::npos) {
		path.erase(pos, lgt);
		sys_state.masks_path = path + "masks\\";
	}
}


// Build masks directory if required:
void buildMasksDir()
{
	DIR *dr;
	const char *masks_path = sys_state.masks_path.c_str();

	// If directory doesn't exists: create it
	if ((dr = opendir(masks_path)) == NULL) {
		std::wstring wide_string = std::wstring(sys_state.masks_path.begin(), sys_state.masks_path.end());
		const wchar_t *pth = wide_string.c_str();

		CreateDirectory(pth, NULL);
	}
	else
		closedir(dr);
}


// Scan masks directory and index projects:
void scanForProjects()
{
	DIR *dr;
	struct dirent *ent;
	const char *masks_path = sys_state.masks_path.c_str();

	
	// Open directory and list valid image files (TIFF):
	if ((dr = opendir(masks_path)) != NULL) {

		std::regex fname_reg(R"(([a-zA-Z0-9_\-]+)\.(tif|TIF|tiff|TIFF))");	// To extract project name

		std::string fname, project_name, file_path;
		size_t pos = 0;

		projects.clear();

		while ((ent = readdir(dr)) != NULL) {

			std::smatch match;
			fname = ent->d_name;

			if (fname.compare(".") == 0 || fname.compare("..") == 0)
				continue;

			if (std::regex_search(fname, match, fname_reg)) {
				project_name = match[1].str();

				if (checkImageLayers(project_name.c_str(), sys_state) == IMGPROCESS_SUCCESS) {
					file_path = sys_state.masks_path + fname;
					projects.push_back({ project_name, file_path });
				}
			}

		}

		closedir(dr);
	}

}


// Return a project based on given name or NULL if not found:
sProject* getProjectByName(std::string name)
{
	for (size_t i = 0; i < projects.size(); i++) {
		if (projects[i].name.compare(name) == 0)
			return &projects[i];
	}

	return NULL;
}


// Cleaning because of Arma 3:
void cleanStrFromArma(std::string &str)
{
	if (str[0] == '"') {
		str.erase(0, 1);
		str.erase(str.length() - 1, 1);
	}
}





/* RVExtensionVersion */
void __stdcall RVExtensionVersion(char *output, int outputSize)
{
	snprintf(output, outputSize, "%s", CURRENT_VERSION);
}


/* RVExtension */
void __stdcall RVExtension(char *output, int outputSize, const char *function)
{
	std::string sfunc(function);
	std::string str;

	
	// callExtension "scanForProjects"
	if (sfunc.compare("scanForProjects") == 0) {
		if (sys_state.fi_initialized) {
			scanForProjects();

			for (uint16_t n = 0; n < projects.size(); n++) {
				str += projects[n].name + "|";
			}
		}
		else
			str = "Module not initialized.";

		snprintf(output, outputSize, "%s", str.c_str());
		return;
	}
  // callExtension "clearObjects"
  else if (sfunc.compare("clearObjects") == 0) {
    objectsList.clear();
    str = "Objects list cleared.";
  }
  else
    str = "Function [" + sfunc + "] not recongnized.";
}



/* fnc_applyModifs */
void fnc_applyModifs(const char **args, int argsCnt)
{
	auto start_time = std::chrono::high_resolution_clock::now();	// exec_duration

	int ret_code = 0;
	std::string str;

	sys_state.is_working = true;
	sys_state.ret_code = 0;

	if (argsCnt != 1) {
		str = "Expected 1 parameter (project name).";
		ret_code = SP_ERRORS::INVALID_PARAMS_COUNT;
	}
	else {
		std::string name(args[0]);
		cleanStrFromArma(name);

		sProject *prj = getProjectByName(name);
		if (prj == NULL) {
			str = "Project [" + name + "] not found.";
			ret_code = SP_ERRORS::PROJECT_NOT_FOUND;
		}
		else {
			sys_state.project_name = name;
			int ret;

			if ((ret = applyModifs(*prj, modifs, sys_state)) == IMGPROCESS_SUCCESS) {
				modifs.clear();
				str = "Modifications saved.";
				ret_code = SP_SUCCESS;
			}
			else {
				ret_code = ret;
				switch (ret) {
				case IMGPROCESS_ERRORS::UNSUPPORTED_FORMAT:
					str = "Unsupported image format.";
					break;
				case IMGPROCESS_ERRORS::FAILED_LOAD:
				case IMGPROCESS_CONVERT_ERRORS::FAILED_LOAD_SOURCE:
					str = "Failed to load image.";
					ret_code = IMGPROCESS_ERRORS::FAILED_LOAD;
					break;
				case IMGPROCESS_ERRORS::FAILED_SAVE:
					str = "Failed to save image.";
					break;
				case IMGPROCESS_CONVERT_ERRORS::FAILED_CONVERT:
					str = "Failed to convert to 8-bit.";
					break;
				default:
					str = "Unknown error.";
					break;
				}
			}
		}
	}

	sys_state.ret_str = str;
	sys_state.ret_code = ret_code;
	sys_state.is_working = false;

	auto end_time = std::chrono::high_resolution_clock::now();	// exec_duration
	std::stringstream exec_duration;

	exec_duration << std::chrono::duration_cast<std::chrono::seconds>(end_time - start_time).count() << "s";
	
	sys_state.exec_duration = std::string(exec_duration.str());
}


/* RVExtensionArgs */
int __stdcall RVExtensionArgs(char *output, int outputSize, const char *function, const char **args, int argsCnt)
{
	std::string sfunc(function);
	std::string str;
	int ret_code = 0;


	// callExtension ["addModifs",[...]]
	if (sfunc.compare("addModifs") == 0) {
		if (argsCnt == 0) {
			str = "Expected 1 parameter at least.";
			ret_code = SP_ERRORS::INVALID_PARAMS_COUNT;
		}
		else {
			for (int i = 0; i < argsCnt; i++) {
				std::string tmp_arg = args[i];
				cleanStrFromArma(tmp_arg);

				addPixelModif(tmp_arg, modifs);
			}

			char nb_modifs[16];
			_itoa_s(modifs.size(), nb_modifs, 10);

			str = std::string(nb_modifs) + " modifications added.";
			ret_code = SP_SUCCESS;
		}

		snprintf(output, outputSize, "%s", str.c_str());
		return ret_code;
	}


	// callExtension ["applyModifs",["project_name"]]
	if (sfunc.compare("applyModifs") == 0) {
		
		if (sys_state.is_working) {
			str = "System is already performing a task on project [" + sys_state.project_name + "]. Please retry later.";
			ret_code = SP_ERR;
		}
		else {
			//fnc_applyModifs(args, argsCnt);
			std::thread th(fnc_applyModifs, args, argsCnt);

			if (th.joinable()) {
				th.detach();
				str = "Task started for project [" + sys_state.project_name + "].";
				ret_code = SP_SUCCESS;
			}
			else {
				str = "Failed to start the task. (Thread is not joinable)";
				ret_code = SP_ERR;
			}
			
		}
		
		snprintf(output, outputSize, "%s", str.c_str());
		return ret_code;
	}


	// callExtension "checkTaskDone"
	if (sfunc.compare("checkTaskDone") == 0) {

		if (sys_state.is_working) {
			str = "System is performing a task on project [" + sys_state.project_name + "].";
			ret_code = 2;
		}
		else {
			if (sys_state.project_name.empty()) {
				str = "System is not performing a task.";
				ret_code = 3;
			}
			else {
				std::stringstream tmp_str;
				tmp_str << "[" << sys_state.project_name << "] Task done: ("
					<< sys_state.ret_code << ") " << sys_state.ret_str
					<< " (spent: " << sys_state.exec_duration << ")";

				str = tmp_str.str();

				sys_state.project_name = "";
				ret_code = sys_state.ret_code;
				sys_state.exec_duration.clear();
			}

		}

		snprintf(output, outputSize, "%s", str.c_str());
		return ret_code;
	}


	// callExtension ["getWidth",["project_name"]]
	if (sfunc.compare("getWidth") == 0) {
		if (argsCnt != 1) {
			str = "Expected 1 parameter (project name).";
			ret_code = SP_ERRORS::INVALID_PARAMS_COUNT;
		}
		else {
			std::string name(args[0]);
			cleanStrFromArma(name);

			sProject *prj = getProjectByName(name);
			if (prj == NULL) {
				str = "Project [" + name + "] not found.";
				ret_code = SP_ERR;
			}
			else {
				int ret;
				sInfos infos;
				if ((ret = readImageInfos(prj->filepath.c_str(), infos)) == IMGPROCESS_SUCCESS) {
					char width[8];
					_itoa_s(infos.w, width, 10);
					str = width;
					ret_code = SP_SUCCESS;
				}
				else {
					ret_code = SP_ERR;
					switch (ret) {
					case IMGPROCESS_ERRORS::UNSUPPORTED_FORMAT:
						str = "Unsupported format.";
						break;
					case IMGPROCESS_ERRORS::FAILED_LOAD:
						str = "Failed to load image.";
						break;
					default:
						str = "Unknown error.";
						break;
					}
				}
			}

		}

		snprintf(output, outputSize, "%s", str.c_str());
		return ret_code;
	}


	// callExtension ["getColors",["project_name"]]
	if (sfunc.compare("getColors") == 0) {
		if (argsCnt != 1) {
			str = "Expected 1 parameter (project name).";
			ret_code = SP_ERRORS::INVALID_PARAMS_COUNT;
		}
		else {
			std::string name(args[0]);
			cleanStrFromArma(name);

			sProject *prj = getProjectByName(name);
			if (prj == NULL) {
				str = "Project [" + name + "] not found.";
				ret_code = SP_ERR;
			}
			else {

				int ret;
				std::vector<sColor> colors;

				if ((ret = readImageLayers(prj->name.c_str(), sys_state, colors)) == IMGPROCESS_SUCCESS) {
					for (size_t i = 0; i < colors.size(); i++) {
						std::stringstream tmp_str;
						tmp_str << colors[i].name << ";"
							<< (uint32_t)colors[i].val.rgbtRed << ":"
							<< (uint32_t)colors[i].val.rgbtGreen << ":"
							<< (uint32_t)colors[i].val.rgbtBlue << "|";
						str += tmp_str.str();
					}
					ret_code = SP_SUCCESS;
				}
				else {
					ret_code = SP_ERR;
					switch (ret) {
					case IMGPROCESS_ERRORS::FAILED_OPEN:
						str = "Layers configuration file not found or cannot be open.";
						break;
					default:
						str = "Unknown error.";
						break;
					}
				}

			}
		}

		snprintf(output, outputSize, "%s", str.c_str());
		return ret_code;
	}


	// callExtension ["imageExists",["project_name"]]
	if (sfunc.compare("imageExists") == 0) {
		if (argsCnt != 1) {
			str = "Expected 1 parameter (project name).";
			ret_code = SP_ERRORS::INVALID_PARAMS_COUNT;
		}
		else {
			std::string name(args[0]);
			cleanStrFromArma(name);

			sProject *prj = getProjectByName(name);
			if (prj == NULL) {
				str = "Project [" + name + "] not found.";
				ret_code = SP_ERR;
			}
			else {
				int ret;
				if ((ret = imageExists(prj->filepath.c_str())) == IMGPROCESS_SUCCESS) {
					str = "Image found.";
					ret_code = SP_SUCCESS;
				}
				else {
					ret_code = SP_ERR;
					switch (ret) {
					case IMGPROCESS_ERRORS::FAILED_OPEN:
						str = "Image not found or cannot be open.";
						break;
					default:
						str = "Unknown error.";
						break;
					}
				}
			}

		}

		snprintf(output, outputSize, "%s", str.c_str());
		return ret_code;
	}


  // callExtension ["pushObjects",[...]]:
  if (sfunc.compare("pushObjects") == 0) {
    if (argsCnt == 0) {
      str = "Expected 1 parameter at least.";
      ret_code = SP_ERRORS::INVALID_PARAMS_COUNT;
    }
    else {

      uint32_t nb_added = 0;

      for (size_t i = 0; i < argsCnt; i++) {
        std::string arg(args[i]);
        cleanStrFromArma(arg);

        std::vector<std::string> ar = splitStrBy(arg, ';');
        if (ar.size() >= 1) {
          cleanStrFromArma(ar[0]);
        }

        std::string f_arg;
        for (size_t o = 0; o < ar.size(); o++) {
          f_arg += ar[o] + ";";
        }

        objectsList.push_back(f_arg);
        nb_added++;
      }

      std::stringstream sstr;
      sstr << nb_added << " objects added.";
      str = sstr.str();

      ret_code = SP_SUCCESS;
    }


    snprintf(output, outputSize, "%s", str.c_str());
    return ret_code;
  }


  // callExtension ["writeObjects",[project_name]]:
  if (sfunc.compare("writeObjects") == 0) {
    
    // build current datetime string:
    time_t now = time(0);
    struct tm ltm;
    localtime_s(&ltm, &now);

    std::stringstream sstr_datetime;

    sstr_datetime << std::setfill('0') << std::setw(2) << ltm.tm_hour << "-"
      << std::setfill('0') << std::setw(2) << ltm.tm_min << "-"
      << std::setfill('0') << std::setw(2) << ltm.tm_sec << "_"
      << std::setfill('0') << std::setw(2) << ltm.tm_mday << "-"
      << std::setfill('0') << std::setw(2) << (ltm.tm_mon + 1) << "-"
      << (1900 + ltm.tm_year) << ".txt";


    // build filename:
    std::string filename = sys_state.projects_path;

    if (argsCnt == 1) {
      std::string name(args[0]);
      cleanStrFromArma(name);

      if (!name.empty()) {
        
        sProject *prj = getProjectByName(name);
        if (prj == NULL) {
          str = "Project [" + name + "] not found.";
          ret_code = SP_ERR;

          snprintf(output, outputSize, "%s", str.c_str());
          return ret_code;
        }
        else
          filename += name + "_";
      }

    }

    filename += sstr_datetime.str();
    

    // open file and write datas:
    std::ofstream out(filename.c_str());

    if (out.bad() || !out.is_open()) {
      str = "Failed to opened destination file: " + filename;
      ret_code = SP_ERR;
    }
    else {

      std::string w_str;
      for (size_t i = 0; i < objectsList.size(); i++) {
        w_str = objectsList[i] + "\n";
        out.write(w_str.c_str(), w_str.length());
      }

      out.close();

      std::stringstream sstr;
      sstr << objectsList.size() << " objects wrote into file: " << filename;
      str = sstr.str();

      objectsList.clear();

      ret_code = SP_SUCCESS;
    }


    snprintf(output, outputSize, "%s", str.c_str());
    return ret_code;
  }


	return 0;
}
