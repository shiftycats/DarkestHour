//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DHTrackerMasterAttachment extends Actor;

var DHGameReplicationInfo GRI;

var int   TeamIndex;
var float RadiusInMeters;

function PostBeginPlay()
{
    GRI = DHGameReplicationInfo(Level.Game.GameReplicationInfo);
}

function Setup()
{
    SetTimer(1.0, true);
}

function Timer()
{
    local DHPawn P;
    local DHTrackerSlaveAttachment Slave;

    if (GRI == none)
    {
        return;
    }

    foreach RadiusActors(class'DHPawn', P, class'DHUnits'.static.MetersToUnreal(RadiusInMeters))
    {
        if (P != none &&
            !P.bDeleteMe &&
            (P.TrackerSlaveAttachment == none || P.TrackerSlaveAttachment.bDeleteMe) &&
            P.Health > 0 &&
            P.PlayerReplicationInfo != none &&
            P.GetTeamNum() != TeamIndex)
        {
            if (P.TrackerSlaveAttachment.IsInState('Idle'))
            {
                if (Owner != self)
                {
                    SetOwner(self);
                }

                P.TrackerSlaveAttachment.GotoState('Tracking');
                continue;
            }

            Log("MASTER > Found player");

            Slave = Spawn(class'DHTrackerSlaveAttachment', self);

            if (Slave != none)
            {
                Slave.SetBase(P);
                Slave.RegisterAttachment = RegisterSlave;
                Slave.UnregisterAttachment = UnregisterSlave;

                P.TrackerSlaveAttachment = Slave;

                Slave.GotoState('Tracking');
            }
            else
            {
                Warn("Failed to spawn tracker slave attachment");
            }
        }
    }
}

function SetTeamIndex(byte TeamIndex)
{
    self.TeamIndex = TeamIndex;

    Log("MASTER > Team set to" @ TeamIndex);
}

function int RegisterSlave(DHPawn Pawn)
{
    if (GRI != none)
    {
        return GRI.AddTrackerEntry(Pawn);
    }

    return -1;
}

function UnregisterSlave(int Index)
{
    if (GRI != none)
    {
        GRI.RemoveTrackerEntry(Index);
    }
}

defaultproperties
{
    RemoteRole=ROLE_None
    DrawType=DT_None

    RadiusInMeters=100
}
