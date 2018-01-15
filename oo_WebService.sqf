#include "oop.h"
CLASS("oo_WebService")
	PUBLIC STATIC_VARIABLE("string", "target");
	PUBLIC VARIABLE("array", "Params");
	PUBLIC VARIABLE("code", "this");

	PUBLIC FUNCTION("string","constructor") { 
		MEMBER("target", _this);
		MEMBER("Params", []);
	};

	PUBLIC FUNCTION("array","putParam") {
		MEMBER("Params", nil) pushBack _this;
	};

	PUBLIC FUNCTION("string","call") {
		private _args = "?action=" + _this;
		{
			_args = _args + "&" + (_x select 0) + "=" + (_x select 1); 
		} forEach MEMBER("Params", nil);
		SPAWN_MEMBER("performRequest", _args);
	};

	PUBLIC FUNCTION("string","performRequest") {
		disableSerialization;
		private _url = MEMBER("target", nil) + _this;
		private _c = (findDisplay 46) ctrlCreate ["RscHTML", -1];
		_c ctrlSetBackgroundColor [0,0,0,0];
		_c ctrlSetPosition[0,0,0,0];
		_c ctrlCommit 0;
		_c htmlLoad _url;
		sleep 2;
		ctrlDelete _c;
	};

ENDCLASS;