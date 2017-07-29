[] spawn {
	SP_fnc_core_addAction				= compile preprocessFileLineNumbers "x\surface_painter\addons\sp_core\functions\actions\fn_core_addAction.sqf";
	SP_fnc_core_createSimpleObject		= compile preprocessFileLineNumbers "x\surface_painter\addons\sp_core\functions\objects\fn_core_createSimpleObject.sqf";
	SP_fnc_core_createEditOption		= compile preprocessFileLineNumbers "x\surface_painter\addons\sp_core\functions\options\fn_core_createEditOption.sqf";
	SP_fnc_core_createButtonOption		= compile preprocessFileLineNumbers "x\surface_painter\addons\sp_core\functions\options\fn_core_createButtonOption.sqf";
	SP_fnc_core_createCheckBoxOption	= compile preprocessFileLineNumbers "x\surface_painter\addons\sp_core\functions\options\fn_core_createCheckBoxOption.sqf";
	SP_fnc_core_createHeaderOption		= compile preprocessFileLineNumbers "x\surface_painter\addons\sp_core\functions\options\fn_core_createHeaderOption.sqf";
	SP_fnc_core_createTextOption		= compile preprocessFileLineNumbers "x\surface_painter\addons\sp_core\functions\options\fn_core_createTextOption.sqf";
	SP_fnc_core_createComboOption		= compile preprocessFileLineNumbers "x\surface_painter\addons\sp_core\functions\options\fn_core_createComboOption.sqf";
	SP_fnc_core_createListOption		= compile preprocessFileLineNumbers "x\surface_painter\addons\sp_core\functions\options\fn_core_createListOption.sqf";

	// brush
	SP_fnc_brush_init			= compile preprocessFileLineNumbers "x\surface_painter\addons\sp_mode_brush\events\fn_Brush_init.sqf";
	SP_fnc_brush_Down			= compile preprocessFileLineNumbers "x\surface_painter\addons\sp_mode_brush\events\fn_Brush_Down.sqf";
	SP_fnc_brush_Up				= compile preprocessFileLineNumbers "x\surface_painter\addons\sp_mode_brush\events\fn_Brush_Up.sqf";

	// edge
	SP_fnc_edge_init		= compile preprocessFileLineNumbers "x\surface_painter\addons\sp_mode_edge\events\fn_edge_init.sqf";
	SP_fnc_edge_activate	= compile preprocessFileLineNumbers "x\surface_painter\addons\sp_mode_edge\events\fn_edge_activate.sqf";
	SP_fnc_edge_desactivate	= compile preprocessFileLineNumbers "x\surface_painter\addons\sp_mode_edge\events\fn_edge_desactivate.sqf";
	SP_fnc_edge_mouseMove	= compile preprocessFileLineNumbers "x\surface_painter\addons\sp_mode_edge\events\fn_edge_mouseMove.sqf";
	SP_fnc_edge_down		= compile preprocessFileLineNumbers "x\surface_painter\addons\sp_mode_edge\events\fn_edge_down.sqf";

	SP_fnc_edge_findEdge	= compile preprocessFileLineNumbers "x\surface_painter\addons\sp_mode_edge\functions\fn_edge_findEdge.sqf";
	SP_fnc_edge_generate	= compile preprocessFileLineNumbers "x\surface_painter\addons\sp_mode_edge\functions\fn_edge_generate.sqf";
	SP_fnc_edge_regenerate	= compile preprocessFileLineNumbers "x\surface_painter\addons\sp_mode_edge\functions\fn_edge_regenerate.sqf";

	// surface painter
	SP_fnc_surfacePainter_init		= compile preprocessFileLineNumbers "x\surface_painter\addons\sp_mode_surface_painter\events\fn_surfacePainter_init.sqf";
	SP_fnc_surfacePainter_down		= compile preprocessFileLineNumbers "x\surface_painter\addons\sp_mode_surface_painter\events\fn_surfacePainter_down.sqf";
	SP_fnc_surfacePainter_up		= compile preprocessFileLineNumbers "x\surface_painter\addons\sp_mode_surface_painter\events\fn_surfacePainter_up.sqf";
	SP_fnc_surfacePainter_mouseMove	= compile preprocessFileLineNumbers "x\surface_painter\addons\sp_mode_surface_painter\events\fn_surfacePainter_mouseMove.sqf";

	SP_fnc_surfacePainter_paint			= compile preprocessFileLineNumbers "x\surface_painter\addons\sp_mode_surface_painter\functions\fn_surfacePainter_paint.sqf";
	SP_fnc_surfacePainter_hexToDecColor	= compile preprocessFileLineNumbers "x\surface_painter\addons\sp_mode_surface_painter\functions\fn_surfacePainter_hexToDecColor.sqf";

	// circle
	SP_fnc_circle_init			= compile preprocessFileLineNumbers "x\surface_painter\addons\sp_tool_circle\events\fn_circle_init.sqf";
	SP_fnc_circle_activate		= compile preprocessFileLineNumbers "x\surface_painter\addons\sp_tool_circle\events\fn_circle_activate.sqf";
	SP_fnc_circle_desactivate	= compile preprocessFileLineNumbers "x\surface_painter\addons\sp_tool_circle\events\fn_circle_desactivate.sqf";
	SP_fnc_circle_zChange		= compile preprocessFileLineNumbers "x\surface_painter\addons\sp_tool_circle\events\fn_circle_zChange.sqf";

	// export
	SP_fnc_export_init	= compile preprocessFileLineNumbers "x\surface_painter\addons\sp_extra_export\events\fn_export_init.sqf";

	SP_fnc_export_exportTerrainBuilder = compile preprocessFileLineNumbers "x\surface_painter\addons\sp_extra_export\functions\fn_export_exportTerrainBuilder.sqf";

	// pool
	SP_fnc_pool_init	= compile preprocessFileLineNumbers "x\surface_painter\addons\sp_tool_pool\events\fn_pool_init.sqf";

	SP_fnc_pool_generatePool	= compile preprocessFileLineNumbers "x\surface_painter\addons\sp_tool_pool\functions\fn_pool_generatePool.sqf";

	systemChat "functions compiled";
};
