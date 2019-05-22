//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DHTrackerSlaveAttachment extends Actor;

var DHGameReplicationInfo GRI;

var private int MaxIdleSeconds;
var private int DestructionTime;

var int RegistryIndex;

// Make sure that owner is set to the master attachment
function PostBeginPlay()
{
    GRI = DHGameReplicationInfo(Level.Game.GameReplicationInfo);
}

state Tracking
{
    function BeginState()
    {
        local DHPawn P;

        P = DHPawn(Base);

        if (P != none)
        {
            RegistryIndex = RegisterAttachment(P);
        }


        if (RegistryIndex < 0)
        {
            Warn("Tracker wasn't registered");
            GotoState('Idle');

            return;
        }

        Log("SLAVE > Tracking" @ Base);
        SetTimer(1.0, true);
    }

    function Timer()
    {
        local DHTrackerMasterAttachment Master;
        local DHPawn P;

        P = DHPawn(Base);
        Master = DHTrackerMasterAttachment(Owner);

        if (P == none ||
            P.bDeleteMe ||
            P.Health <= 0 ||
            Master == none ||
            Master.bDeleteMe ||
            class'DHUnits'.static.UnrealToMeters(VSize(P.Location - Master.Location)) > Master.RadiusInMeters)
        {
            GotoState('Idle');
            return;
        }

        if (GRI != none && RegistryIndex >= 0 && RegistryIndex < arraycount(GRI.TrackerRegistry))
        {
            GRI.TrackerRegistry[RegistryIndex].Quantized2DPose = class'UQuantize'.static.QuantizeClamped2DPose(Base.Location.X, Base.Location.Y, Base.Rotation.Yaw);;
        }

    }

    function EndState()
    {
        Log("SLAVE > Stopped tracking" @ Base);
        UnregisterAttachment(RegistryIndex);
        RegistryIndex = -1;
    }
}

state Idle
{
    function BeginState()
    {
        Log("SLAVE > Idling...");
        if (GRI != none)
        {
            DestructionTime = GRI.ElapsedTime + MaxIdleSeconds;
        }
    }

    function Timer()
    {
        if (GRI != none && GRI.ElapsedTime > DestructionTime)
        {
            Log("SLAVE > Idle time run out. Destroying slave!");
            Destroy();
        }
    }
}

function Destroyed()
{
    Log("SLAVE > Destroyed!");

    super.Destroyed();
}

delegate int RegisterAttachment(DHPawn Pawn)
{
    return -1;
}

delegate UnregisterAttachment(int Index);

defaultproperties
{
    RemoteRole=ROLE_None
    DrawType=DT_None
    RegistryIndex=-1

    MaxIdleSeconds=15
}
