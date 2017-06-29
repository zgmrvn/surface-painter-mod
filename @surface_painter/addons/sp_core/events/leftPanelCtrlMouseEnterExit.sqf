ctrlShow [SP_SURFACE_PAINTER_LEFT_PANEL_EVENT_EXIT_CTRL, false];

_leftPanelEnterEventCtrl ctrlAddEventHandler ["MouseEnter", {
	systemChat str _this;


	ctrlShow [SP_SURFACE_PAINTER_LEFT_PANEL_EVENT_ENTER_CTRL, false];
	ctrlShow [SP_SURFACE_PAINTER_LEFT_PANEL_EVENT_EXIT_CTRL, true];

	_dialog				= findDisplay SP_SURFACE_PAINTER_IDD;
	_leftPanelCtrlGroup	= _dialog displayCtrl SP_SURFACE_PAINTER_LEFT_PANEL_CTRL_GROUP;
	//_modesBackground	= _dialog displayCtrl SP_SURFACE_PAINTER_MODES_BACKGROUND;
	_optionsBackground	= _dialog displayCtrl SP_SURFACE_PAINTER_OPTIONS_BACKGROUND;

	_leftPanelCtrlGroup ctrlSetPosition [safeZoneX, safeZoneY, safeZoneW * (SP_MODES_W + SP_OPTIONS_W), safeZoneH];
	//_modesBackground ctrlSetPosition [safeZoneX, safeZoneY, safeZoneW * (SP_MODES_W + SP_OPTIONS_W), safeZoneH];
	_optionsBackground ctrlSetPosition [safeZoneX + safeZoneW * SP_FOLDED_W, safeZoneY, safeZoneW * SP_OPTIONS_W, safeZoneH];
	_leftPanelCtrlGroup ctrlCommit 0.1;
	//_modesBackground ctrlCommit 0.1;
	_optionsBackground ctrlCommit 0.1;
}];

_leftPanelExitEventCtrl ctrlAddEventHandler ["MouseEnter", {
	systemChat str _this;

	ctrlShow [SP_SURFACE_PAINTER_LEFT_PANEL_EVENT_EXIT_CTRL, false];
	ctrlShow [SP_SURFACE_PAINTER_LEFT_PANEL_EVENT_ENTER_CTRL, true];

	_dialog						= findDisplay SP_SURFACE_PAINTER_IDD;
	_eventCtrl					= _dialog displayCtrl SP_SURFACE_PAINTER_EVENT_CTRL;
	_leftPanelCtrlGroup			= _dialog displayCtrl SP_SURFACE_PAINTER_LEFT_PANEL_CTRL_GROUP;
	_leftPanelEnterEventCtrl	= _leftPanelCtrlGroup controlsGroupCtrl SP_SURFACE_PAINTER_LEFT_PANEL_EVENT_ENTER_CTRL;
	//_modesBackground			= _dialog displayCtrl SP_SURFACE_PAINTER_MODES_BACKGROUND;
	_optionsBackground	= _dialog displayCtrl SP_SURFACE_PAINTER_OPTIONS_BACKGROUND;

	ctrlSetFocus _leftPanelEnterEventCtrl;
	ctrlSetFocus _eventCtrl;

	_leftPanelCtrlGroup ctrlSetPosition [safeZoneX, safeZoneY, safeZoneW * SP_MODES_W, safeZoneH];
	//_modesBackground ctrlSetPosition [safeZoneX, safeZoneY, safeZoneW * SP_MODES_W, safeZoneH];
	_optionsBackground ctrlSetPosition [safeZoneX + safeZoneW * SP_FOLDED_W, safeZoneY, 0, safeZoneH];
	_leftPanelCtrlGroup ctrlCommit 0.1;
	//_modesBackground ctrlCommit 0.1;
	_optionsBackground ctrlCommit 0.1;
}];
