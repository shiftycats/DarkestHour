//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_DaimlerArmoredCar extends DHArmoredVehicle;

defaultproperties
{
    // Vehicle properties
    VehicleNameString="Daimler Armored Car"
    VehicleTeam=1
    bIsApc=true
    bHasTreads=false
    bSpecialTankTurning=false
    VehicleMass=6.0
    ReinforcementCost=4

    // Hull mesh
    Mesh=SkeletalMesh'DH_DaimlerMk1_anm.body_ext'
    Skins(0)=Texture'DH_DaimlerMk1_tex.body.body_01'
    Skins(1)=Texture'DH_DaimlerMk1_tex.body.body_02'
    Skins(2)=Texture'DH_DaimlerMk1_tex.body.body_int'

    // Vehicle weapons & passengers
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_DaimlerCannonPawn',WeaponBone="Turret_placement")
    //PassengerPawns(0)=(AttachBone="body",DrivePos=(X=-125.0,Y=-70.0,Z=105.0),DriveRot=(Yaw=-16384),DriveAnim="VHalftrack_Rider4_idle")
    //PassengerPawns(1)=(AttachBone="body",DrivePos=(X=-165.0,Y=-35.0,Z=105.0),DriveRot=(Yaw=32768),DriveAnim="VHalftrack_Rider4_idle")
    //PassengerPawns(2)=(AttachBone="body",DrivePos=(X=-165.0,Y=35.0,Z=105.0),DriveRot=(Yaw=32768),DriveAnim="VHalftrack_Rider5_idle")
    //PassengerPawns(3)=(AttachBone="body",DrivePos=(X=-125.0,Y=75.0,Z=105.0),DriveRot=(Yaw=16384),DriveAnim="VHalftrack_Rider5_idle")

    // Driver
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_DaimlerMk1_anm.body_int',TransitionUpAnim="overlay_out",ViewPitchUpLimit=2048,ViewPitchDownLimit=63488,ViewPositiveYawLimit=8192,ViewNegativeYawLimit=-8192)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_DaimlerMk1_anm.body_int',TransitionUpAnim="driver_hatch_open",TransitionDownAnim="overlay_in",DriverTransitionAnim="VBA64_driver_close",ViewPitchUpLimit=2048,ViewPitchDownLimit=63488,ViewPositiveYawLimit=8192,ViewNegativeYawLimit=-8192)
    DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_DaimlerMk1_anm.body_int',TransitionDownAnim="driver_hatch_close",DriverTransitionAnim="VBA64_driver_open",ViewPitchUpLimit=2048,ViewPitchDownLimit=63488,ViewPositiveYawLimit=8192,ViewNegativeYawLimit=-8192,bExposed=true)
    DrivePos=(X=25.0,Y=0.0,Z=-27.0)
    DriveAnim="VBA64_driver_idle_close"

    DriverAttachmentBone="driver_player"

    // Hull armor
    FrontArmor(0)=(Thickness=1.59,Slope=-30.0,MaxRelativeHeight=71.0,LocationName="lower")
    FrontArmor(1)=(Thickness=1.27,Slope=60.0,MaxRelativeHeight=101.5,LocationName="upper")
    FrontArmor(2)=(Thickness=1.91,Slope=45.0,LocationName="driver plate")
    RightArmor(0)=(Thickness=0.95,Slope=-22.0,MaxRelativeHeight=91.5,LocationName="lower")
    RightArmor(1)=(Thickness=0.95,Slope=22.0,LocationName="upper")
    LeftArmor(0)=(Thickness=0.95,Slope=-22.0,MaxRelativeHeight=91.5,LocationName="lower")
    LeftArmor(1)=(Thickness=0.95,Slope=22.0,LocationName="upper")
    RearArmor(0)=(Thickness=0.95)

    FrontLeftAngle=332.0
    RearLeftAngle=208.0

    // Movement
    MaxCriticalSpeed=1077.0 // 64 kph
    GearRatios(3)=0.6
    GearRatios(4)=0.75
    WheelPenScale=1.2
    WheelLatSlipFunc=(Points=(,(InVal=30.0,OutVal=0.009),(InVal=45.0),(InVal=10000000000.0)))
    WheelLongFrictionScale=1.1
    WheelLatFrictionScale=1.55
    WheelSuspensionTravel=0.0
    WheelSuspensionOffset=-3.0
    WheelSuspensionMaxRenderTravel=5.0
    ChassisTorqueScale=0.095
    MaxSteerAngleCurve=(Points=((OutVal=20.0),(InVal=500.0,OutVal=20.0),(InVal=600.0,OutVal=15.0),(InVal=1000000000.0,OutVal=10.0)))
    ChangeUpPoint=1990.0
    ChangeDownPoint=1000.0
    SteerSpeed=75.0
    TurnDamping=100.0

    // Damage
    Health=300
    HealthMax=300.0
    EngineHealth=100
    VehHitpoints(0)=(PointBone="Engine",PointOffset=(Z=-10.0)) // engine
    DamagedEffectScale=0.75
    DamagedEffectOffset=(X=-130.0,Y=0.0,Z=100.0)
    FireEffectOffset=(X=5.0,Y=5.0,Z=0.0)
    DriverKillChance=900.0
    CommanderKillChance=600.0
    GunDamageChance=1000.0
    TraverseDamageChance=1250.0
    DestroyedVehicleMesh=StaticMesh'DH_allies_vehicles_stc3.M8_Greyhound.M8_Destroyed'

    // Exit
    ExitPositions(0)=(X=135.0,Y=-33.0,Z=176.0)  // driver
    ExitPositions(1)=(X=30.0,Y=-5.0,Z=210.0)    // commander
    ExitPositions(2)=(X=-124.0,Y=-161.0,Z=64.0) // passenger (l)
    ExitPositions(3)=(X=-245.0,Y=-42.0,Z=63.0)  // passenger (bl)
    ExitPositions(4)=(X=-249.0,Y=31.0,Z=63.0)   // passenger (br)
    ExitPositions(5)=(X=-126.0,Y=169.0,Z=64.0)  // passenger (r)

    // Sounds
    IdleSound=SoundGroup'Vehicle_Engines.sdkfz251.sdkfz251_engine_loop'
    StartUpSound=Sound'Vehicle_Engines.sdkfz251.sdkfz251_engine_start'
    ShutDownSound=Sound'Vehicle_Engines.sdkfz251.sdkfz251_engine_stop'

    // Visual effects
    ExhaustPipes(0)=(ExhaustPosition=(X=-32.0,Y=-75.0,Z=33.0),ExhaustRotation=(Pitch=-1024,Yaw=-20000))
    SteerBoneName="steering_wheel"
    SteeringScaleFactor=4.0

    // HUD
    VehicleHudImage=Texture'DH_DaimlerMk1_tex.interface.daimler_body'
    VehicleHudTurret=TexRotator'DH_DaimlerMk1_tex.interface.daimler_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_DaimlerMk1_tex.interface.daimler_turret_look'
    VehicleHudEngineX=0.51
    VehicleHudOccupantsX(0)=0.45
    VehicleHudOccupantsY(0)=0.35
    VehicleHudOccupantsX(2)=0.375
    VehicleHudOccupantsY(2)=0.75
    VehicleHudOccupantsX(3)=0.45
    VehicleHudOccupantsY(3)=0.8
    VehicleHudOccupantsX(4)=0.55
    VehicleHudOccupantsY(4)=0.8
    VehicleHudOccupantsX(5)=0.625
    VehicleHudOccupantsY(5)=0.75

    SpawnOverlay(0)=Material'DH_InterfaceArt_tex.Vehicles.m8_greyhound'

    // Shadow
    ShadowZOffset=35

    // Physics wheels
    Begin Object Class=SVehicleWheel Name=RFWheel
        SteerType=VST_Steered
        BoneName="wheel.F.R"
        BoneRollAxis=AXIS_Y
        SupportBoneName="axle.F.R"
        SupportBoneAxis=AXIS_X
        WheelRadius=32.0
    End Object
    Wheels(0)=SVehicleWheel'DH_Vehicles.DH_DaimlerArmoredCar.RFWheel'
    Begin Object Class=SVehicleWheel Name=LFWheel
        SteerType=VST_Steered
        BoneName="wheel.F.L"
        BoneRollAxis=AXIS_Y
        SupportBoneName="axle.F.L"
        SupportBoneAxis=AXIS_X
        bLeftTrack=true
        WheelRadius=32.0
    End Object
    Wheels(1)=SVehicleWheel'DH_Vehicles.DH_DaimlerArmoredCar.LFWheel'
    Begin Object Class=SVehicleWheel Name=MRWheel
        bPoweredWheel=true
        BoneName="wheel.B.R"
        BoneRollAxis=AXIS_Y
        SupportBoneName="axle.B.R"
        SupportBoneAxis=AXIS_X
        WheelRadius=32.0
    End Object
    Wheels(2)=SVehicleWheel'DH_Vehicles.DH_DaimlerArmoredCar.MRWheel'
    Begin Object Class=SVehicleWheel Name=MLWheel
        bPoweredWheel=true
        BoneName="wheel.B.L"
        BoneRollAxis=AXIS_Y
        SupportBoneName="axle.B.L"
        SupportBoneAxis=AXIS_X
        bLeftTrack=true
        WheelRadius=32.0
    End Object
    Wheels(3)=SVehicleWheel'DH_Vehicles.DH_DaimlerArmoredCar.MLWheel'

    // Karma
    Begin Object Class=KarmaParamsRBFull Name=KParams0
        KInertiaTensor(0)=1.3 // default is 1.0
        KInertiaTensor(3)=3.0
        KInertiaTensor(5)=3.0
        KCOMOffset=(X=0.3,Z=-0.525) // default is X=0.0, Z=-0.5
        KLinearDamping=0.05
        KAngularDamping=0.05
        KStartEnabled=true
        bKNonSphericalInertia=true
        bHighDetailOnly=false
        bClientOnly=false
        bKDoubleTickRate=true
        bDestroyOnWorldPenetrate=true
        bDoSafetime=true
        KFriction=0.5
        KImpactThreshold=700.0
    End Object
    KParams=KarmaParamsRBFull'DH_Vehicles.DH_DaimlerArmoredCar.KParams0'
}
