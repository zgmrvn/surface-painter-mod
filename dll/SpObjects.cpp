/**
----------------------------------------------------------------------------

File: SpObjects.cpp

System: sp
Status: Version 1.0.0
Language: C++

License: GNU Public License
Author: Hashlych
E-mail: hashlych@gmail.com

Description:
Contains functions related to objects export.

----------------------------------------------------------------------------
*/

#include "stdafx.h"
#include "SpObjects.h"

sSystemState sys_state;
std::vector<sProject> projects;
std::vector<std::string> objectsList;


/* Fnc_writeObjects */
sSpRet fnc_writeObjects(const char **args, const int argsCnt, const int outputFormat)
{
  sSpRet ret = { 0, "" };

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
    << (1900 + ltm.tm_year);


  // build filename:
  std::string filename = sys_state.projects_path;

  if (argsCnt == 1) {
    std::string name(args[0]);
    cleanStrFromArma(name);

    if (!name.empty()) {

      sProject *prj = getProjectByName(name);
      if (prj == NULL) {
        ret.code = SP_ERRORS::PROJECT_NOT_FOUND;
        ret.msg = "Project [" + name + "] not found.";

        return ret;
      }
      else
        filename += name + "_";
    }

  }

  filename += sstr_datetime.str();

  if (outputFormat == 1)
    filename += ".txt";
  else if (outputFormat == 2)
    filename += ".lbt";
  else {
    ret.code = SP_ERR;
    ret.msg = "Invalid output format.";

    return ret;
  }



  // open file and write datas:
  std::ofstream out(filename.c_str());

  if (out.bad() || !out.is_open()) {
    ret.code = SP_ERR;
    ret.msg = "Failed to open output file.";
  }
  else {

    std::string before_datas = "objects\n",
      after_datas = "end objects";

    out.write(before_datas.c_str(), before_datas.length());

    // write objects list:
    std::string w_str;
    for (size_t i = 0; i < objectsList.size(); i++) {
      w_str = objectsList[i] + "\n";
      out.write(w_str.c_str(), w_str.length());
    }

    out.write(after_datas.c_str(), after_datas.length());

    out.close();

    std::stringstream sstr;
    sstr << objectsList.size() << " objects wrote into file: " << filename;
    ret.msg = sstr.str();

    objectsList.clear();

    ret.code = SP_SUCCESS;
  }


  return ret;
}