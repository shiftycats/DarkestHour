//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHAirplane extends Actor
    abstract;

var localized string    AirplaneName;

// TODO: we're pretty much just gonna use these for effects and/or hitboxes
var array<name> PropellerBones;
var array<name> CockbitBones;

defaultproperties
{
    DrawType=DT_Mesh
    AirplaneName="Airplane"
    PropellerBones(0)="propeller"
    CockbitBones(0)="cockpit"
}

