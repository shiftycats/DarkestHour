//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2020
//==============================================================================

class DH_RKKA_StandardAssaultLate extends DH_RKKA_StandardAssaultEarly;

defaultproperties
{

    RolePawns(0)=(PawnClass=class'DH_SovietPlayers.DH_SovietTunicBackpackLatePawn',Weight=2.0)
    RolePawns(1)=(PawnClass=class'DH_SovietPlayers.DH_SovietTunicLatePawn',Weight=1.0)
	
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_PPSH41Weapon',AssociatedAttachment=class'ROInventory.ROPPSh41AmmoPouch')
    PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_PPS43Weapon',AssociatedAttachment=class'ROInventory.ROPPS43AmmoPouch')
    PrimaryWeapons(2)=(Item=class'DH_Weapons.DH_PPSH41_stickWeapon',AssociatedAttachment=class'ROInventory.ROPPS43AmmoPouch')
}
