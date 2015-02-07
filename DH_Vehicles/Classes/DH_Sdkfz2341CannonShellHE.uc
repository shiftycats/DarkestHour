//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_Sdkfz2341CannonShellHE extends DH_ROTankCannonShellHE;

defaultproperties
{
    MechanicalRanges(1)=(Range=100,RangeValue=33.000000)
    MechanicalRanges(2)=(Range=200,RangeValue=37.000000)
    MechanicalRanges(3)=(Range=300,RangeValue=41.000000)
    MechanicalRanges(4)=(Range=400,RangeValue=48.000000)
    MechanicalRanges(5)=(Range=500,RangeValue=56.000000)
    MechanicalRanges(6)=(Range=600,RangeValue=64.000000)
    MechanicalRanges(7)=(Range=700,RangeValue=76.000000)
    MechanicalRanges(8)=(Range=800,RangeValue=87.000000)
    MechanicalRanges(9)=(Range=900,RangeValue=97.000000)
    MechanicalRanges(10)=(Range=1000,RangeValue=109.000000)
    MechanicalRanges(11)=(Range=1100,RangeValue=122.000000)
    MechanicalRanges(12)=(Range=1200,RangeValue=131.000000)
    bMechanicalAiming=true
    DHPenetrationTable(0)=1.900000
    DHPenetrationTable(1)=1.600000
    DHPenetrationTable(2)=1.300000
    DHPenetrationTable(3)=1.100000
    DHPenetrationTable(4)=0.900000
    DHPenetrationTable(5)=0.500000
    DHPenetrationTable(6)=0.300000
    DHPenetrationTable(7)=0.100000
    ShellDiameter=2.000000
    bIsAlliedShell=false
    BlurTime=2.000000
    BlurEffectScalar=0.900000
    PenetrationMag=110.000000
    ShellImpactDamage=class'DH_Vehicles.DH_Sdkfz2341CannonShellDamageAP'
    ImpactDamage=125
    VehicleHitSound=SoundGroup'ProjectileSounds.Bullets.PTRD_penetrate'
    ShellHitDirtEffectClass=class'ROEffects.TankHEHitDirtEffect'
    ShellHitSnowEffectClass=class'ROEffects.TankHEHitSnowEffect'
    ShellHitWoodEffectClass=class'ROEffects.TankHEHitWoodEffect'
    ShellHitRockEffectClass=class'ROEffects.TankHEHitRockEffect'
    ShellHitWaterEffectClass=class'ROEffects.TankHEHitWaterEffect'
    AmbientVolumeScale=2.000000
    BallisticCoefficient=0.770000
    SpeedFudgeScale=0.750000
    Speed=47075.000000
    MaxSpeed=47075.000000
    Damage=110.000000
    MyDamageType=class'DH_Vehicles.DH_Sdkfz2341CannonShellDamageHE'
    ExplosionDecal=class'ROEffects.GrenadeMark'
    ExplosionDecalSnow=class'ROEffects.GrenadeMarkSnow'
    StaticMesh=StaticMesh'EffectsSM.Weapons.Ger_Tracer'
    AmbientSound=SoundGroup'DH_ProjectileSounds.Bullets.Bullet_Whiz'
    Tag="Sprgr.39"
    SoundRadius=350.000000
    TransientSoundRadius=600.000000
}
