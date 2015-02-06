//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_ShermanCannon_M4A3E2 extends DH_ROTankCannon;

defaultproperties
{
    InitialTertiaryAmmo=5
    TertiaryProjectileClass=class'DH_Vehicles.DH_ShermanCannonShellSmoke'
    SecondarySpread=0.001750
    TertiarySpread=0.003600
    ManualRotationsPerSecond=0.016700
    PoweredRotationsPerSecond=0.040000
    FrontArmorFactor=16.600000
    RightArmorFactor=15.200000
    LeftArmorFactor=15.200000
    RearArmorFactor=15.200000
    FrontLeftAngle=320.000000
    FrontRightAngle=40.000000
    RearRightAngle=140.000000
    RearLeftAngle=220.000000
    ReloadSoundOne=sound'DH_Vehicle_Reloads.Reloads.reload_01s_01'
    ReloadSoundTwo=sound'DH_Vehicle_Reloads.Reloads.reload_01s_02'
    ReloadSoundThree=sound'DH_Vehicle_Reloads.Reloads.reload_01s_03'
    ReloadSoundFour=sound'DH_Vehicle_Reloads.Reloads.reload_01s_04'
    CannonFireSound(0)=SoundGroup'DH_AlliedVehicleSounds.75mm.DHM3-75mm'
    CannonFireSound(1)=SoundGroup'DH_AlliedVehicleSounds.75mm.DHM3-75mm'
    CannonFireSound(2)=SoundGroup'DH_AlliedVehicleSounds.75mm.DHM3-75mm'
    ProjectileDescriptions(0)="APCBC"
    ProjectileDescriptions(2)="Smoke"
    AddedPitch=68
    ReloadSound=sound'Vehicle_reloads.Reloads.MG34_ReloadHidden'
    NumAltMags=5
    AltTracerProjectileClass=class'DH_30CalVehicleTracerBullet'
    AltFireTracerFrequency=5
    bUsesTracers=true
    bAltFireTracersOnly=true
    MinCommanderHitHeight=57.0;
    VehHitpoints(0)=(PointRadius=9.000000,PointScale=1.000000,PointBone="com_player",PointOffset=(Z=-2.000000))
    VehHitpoints(1)=(PointRadius=15.000000,PointScale=1.000000,PointBone="com_player",PointOffset=(Z=-24.000000))
    hudAltAmmoIcon=texture'InterfaceArt_tex.HUD.mg42_ammo'
    YawBone="Turret"
    PitchBone="Gun"
    PitchUpLimit=15000
    PitchDownLimit=45000
    WeaponFireAttachmentBone="Gun"
    GunnerAttachmentBone="com_attachment"
    WeaponFireOffset=115.000000
    AltFireOffset=(X=25.000000,Y=-23.000000,Z=3.500000)
    bAmbientAltFireSound=true
    FireInterval=4.200000
    AltFireInterval=0.120000
    EffectEmitterClass=class'ROEffects.TankCannonFireEffect'
    AmbientEffectEmitterClass=class'ROVehicles.TankMGEmitter'
    bAmbientEmitterAltFireOnly=true
    FireSoundVolume=512.000000
    AltFireSoundClass=SoundGroup'DH_AlliedVehicleSounds2.30Cal.V30cal_loop01'
    AltFireSoundScaling=3.000000
    RotateSound=sound'DH_AlliedVehicleSounds.Sherman.ShermanTurretTraverse'
    AltFireEndSound=SoundGroup'DH_AlliedVehicleSounds2.30Cal.V30cal_end01'
    FireForce="Explosion05"
    ProjectileClass=class'DH_Vehicles.DH_ShermanCannonShell'
    AltFireProjectileClass=class'DH_Vehicles.DH_30CalVehicleBullet'
    ShakeRotMag=(Z=50.000000)
    ShakeRotRate=(Z=1000.000000)
    ShakeRotTime=4.000000
    ShakeOffsetMag=(Z=1.000000)
    ShakeOffsetRate=(Z=100.000000)
    ShakeOffsetTime=10.000000
    AltShakeRotMag=(X=0.010000,Y=0.010000,Z=0.010000)
    AltShakeRotRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
    AltShakeRotTime=2.000000
    AltShakeOffsetMag=(X=0.010000,Y=0.010000,Z=0.010000)
    AltShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
    AltShakeOffsetTime=2.000000
    AIInfo(0)=(bLeadTarget=true,WarnTargetPct=0.750000,RefireRate=0.500000)
    AIInfo(1)=(bLeadTarget=true,WarnTargetPct=0.750000,RefireRate=0.015000)
    CustomPitchUpLimit=4551
    CustomPitchDownLimit=63715
    BeginningIdleAnim="Periscope_idle"
    InitialPrimaryAmmo=35
    InitialSecondaryAmmo=50
    InitialAltAmmo=200
    PrimaryProjectileClass=class'DH_Vehicles.DH_ShermanCannonShell'
    SecondaryProjectileClass=class'DH_Vehicles.DH_ShermanCannonShellHE'
    Mesh=SkeletalMesh'DH_ShermanM4A3E2_anm.ShermanM4A3E2_turret_ext'
    SoundVolume=130
    SoundRadius=200.000000
}
