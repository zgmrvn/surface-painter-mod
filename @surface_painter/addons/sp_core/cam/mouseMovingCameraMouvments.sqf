#define CAMERA_SENS 100

_x	= _this select 1;
_y	= _this select 2;
_xd	= _this select 1;
_yd	= _this select 2;

// extract the previous frame mouse delta data
if ((count SP_var_mouseScreenDelta) != 0) then {
	_xd = SP_var_mouseScreenDelta select 0;
	_yd = SP_var_mouseScreenDelta select 1;
};

// set current mouse position for the next frame delta
//SP_var_mouseScreenDelta = [_x, _y];

// camera direction
SP_var_cameraDir = SP_var_cameraDir + (_x - _xd) * CAMERA_SENS;
SP_var_camera setDir SP_var_cameraDir;

// camera pitch
SP_var_cameraPitch = SP_var_cameraPitch - (_y - _yd) * CAMERA_SENS;
SP_var_cameraPitch = SP_var_cameraPitch max -90 min 90;
[SP_var_camera, SP_var_cameraPitch, 0] call bis_fnc_setpitchbank;
