call compile preprocessFileLineNumbers "oo_WebService.sqf";
waitUntil {!isNull(findDisplay 46)};

private _webservice = ["new", "http://localhost:8080/"] call oo_WebService;
private _arr = [
	["action", "update"],
	["table", "users"],
	["id", getPlayerUID]
];
["putParam", _arr] call _webservice;
"call" _webservice;