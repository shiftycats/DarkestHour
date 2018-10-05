//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================
// TODO List:
// [ ] Have observation points appear on the map so that people can choose which one to observe from.
// [ ] Allow observer to toggle projectile tracking mode.
// [ ] Rename this to DHViewpoint.
// [ ] Have viewpoints "destroyed" when enemies are within a certain proximity or there are no friendlies nearby for a certain duration.
// [ ] Figure out a scheme to limit the # of viewpoints available (probably one per squad, I would think!)
//==============================================================================

class DHObservationPoint extends Actor
    notplaceable;

var int                             TeamIndex;
var int                             SquadIndex;
var private array<PlayerController> Observers;

replication
{
    reliable if (bNetDirty && Role == ROLE_Authority)
        TeamIndex, SquadIndex;
}

function bool RegisterObserver(PlayerController Observer)
{
    local int i;

    if (Observer == none)
    {
        return false;
    }

    for (i = 0; i < Observers.Length; ++i)
    {
        if (Observer == Observers[i])
        {
            return false;
        }
    }

    Observers[Observers.Length] = Observer;

    return true;
}

function UnregisterObserver(PlayerController Observer)
{
    local int i;

    for (i = 0; i < Observers.Length; ++i)
    {
        if (Observer == Observers[i])
        {
            Observers.Remove(i, 1);
            break;
        }
    }
}

event Destroyed()
{
    local int i;

    // Send a message to all observers that the viewpoint has been destroyed.
    for (i = 0; i < Observers.Length; ++i)
    {
        // "The viewpoint has been destroyed."
        Observers[i].ReceiveLocalizedMessage(class'DHViewpointMessage', 0);
    }
}

defaultproperties
{
    bHidden=false
    RemoteRole=ROLE_DumbProxy
}

