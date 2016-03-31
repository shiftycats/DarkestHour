//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHATGunCannon extends DHVehicleCannon
    abstract;

// AT gun will always be penetrated by a shell
simulated function bool ShouldPenetrate(DHAntiVehicleProjectile P, vector HitLocation, vector HitRotation, float PenetrationNumber)
{
   return true;
}

defaultproperties
{
    bHasTurret=false
    RotationsPerSecond=0.025
    bLimitYaw=true
    SoundVolume=130
    FireSoundVolume=512.0
    SoundRadius=200.0

    // Screen shake
    ShakeRotMag=(Z=110.0)
    ShakeRotRate=(Z=1100.0)
    ShakeRotTime=2.0
    ShakeOffsetMag=(Z=5.0)
    ShakeOffsetTime=2.0
}
