/*
    Author: _SCAR, slightly modified to fit Surface Painter needs.
    https://github.com/ostinelli/SCAR_E2TB

    Thank you:
    @Lappihuan @zgmrvn @mikero @W4lly63
    @ianbanks @Ice @cring0 @Adanteh @HorribleGoat @T_D
    ...and all the other folks involved in the discussions in Discord's Arma3 #terrain_makers channel
    in those memorable days of October 18th and 19th 2017.

    LICENSE IS MIT. keep this header if you use it elsewhere.

    Description:
    Generate a string in LBT format.
    There's probably still a gimbal lock that can occasionally be seen. Hopefully you won't.

    Parameter(s):
    0: OBJECT

    Return:
    STRING

    Example:
    _string = _object call SP_fnc_export_objectToLbtFormat
*/

#define DECIMALS 8

// model
private _modelInfo = (getModelInfo _this) select 0;

//  name
private _modelName = (_modelInfo splitString ".") select 0;

// position
private _pos  = getPosATL _this;
private _posX = ((_pos select 0) + 200000); // TB eastern offset
private _posY = (_pos select 1);
private _posZ = (_pos select 2);

// pos
private _up    = vectorUp _this;
private _dir   = vectorDir _this;
private _aside = _dir vectorCrossProduct _up;

// scale
private _scale = (_this getVariable "SP_var_scale");
_up = _up vectorMultiply _scale;
_dir = _dir vectorMultiply _scale;
_aside = _aside vectorMultiply _scale;

// decomp
_up params ["_upX", "_upY", "_upZ"];
_dir params ["_dirX", "_dirY", "_dirZ"];
_aside params ["_asideX", "_asideY", "_asideZ"];

// build line with COLUMN format
private _final = format["%1 %2 %3 %4 %5 %6 %7 %8 %9 %10 %11 %12 0 %13",
    _asideX toFixed DECIMALS, _asideZ toFixed DECIMALS, _asideY toFixed DECIMALS,
    _upX toFixed DECIMALS, _upZ toFixed DECIMALS, _upY toFixed DECIMALS,
    _dirX toFixed DECIMALS, _dirZ toFixed DECIMALS, _dirY toFixed DECIMALS,
    _posX toFixed DECIMALS, _posZ toFixed DECIMALS, _posY toFixed DECIMALS,
    _modelName
];

_final
