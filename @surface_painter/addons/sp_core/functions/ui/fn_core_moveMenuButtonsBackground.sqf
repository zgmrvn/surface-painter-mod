#include "..\..\idcs.hpp"

private _dialog	= findDisplay SP_IDD;
private _menuControlsGroup = _dialog displayCtrl SP_MENU_CONTROLS_GROUP;
private _modulesControlsGroup = _menuControlsGroup controlsGroupCtrl SP_MODULES_CONTROLS_GROUP;
private _backgroundControl = _modulesControlsGroup controlsGroupCtrl SP_MODULES_BUTTONS_BACKGROUND_CONTROL;

_backgroundControl ctrlSetPosition _this;
_backgroundControl ctrlCommit 0.1;
