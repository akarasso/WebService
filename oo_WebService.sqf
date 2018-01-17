#include "oop.h"
CLASS("oo_WebService")

	PUBLIC STATIC_VARIABLE("string", "target");

	PUBLIC VARIABLE("code", "this");
	PUBLIC VARIABLE("array", "Params");
	PUBLIC VARIABLE("array", "Status");
	PUBLIC VARIABLE("scalar", "Index"); //Index of request
	PUBLIC VARIABLE("scalar", "KeepInMemory"); //Time to keep in memory
	PUBLIC VARIABLE("scalar", "TimeOut"); //Timeout request

	PUBLIC FUNCTION("string","constructor") { 
		MEMBER("target", _this);
		MEMBER("Params", []);
		MEMBER("Status", []);
		MEMBER("Index", 0);
		MEMBER("KeepInMemory", 600);
		MEMBER("TimeOut", 10);
		SPAWN_MEMBER("clear", nil);
	};

	/*
	*	Push param
	*	@input:array of many param || array with 1 param
	*		0:Key
	*		1:Value
	*/
	PUBLIC FUNCTION("array","putParam") {
		if (_this isEqualTypeParams []) exitWith {
			{
				MEMBER("Params", nil) pushBack _x;
			} forEach _this;
		};
		MEMBER("Params", nil) pushBack _this;
	};

	/*
	*	Build request
	*/
	PUBLIC FUNCTION("","call") {
		private _argsString = "";
		{
			if (_forEachIndex isEqualTo 0) then {
				_argsString = _argsString + "?" + (_x select 0) + "=" + (_x select 1); 
			}else{
				_argsString = _argsString + "&" + (_x select 0) + "=" + (_x select 1);
			};
		} forEach MEMBER("Params", nil);
		MEMBER("Params", []);
		_index = MEMBER("Index", nil);
		MOD_VAR("Index", 1); 
		private _arr = [_index, _argsString];
		SPAWN_MEMBER("makeRequest", _arr);
		_index;
	};

	/*
	*	Do Request
	*/
	PUBLIC FUNCTION("array","makeRequest") {
		disableSerialization;
		private _url = MEMBER("target", nil) + (_this select 1);
		private _c = (findDisplay 46) ctrlCreate ["RscHTML", -1];
		_c ctrlSetBackgroundColor [0,0,0,0];
		_c ctrlSetPosition[0,0,0,0];
		_c ctrlCommit 0;
		_c htmlLoad _url;
		_start = diag_tickTime;
		private _arr = [(_this select 0), "waiting", _start];
		MEMBER("setStatus", _arr);
		waitUntil {sleep 0.1; (ctrlHTMLLoaded _c || (diag_tickTime - _start) > MEMBER("TimeOut", nil))};
		if (ctrlHTMLLoaded _c) then {
			_arr = [(_this select 0), "complete", diag_tickTime];
		}else{
			_arr = [(_this select 0), "timeout", diag_tickTime];
		};
		MEMBER("setStatus", _arr);
		ctrlDelete _c;
	};

	PUBLIC FUNCTION("array","setStatus") {
		MEMBER("Status", nil) set [_this select 0, [_this select 1, _this select 2]];
	};

	/*
	*	Get status of request
	*	@input:scalar index of request
	*	@return:array [string "waiting"/"complete"/"timeout"/"undefine", exec diag_tickTime]
	*/
	PUBLIC FUNCTION("scalar","getStatus") {
		if (count MEMBER("Status", nil) > _this) exitWith {
			MEMBER("Status", nil) select _this;
		};
		["undefined", -1];
	};


	/*
	*	Clear old request from history...
	*/
	PUBLIC FUNCTION("","clear") {
		while {true} do {
			private _status = MEMBER("Status", nil);
			private _time = diag_tickTime;
			private _timeToKeep = MEMBER("KeepInMemory", nil);
			private _range = [];
			{
				if (_time - (_x select 1) < _timeToKeep) exitWith {};
				if ((count _range) isEqualTo 0) then {
					_range pushBack 0;
					_range set[1, _forEachIndex+1];
				}else{
					_range set[1, _forEachIndex];
				};
			} forEach _status;
			if!(_range isEqualTo []) then {
				_status deleteRange _range;
				MEMBER("Status", _status);
			};
			sleep 60;
		}; 		
	};

	PUBLIC FUNCTION("","getKeepInMemory") {
		MEMBER("KeepInMemory", nil);
	};
	PUBLIC FUNCTION("scalar","setKeepInMemory") {
		MEMBER("KeepInMemory", _this);
	};
	PUBLIC FUNCTION("","getTimeOut") {
		MEMBER("TimeOut", nil);
	};
	PUBLIC FUNCTION("scalar","setTimeOut") {
		MEMBER("TimeOut", _this);
	};
ENDCLASS;