#include "..\sp_core\sizes.hpp"

#define SP_POOL_FOLDED_X	(1 - SP_FOLDED_W)
#define SP_POOL_UNFOLDED_X	(1 - SP_UNFOLDED_W)
#define SP_POOL_CONTENT_W	(SP_UNFOLDED_W - SP_MARGIN_X * 2)

#define SP_POOL_SEARCH_H	SP_OPTION_CONTENT_H
#define SP_POOL_RESULT_H	SP_OPTION_CONTENT_H * 10
#define SP_POOL_POOL_H		0.4
#define SP_POOL_SEARCH_Y	SP_OPTION_CONTENT_M
#define SP_POOL_RESULT_Y	(SP_POOL_SEARCH_Y + SP_POOL_SEARCH_H + SP_OPTION_CONTENT_M_1_6TH)
#define SP_POOL_POOL_Y		(SP_POOL_RESULT_Y + SP_POOL_RESULT_H + SP_OPTION_CONTENT_M)

#define SP_POOL_ENTRY_H						0.05
#define SP_POOL_ENTRY_M						pixelH
#define SP_POOL_ENTRY_REMOVE_W				0.1
#define SP_POOL_ENTRY_DISPLAY_NAME_DIVIDER	46
#define SP_POOL_ENTRY_CLASS_NAME_DIVIDER	60
#define SP_POOL_ENTRY_REMOVE_DIVIDER		50