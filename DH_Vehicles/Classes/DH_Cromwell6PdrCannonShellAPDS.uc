//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_Cromwell6PdrCannonShellAPDS extends  DH_ROTankCannonShellAPDS;

defaultproperties
{
    MechanicalRanges(1)=(Range=100,RangeValue=1.000000)
    MechanicalRanges(2)=(Range=200,RangeValue=2.000000)
    MechanicalRanges(3)=(Range=300,RangeValue=3.000000)
    MechanicalRanges(4)=(Range=400,RangeValue=4.000000)
    MechanicalRanges(5)=(Range=500,RangeValue=5.500000)
    MechanicalRanges(6)=(Range=600,RangeValue=7.000000)
    MechanicalRanges(7)=(Range=700,RangeValue=15.000000)
    MechanicalRanges(8)=(Range=800,RangeValue=25.000000)
    MechanicalRanges(9)=(Range=900,RangeValue=45.000000)
    MechanicalRanges(10)=(Range=1000,RangeValue=62.000000)
    MechanicalRanges(11)=(Range=1100,RangeValue=72.000000)
    MechanicalRanges(12)=(Range=1200,RangeValue=80.000000)
    MechanicalRanges(13)=(Range=1300,RangeValue=92.000000)
    MechanicalRanges(14)=(Range=1400,RangeValue=102.000000)
    MechanicalRanges(15)=(Range=1500,RangeValue=112.000000)
    MechanicalRanges(16)=(Range=1600,RangeValue=118.000000)
    MechanicalRanges(17)=(Range=1700,RangeValue=134.000000)
    MechanicalRanges(18)=(Range=1800,RangeValue=172.000000)
    MechanicalRanges(19)=(Range=1900,RangeValue=186.000000)
    MechanicalRanges(20)=(Range=2000,RangeValue=210.000000)
    MechanicalRanges(21)=(Range=2200,RangeValue=258.000000)
    MechanicalRanges(22)=(Range=2400,RangeValue=306.000000)
    MechanicalRanges(23)=(Range=2600,RangeValue=354.000000)
    MechanicalRanges(24)=(Range=2800,RangeValue=402.000000)
    bMechanicalAiming=true
    DHPenetrationTable(0)=14.200000
    DHPenetrationTable(1)=13.400000
    DHPenetrationTable(2)=12.700000
    DHPenetrationTable(3)=11.700000
    DHPenetrationTable(4)=11.000000
    DHPenetrationTable(5)=10.400000
    DHPenetrationTable(6)=9.500000
    DHPenetrationTable(7)=8.900000
    DHPenetrationTable(8)=8.300000
    DHPenetrationTable(9)=7.300000
    DHPenetrationTable(10)=6.400000
    ShellDiameter=3.700000
    ShellShatterEffectClass=class'DH_Effects.DH_TankAPShellShatterSmall'
    TracerEffect=class'DH_Effects.DH_RedTankShellTracer'
    ShellImpactDamage=class'DH_Vehicles.DH_Cromwell6PdrCannonShellDamageAPDS'
    ImpactDamage=300
    BallisticCoefficient=1.150000
    SpeedFudgeScale=0.400000
    Speed=73569.000000
    MaxSpeed=73569.000000
    Tag="Mk.I APDS"
}
