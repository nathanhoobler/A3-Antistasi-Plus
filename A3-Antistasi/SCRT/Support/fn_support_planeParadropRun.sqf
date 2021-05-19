private _positionOrigin = getMarkerPos supportMarkerOrigin;
private _poisitionDestination = getMarkerPos supportMarkerDestination;

private _angle = [_positionOrigin, _poisitionDestination] call BIS_fnc_dirTo;
private _angleOrigin = _angle - 180;

private _originPosition = [_positionOrigin, 2000, _angleOrigin] call BIS_fnc_relPos;
private _finPosition = [_poisitionDestination, 2000, _angle] call BIS_fnc_relPos;

private _planeData = [_originPosition, _angle, vehSDKPlane, teamPlayer] call A3A_fnc_spawnVehicle;
paradropPlane = _planeData select 0;
private _planeCrew = _planeData select 1;
private _groupPlane = _planeData select 2;

paradropPlane lockDriver true;

clearBackpackCargoGlobal paradropPlane; //people will not accidentially swap their backpacks to parachutes

paradropPlane setPosATL [getPosATL paradropPlane select 0, getPosATL paradropPlane select 1, 1700];
paradropPlane disableAI "TARGET";
paradropPlane disableAI "AUTOTARGET";
paradropPlane flyInHeight 1400;
private _minAltASL = ATLToASL [_positionX select 0, _positionX select 1, 0];
paradropPlane flyInHeightASL [(_minAltASL select 2) +100, (_minAltASL select 2) +100, (_minAltASL select 2) +100];

driver paradropPlane sideChat "Starting paradrop run. Get ready to jump!";
private _wp1 = group paradropPlane addWaypoint [_positionOrigin, 0];
_wp1 setWaypointType "MOVE";
_wp1 setWaypointSpeed "FULL";
_wp1 setWaypointBehaviour "CARELESS";

_wp2 = group paradropPlane addWaypoint [_poisitionDestination, 1];
_wp2 setWaypointSpeed "LIMITED";
_wp2 setWaypointType "MOVE";
_wp2 setWaypointStatements ["true", "private _crew = fullCrew [(vehicle this), 'cargo', false]; {private _unit = _x select 0; moveOut _unit;} forEach _crew;"];

_wp3 = group paradropPlane addWaypoint [_finPosition, 2];
_wp3 setWaypointType "MOVE";
_wp3 setWaypointSpeed "FULL";

publicVariable "paradropPlane";

private _timeOut = time + 600;
waitUntil { sleep 2; (currentWaypoint group paradropPlane == 4) or (time > _timeOut) or !(canMove paradropPlane) };

if !(canMove paradropPlane) then { sleep cleantime };
deleteVehicle paradropPlane;
{deleteVehicle _x} forEach _planeCrew;
deleteGroup _groupPlane;

paradropPlane = nil;
publicVariable "paradropPlane";