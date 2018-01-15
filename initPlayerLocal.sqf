call compile preprocessFileLineNumbers "oo_WebService.sqf";
call compile preprocessFileLineNumbers "oo_Discord.sqf";
waitUntil {!isNull(findDisplay 46)};


private _discord = ["new", "http://localhost:8080/"] call oo_Discord;
["sendGlobal","Hello world!"] call _discord;