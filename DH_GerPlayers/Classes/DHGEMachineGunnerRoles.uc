//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2020
//==============================================================================

class DHGEMachineGunnerRoles extends DHAxisMachineGunnerRoles
    abstract;

defaultproperties
{
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_MG42Weapon')
    PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_MG34Weapon')
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_P38Weapon')
    SecondaryWeapons(1)=(Item=class'DH_Weapons.DH_P08LugerWeapon')
    HeadgearProbabilities(0)=0.2
    HeadgearProbabilities(1)=0.8
}
