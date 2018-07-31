//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DH_FJCombatEngineer extends DHGEEngineerRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=class'DH_GerPlayers.DH_GermanFJPawn',Weight=1.0)
    Headgear(0)=class'DH_GerPlayers.DH_FJHelmetCamoOne'
    Headgear(1)=class'DH_GerPlayers.DH_FJHelmetCamoTwo'
    Headgear(2)=class'DH_GerPlayers.DH_FJHelmetNetOne'
    HeadgearProbabilities(0)=0.33
    HeadgearProbabilities(1)=0.33
    HeadgearProbabilities(2)=0.33
    SleeveTexture=Texture'DHGermanCharactersTex.GerSleeves.FJ_Sleeve'
}
