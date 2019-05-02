//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_SatchelDamType extends DHThrowableExplosiveDamageType
    abstract;

defaultproperties
{
    WeaponClass=class'DH_Weapons.DH_SatchelCharge10lb10sWeapon'
    HUDIcon=Texture'InterfaceArt_tex.deathicons.satchel'

    VehicleDamageModifier=1.25
    APCDamageModifier=1.0
    TankDamageModifier=0.8
    TreadDamageModifier=1.8

    GibModifier=4.0
    KDamageImpulse=5000.0
    KDeathVel=300.0
    KDeathUpKick=75.0
    KDeadLinZVelScale=0.0015
    KDeadAngVelScale=0.0015
    HumanObliterationThreshhold=400
}
