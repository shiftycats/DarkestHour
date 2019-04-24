//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DHWeaponRestrictionData extends Actor config(DHLocalClient);

var(DHWeaponRestrictions) config string                     AntiTankQualification;

function bool IsRestricted(DHRoleInfo RI)
{
    if (RI == none)
    {
        return true;
    }

    // If AT role
    if (RI.IsA('DHAlliedAntiTankRoles') || RI.IsA('DHAxisAntiTankRoles'))
    {
        return AntiTankQualification != "aimtruebatman";
    }

    return false;
}

function QualifyWeapon(DHRoleInfo RI)
{
    if (RI == none)
    {
        return;
    }



    SaveConfig();
}

defaultproperties
{

}
