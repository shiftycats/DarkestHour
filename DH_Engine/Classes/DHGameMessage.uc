//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHGameMessage extends ROGameMessage;

var localized string VehicleDestroyedMessage;
var localized string VehicleDepletedMessage;
var localized string VehicleArrivedMessage;
var localized string VehicleCutOffMessage;

// This is overridden to change the hard link to ROPlayer that caused a bug where
// bUseNativeRoleNames was not being honored.
static function string GetString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    local string S;
    local DHSpawnManager SM;

    switch (Switch)
    {
        case 0:
            return default.OverTimeMessage;
        case 1:
            if (RelatedPRI_1 == none)
            {
                return default.NewPlayerMessage;
            }

            return RelatedPRI_1.PlayerName $ default.EnteredMessage;
        case 2:
            if (RelatedPRI_1 == none)
            {
                return "";
            }

            return RelatedPRI_1.OldName @ default.GlobalNameChange @ RelatedPRI_1.PlayerName;
        case 3:
            if (RelatedPRI_1 == none || OptionalObject == none)
            {
                return "";
            }

            return RelatedPRI_1.PlayerName @ default.NewTeamMessageRussian;
        case 4:
            if (RelatedPRI_1 == none)
            {
                return "";
            }

            return RelatedPRI_1.PlayerName $ default.LeftMessage;
        case 5:
            return default.SwitchLevelMessage;
        case 6:
            return default.FailedTeamMessage;
        case 7:
            return default.MaxedOutMessage;
        case 8:
            return default.NoNameChange;
        case 9:
            return RelatedPRI_1.PlayerName @ default.VoteStarted;
        case 10:
            return default.VotePassed;
        case 11:
            return default.MustHaveStats;
        // German team join message HACK - butto 7/17/03
        case 12:
            if (RelatedPRI_1 == none || OptionalObject == none)
            {
                return "";
            }

            return RelatedPRI_1.PlayerName @ default.NewTeamMessageGerman;
        // FF kill message
        case 13:
            if (RelatedPRI_1 == none)
            {
                return "";
            }

            return RelatedPRI_1.PlayerName @ default.FFKillMessage;
            break;
        // FF boot message
        case 14:
            if (RelatedPRI_1 == none)
            {
                return "";
            }

            return default.FFViolationMessage @ RelatedPRI_1.PlayerName @ default.FFViolationMessageTrailer;
        // FF damage message
        case 15:
            return default.FFDamageMessage;
        // Role change message
        case 16:
            if (RORoleInfo(OptionalObject) == none)
            {
                return "";
            }

            if (class'DHPlayer'.default.bUseNativeRoleNames)
            {
                return default.RoleChangeMsg $ RORoleInfo(OptionalObject).default.Article $ RORoleInfo(OptionalObject).default.AltName;
            }
            else
            {
                return default.RoleChangeMsg $ RORoleInfo(OptionalObject).default.Article $ RORoleInfo(OptionalObject).default.MyName;
            }
        // Unable to change role message
        case 17:
            if (OptionalObject == none)
            {
                return "";
            }

            if (class'DHPlayer'.default.bUseNativeRoleNames)
            {
                return default.MaxRoleMsg $ RORoleInfo(OptionalObject).default.AltName;
            }
            else
            {
                return default.MaxRoleMsg $ RORoleInfo(OptionalObject).default.MyName;
            }
        // To forgive type "np" or "forgive" message
        case 18:
            if (RelatedPRI_1 == none)
            {
                return "Someone" @ default.TypeForgiveMessage;
            }
            else
            {
                return RelatedPRI_1.PlayerName @ default.TypeForgiveMessage;
            }
        // Has forgiven message
        case 19:
            if (RelatedPRI_1 == none || RelatedPRI_2 == none)
            {
                return "";
            }

            return RelatedPRI_2.PlayerName @ default.HasForgivenMessage @ RelatedPRI_1.PlayerName;
        // You have logged in as an admin message(used for AdminLoginSilent)
        case 20:
            return default.YouHaveLoggedInAsAdminMsg;
        // You have logged out of admin message(used for AdminLoginSilent)
        case 21:
            return default.YouHaveLoggedOutOfAdminMsg;
        default:
            break;
    }

    SM = DHSpawnManager(OptionalObject);

    // This is a fairly hacky workaround to the fact that this function can't
    // accept class references as arguments. The remainder of Switch/100
    // is the index into the DHSpawnManager.VehiclePools array.
    if (SM != none)
    {
        if (Switch >= 400)
        {
            S = default.VehicleCutOffMessage;
        }
        else if (Switch >= 300)
        {
            // Vehicle reinforcements have arrived
            S = default.VehicleArrivedMessage;
        }
        else if (Switch >= 200)
        {
            // Vehicle reinforcements have been depleted
            S = default.VehicleDepletedMessage;
        }
        else if (Switch >= 100)
        {
            // Vehicle has been destroyed
            S = default.VehicleDestroyedMessage;
        }

        return Repl(S, "{0}", SM.VehiclePools[Switch % 100].VehicleClass.default.VehicleNameString);
    }

    return "";
}

defaultproperties
{
    VehicleDestroyedMessage="{0} has been destroyed."
    VehicleDepletedMessage="{0} reinforcements have been depleted."
    VehicleArrivedMessage="{0} reinforcements have arrived."
    VehicleCutOffMessage="{0} reinforcements have been cut off."
}
