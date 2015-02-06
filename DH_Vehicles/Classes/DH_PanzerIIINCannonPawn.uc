//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_PanzerIIINCannonPawn extends DH_GermanTankCannonPawn;

defaultproperties
{
    ScopeCenterScale=0.635000
    ScopeCenterRotator=TexRotator'DH_VehicleOptics_tex.German.PZ4_sight_Center'
    CenterRotationFactor=985
    OverlayCenterSize=0.780000
    DestroyedScopeOverlay=texture'DH_VehicleOpticsDestroyed_tex.German.PZ4_sight_destroyed'
    bManualTraverseOnly=true
    PoweredRotateSound=sound'Vehicle_Weapons.Turret.manual_turret_traverse'
    PoweredPitchSound=sound'Vehicle_Weapons.Turret.manual_turret_elevate'
    PoweredRotateAndPitchSound=sound'Vehicle_Weapons.Turret.manual_turret_traverse'
    CannonScopeCenter=texture'DH_VehicleOptics_tex.German.PZ3_sight_graticule'
    ScopePositionX=0.237000
    ScopePositionY=0.150000
    WeaponFOV=30.000000
    AmmoShellTexture=texture'DH_InterfaceArt_tex.Tank_Hud.Panzer3shell'
    AmmoShellReloadTexture=texture'DH_InterfaceArt_tex.Tank_Hud.Panzer3shell_reload'
    DriverPositions(0)=(ViewLocation=(X=12.000000,Y=-27.000000,Z=3.000000),ViewFOV=30.000000,PositionMesh=SkeletalMesh'DH_Panzer3_anm.Panzer3n_turret_int',ViewPitchUpLimit=3641,ViewPitchDownLimit=64080,ViewPositiveYawLimit=19000,ViewNegativeYawLimit=-20000,bDrawOverlays=true)
    DriverPositions(1)=(ViewFOV=90.000000,PositionMesh=SkeletalMesh'DH_Panzer3_anm.Panzer3n_turret_int',TransitionUpAnim="com_open",DriverTransitionAnim="VKV1_com_close",ViewPitchUpLimit=5000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=6000,ViewNegativeYawLimit=-10000)
    DriverPositions(2)=(ViewFOV=90.000000,PositionMesh=SkeletalMesh'DH_Panzer3_anm.Panzer3n_turret_int',TransitionDownAnim="com_close",DriverTransitionAnim="VKV1_com_open",ViewPitchUpLimit=5000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=10000,ViewNegativeYawLimit=-10000,bExposed=true)
    DriverPositions(3)=(ViewFOV=12.000000,PositionMesh=SkeletalMesh'DH_Panzer3_anm.Panzer3n_turret_int',ViewPitchUpLimit=5000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=10000,ViewNegativeYawLimit=-10000,bDrawOverlays=true,bExposed=true)
    GunClass=class'DH_Vehicles.DH_PanzerIIINCannon'
    CameraBone="Gun"
    DrivePos=(Z=-6.000000)
    DriveAnim="VKV1_com_idle_close"
    EntryRadius=130.000000
    FPCamPos=(X=50.000000,Y=-30.000000,Z=11.000000)
    TPCamDistance=300.000000
    TPCamLookat=(X=-25.000000,Z=0.000000)
    TPCamWorldOffset=(Z=120.000000)
    PitchUpLimit=6000
    PitchDownLimit=64000
    SoundVolume=130
}
