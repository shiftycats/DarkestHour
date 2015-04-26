//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_JagdpanzerIVL70CannonPawn extends DH_JagdpanzerIVCannonPawn;

defaultproperties
{
    AmmoShellTexture=texture'InterfaceArt_tex.Tank_Hud.Panthershell'
    AmmoShellReloadTexture=texture'InterfaceArt_tex.Tank_Hud.Panthershell_reload'
    DriverPositions(0)=(ViewLocation=(X=-20.0,Y=-30.0,Z=25.0),ViewFOV=14.4,PositionMesh=SkeletalMesh'DH_Jagdpanzer4_anm.Jagdpanzer4L70_turret_int',TransitionUpAnim="Overlay_In",ViewPitchUpLimit=2731,ViewPitchDownLimit=64653,ViewPositiveYawLimit=1820,ViewNegativeYawLimit=-1820,bDrawOverlays=true)
    DriverPositions(1)=(ViewFOV=90.0,PositionMesh=SkeletalMesh'DH_Jagdpanzer4_anm.Jagdpanzer4L70_turret_int',TransitionUpAnim="com_open",DriverTransitionAnim="VStug3_com_close",ViewPitchUpLimit=0,ViewPitchDownLimit=65536,ViewPositiveYawLimit=65535,ViewNegativeYawLimit=-65535,bDrawOverlays=true)
    DriverPositions(2)=(ViewFOV=90.0,PositionMesh=SkeletalMesh'DH_Jagdpanzer4_anm.Jagdpanzer4L70_turret_int',TransitionDownAnim="com_close",DriverTransitionAnim="VStug3_com_open",ViewPitchUpLimit=10000,ViewPitchDownLimit=64500,ViewPositiveYawLimit=65535,ViewNegativeYawLimit=-65535,bExposed=true)
    DriverPositions(3)=(ViewFOV=12.0,PositionMesh=SkeletalMesh'DH_Jagdpanzer4_anm.Jagdpanzer4L70_turret_int',ViewPitchUpLimit=10000,ViewPitchDownLimit=64500,ViewPositiveYawLimit=65535,ViewNegativeYawLimit=-65535,bDrawOverlays=true,bExposed=true)
    GunClass=class'DH_Vehicles.DH_JagdpanzerIVL70Cannon'
}
