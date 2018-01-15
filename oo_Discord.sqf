#include "oop.h"

CLASS_EXTENDS("oo_Discord", "oo_WebService")
	PUBLIC FUNCTION("string","constructor") { 
		SUPER("constructor", _this);
	};

	PUBLIC FUNCTION("string","sendGlobal") {
		private _arr = ["steamID", "123"];
		MEMBER("putParam", _arr);
		_arr = ["text", _this];
		MEMBER("putParam", _arr);
		MEMBER("Call", "sendGlobal");
	};
ENDCLASS;
