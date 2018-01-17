call compile preprocessFileLineNumbers "oo_WebService.sqf";
waitUntil {!isNull(findDisplay 46)};

private _webservice = ["new", "http://localhost:8080/"] call oo_WebService;
private _arr = [
	["action", "update"],
	["table", "users"],
	["id", getPlayerUID player]
];
["putParam", _arr] call _webservice;
private _index = "call" call _webservice;
hint format["Index:%1",_index];
sleep 1;
private _data = ["getStatus", _index] call _webservice;
hint format["Data:%1",_data];