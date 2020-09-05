//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_DaimlerCannonPawn extends DHAmericanCannonPawn;

defaultproperties
{
    GunClass=class'DH_Vehicles.DH_DaimlerCannon'

    // Gunsight
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_DaimlerMk1_anm.turret_int',ViewLocation=(X=15,Y=-15,Z=0),ViewFOV=28.33,ViewPitchUpLimit=3641,ViewPitchDownLimit=63716,bDrawOverlays=true)
    // Periscope
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_DaimlerMk1_anm.turret_int',ViewLocation=(X=-8,Y=-33,Z=30),ViewFOV=90.0,TransitionUpAnim="com_open",ViewPitchUpLimit=0,ViewPitchDownLimit=65535,bDrawOverlays=true)
    // Exposed
    DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_DaimlerMk1_anm.turret_int',TransitionDownAnim="com_close",DriverTransitionAnim="VSU76_com_open",ViewPitchUpLimit=10000,ViewPitchDownLimit=62000,ViewPositiveYawLimit=10000,ViewNegativeYawLimit=-10000,bExposed=true) // exposed
    // Binoculars
    DriverPositions(3)=(PositionMesh=SkeletalMesh'DH_DaimlerMk1_anm.turret_int',ViewFOV=12.0,DriverTransitionAnim="stand_idleiron_binoc",ViewPitchUpLimit=10000,ViewPitchDownLimit=62000,ViewPositiveYawLimit=10000,ViewNegativeYawLimit=-10000,bDrawOverlays=true,bExposed=true) // binoculars

    PeriscopePositionIndex=1
    UnbuttonedPositionIndex=2
    RaisedPositionIndex=2
    BinocPositionIndex=3
    bLockCameraDuringTransition=true

    DrivePos=(X=8.0,Y=3.0,Z=-4.5)
    DriveAnim="VSU76_com_idle_close"

    bManualTraverseOnly=true        // TODO: figure out whether or not we have powered rotation

    GunsightOverlay=Texture'DH_VehicleOptics_tex.US.Stuart_sight_background'
    GunsightSize=0.435 // 12.3 degrees visible FOV at 3x magnification (M70D sight)
    DestroyedGunsightOverlay=Texture'DH_VehicleOpticsDestroyed_tex.Allied.Stuart_sight_destroyed'
    AmmoShellTexture=Texture'DH_InterfaceArt_tex.Tank_Hud.StuartShell'
    AmmoShellReloadTexture=Texture'DH_InterfaceArt_tex.Tank_Hud.StuartShell_reload'
    FireImpulse=(X=-30000.0)
    PlayerCameraBone="com_camera"
}

