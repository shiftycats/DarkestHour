//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DHConsole extends ROConsole;

const RECONNECT_DELAY = 1.0;

var bool        bLockConsoleOpen;
var bool        bDelayForReconnect;
var float       DelayWaitTime;
var string      StoredServerAddress;

var array<string>           SayTypes;
var string                  SayType;

// Since "say" messages are being treated differently now, we want to keep a
// separate history so we don't accidentally broadcast console messages (like
// admin login credentials etc.).
const SAY_HISTORY_MAX = 16;

var array<string>           SayHistory;
var int                     SayHistoryCur;

// Autocomplete
const AUTOCOMPLETE_CHARACTER = "@";

struct AutoCompleteOptionFilterResult
{
    var int Index;          // The index into the auto-complete option.
    var PlayerReplicationInfo Option;
    var string OptionText;  // The option text.
    var int SearchIndex;    // The index into OptionText where the search text was found.
};

var int                                     AutoCompleteStrPos;
var string                                  AutoCompleteSearchText;         // The auto-complete current search text
var int                                     AutoCompleteIndex;              // The current index into the
var array<PlayerReplicationInfo>            AutoCompleteOptions;            // The raw, unfiltered list of possible auto-complete options.
var array<AutoCompleteOptionFilterResult>   FilteredAutoCompleteOptions;    // The filtered list of auto-complete options.



// Rebuilds the auto-complete options.
simulated function BuildAutoCompleteOptions()
{
    local Controller C;

    AutoCompleteOptions.Length = 0;

    for (C = ViewportOwner.Actor.Level.ControllerList; C != none; C = C.nextController)
    {
        if (C != none && C.PlayerReplicationInfo != none)
        {
            AutoCompleteOptions[AutoCompleteOptions.Length] = C.PlayerReplicationInfo;
        }
    }
}

// Gets the associated string for the specified auto-complete option.
simulated function string GetAutoCompleteOptionText(int Index)
{
    if (Index < 0 || Index >= AutoCompleteOptions.Length || AutoCompleteOptions[Index] == none)
    {
        return "";
    }

    return AutoCompleteOptions[Index].PlayerName;
}

function SetAutoCompleteSearchText(string NewSearchText)
{
    local int OldAutoCompleteIndex;
    local int OldAutoCompleteOptionIndex;
    local int i;
    local bool bDidFindOldOption;

    /*
    if (AutoCompleteSearchText == NewSearchText)
    {
        // TODO:
        return;
    }
    */

    // Assign the new search text.
    AutoCompleteSearchText = NewSearchText;

    OldAutoCompleteOptionIndex = -1;

    // Save auto-complete index and filtered options.
    OldAutoCompleteIndex = AutoCompleteIndex;

    if (OldAutoCompleteIndex != -1)
    {
        OldAutoCompleteOptionIndex = FilteredAutoCompleteOptions[OldAutoCompleteIndex].Index;
    }

    // Filter auto-complete options with new search text.
    FilterAutoCompleteOptions(NewSearchText, FilteredAutoCompleteOptions);

    Log("=====================");

    for (i = 0; i < FilteredAutoCompleteOptions.Length; ++i)
    {
        Log(FilteredAutoCompleteOptions[i].OptionText);
    }

    // If we already had an option selected, do a search to see if that option
    // exists in the new result set. If it does, update the auto-complete option
    // index.
    if (OldAutoCompleteOptionIndex != -1)
    {
        for (i = 0; i < FilteredAutoCompleteOptions.Length; ++i)
        {
            if (FilteredAutoCompleteOptions[i].Index == OldAutoCompleteOptionIndex)
            {
                bDidFindOldOption = true;
                AutoCompleteIndex = i;
                break;
            }
        }

        if (!bDidFindOldOption)
        {
            // We did not find our previously selected option in the new
            // filter results.
            if (FilteredAutoCompleteOptions.Length > 0)
            {
                // Set the auto complete index to the first option.
                AutoCompleteIndex = 0;
            }
            else
            {
                // Clear the auto-complete index.
                AutoCompleteIndex = -1;
            }
        }
    }
    else
    {
        if (FilteredAutoCompleteOptions.Length > 0)
        {
            AutoCompleteIndex = 0;
        }
        else
        {
            AutoCompleteIndex = -1;
        }
    }
}

simulated function FilterAutoCompleteOptions(string SearchText, out array<AutoCompleteOptionFilterResult> Results)
{
    local int i, StartIndex;
    local AutoCompleteOptionFilterResult FR;
    local string OptionText;

    Results.Length = 0;

    for (i = 0; i < AutoCompleteOptions.Length; ++i)
    {
        OptionText = GetAutoCompleteOptionText(i);
        StartIndex = InStr(Caps(OptionText), Caps(SearchText));

        if (StartIndex == -1)
        {
            continue;
        }

        FR.Index = i;
        FR.OptionText = OptionText;
        FR.SearchIndex = StartIndex;

        Results[Results.Length] = FR;
    }

    SortAutoCompleteOptionFilterResults(Results);
}

// Comparator function
function bool AutoCompleteOptionFilterResultCompareFunction(AutoCompleteOptionFilterResult LHS, AutoCompleteOptionFilterResult RHS)
{
    return LHS.SearchIndex > RHS.SearchIndex;
}

// Sort by linear insertion based on the group index!
function SortAutoCompleteOptionFilterResults(out array<AutoCompleteOptionFilterResult > Results)
{
    local int i, j;
    local AutoCompleteOptionFilterResult Temp;

    for (i = 1; i < Results.Length; ++i)
    {
        j = i;

        while (j > 0 && AutoCompleteOptionFilterResultCompareFunction(Results[j - 1], Results[j]))
        {
            Temp = Results[j];
            Results[j] = Results[j - 1];
            Results[j - 1] = Temp;

            j -= 1;
        }
    }
}

function IncrementAutoCompleteIndex()
{
    if (AutoCompleteIndex == -1)
    {
        return;
    }

    AutoCompleteIndex = (AutoCompleteIndex + 1) % FilteredAutoCompleteOptions.Length;
}

// Re-evaluates the auto-complete state.
function UpdateAutoCompleteState()
{
    local string S;
    local int i;
    local int WhitespacePos;

    Log("UpdateAutoCompleteState");

    // TODO: from the typedstrpos, travel backwards and see if we can find an
    // unbroken chain of non-whitespace characters punctuated with the @ symbol

    // Get the string of all characters up until the current cursor.
    S = Mid(TypedStr, 0, TypedStrPos);

    // Find the last occurrance of the auto-complete character.
    i = class'UString'.static.FindLastOf(S, AUTOCOMPLETE_CHARACTER);

    Log("S" @ S);

    if (i == -1)
    {
        // No auto-complete character to be found.
        AutoCompleteStrPos = -1;
        AutoCompleteIndex = -1;
        return;
    }

    // Set the auto-complete cursor position.
    AutoCompleteStrPos = i;

    Log("AutoCompleteStrPos" @ AutoCompleteStrPos);

    // Get a substring of all characters after the auto-complete character.
    S = Mid(TypedStr, AutoCompleteStrPos);

    // Find the relative index of any whitespace character after the
    // auto-complete character.
    WhitespacePos = InStr(S, " ");

    if (WhitespacePos == -1)
    {
        // No whitespace character, the remainder of the string is the search string.
        S = Mid(TypedStr, AutoCompleteStrPos + 1);

        Log("SearchText" @ S);

        SetAutoCompleteSearchText(S);
        return;
    }

    // Set the whitespace index to the original string.
    WhitespacePos += AutoCompleteStrPos;

    if (WhitespacePos >= TypedStrPos)
    {
        S = Mid(TypedStr, AutoCompleteStrPos + 1, WhitespacePos - AutoCompleteStrPos - 1);

        Log("SearchText" @ S);

        // Whitespace character is beyond the cursor position.
        SetAutoCompleteSearchText(S);
    }
    else
    {
        // Whitespace character breaks up the remainder of the string, no auto-complete.
        AutoCompleteStrPos = -1;
        AutoCompleteIndex = -1;
        return;
    }
}

// Gets the typed string to be displayed while typing.
// TODO: have this simply be updated once instead of re-fetched a million times a second
simulated function string GetTypedStr()
{
    local string LHS, RHS;
    local AutoCompleteOptionFilterResult FR;
    local string S;

    // TODO: we need to go and *replace* the auto-complete portion with the
    // "LHS<search>RHS" bit *while* retaining the cursor.
    // the cursor is actually the Chr(4) bit I think.
    S = Left(TypedStr, TypedStrPos) $ Chr(4) $ Eval(TypedStrPos < Len(TypedStr), Mid(TypedStr, TypedStrPos), "_");

    // If there is an auto-complete character in use,
    if (AutoCompleteStrPos != -1 && AutoCompleteIndex != -1)
    {
        FR = FilteredAutoCompleteOptions[AutoCompleteIndex];
        LHS = Left(FR.OptionText, FR.SearchIndex);
        RHS = Mid(FR.OptionText, FR.SearchIndex + Len(AutoCompleteSearchText));

        S $= class'GameInfo'.static.MakeColorCode(class'UColor'.default.Gray) $ LHS $
        class'GameInfo'.static.MakeColorCode(class'UColor'.default.White) $ Mid(FR.OptionText, FR.SearchIndex, Len(AutoCompleteSearchText)) $
        class'GameInfo'.static.MakeColorcode(class'UColor'.default.Gray) $ RHS $
        class'GameInfo'.static.MakeColorCode(class'UColor'.default.White);
    }

    return S;
}

// Modified to fix the reconnect console command, a delay is need, but so is a bit in ConnectFailure, as it does techically fail still
simulated event Tick(float Delta)
{
    super.Tick(Delta);

    // We have been queued with reconnect command
    if (bDelayForReconnect)
    {
        // Handle delay count up
        DelayWaitTime += Delta;

        // Once we have been delayed long enough
        if (DelayWaitTime > RECONNECT_DELAY)
        {
            // Make sure we properly stored the server address
            if (StoredServerAddress != "")
            {
                // Even if you strip the extra bit off of the address string here, it is somehow added later, and must be stripped/handled in ConnectFailure
                DelayedConsoleCommand("Open" @ StoredServerAddress);
            }

            // Lets not hang forever here or otherwise somehow get stuck/repeat commands
            DelayWaitTime = 0.0;
            bDelayForReconnect = false;
        }
    }
}

exec function Reconnect()
{
    if (ViewportOwner == none || ViewportOwner.Actor == none)
    {
        return;
    }

    // Initiate a locked console which is queued for reconnect in RECONNECT_DELAY seconds
    bDelayForReconnect = true;
    bLockConsoleOpen = true;

    // Store current network address
    StoredServerAddress = ViewportOwner.Actor.GetServerNetworkAddress();

    // Disconnect from the current server (tick will handle the reconnect, sorta)
    DelayedConsoleCommand("Disconnect");
}

// Testing override of this function in hopes to stop the Unknown Steam Error bug
event ConnectFailure(string FailCode, string URL)
{
    local string Error, Server;
    local int    i,Index;

    LastURL = URL;
    Server = Left(URL, InStr(URL, "/"));

    i = InStr(FailCode, " ");

    if (i > 0)
    {
        Error = Right(FailCode, Len(FailCode) - i - 1);
        FailCode = Left(FailCode, i);
    }

    Log("Connect Failure: " @ FailCode $ "[" $ Error $ "] (" $ URL $ ")", 'Debug');

    if (FailCode == "NEEDPW")
    {
        /* Removing this, because the password saving stuff not only doesn't work right, but causes very strange problems with trying
        to connect to passworded servers!
        for (Index = 0; Index < SavedPasswords.Length; ++Index)
        {
            if (SavedPasswords[Index].Server == Server)
            {
                ViewportOwner.Actor.ClearProgressMessages();
                ViewportOwner.Actor.ClientTravel(URL $ "?password=" $ SavedPasswords[Index].Password,TRAVEL_Absolute, false);

                return;
            }
        }*/

        LastConnectedServer = Server;

        if (ViewportOwner.GUIController.OpenMenu("DH_Engine.DHGetPassword", Server, FailCode))
        {
            return;
        }
    }
    else if (FailCode == "WRONGPW")
    {
        ViewportOwner.Actor.ClearProgressMessages();

        for (Index = 0; Index < SavedPasswords.Length; Index++)
        {
            if (SavedPasswords[Index].Server == Server)
            {
                SavedPasswords.Remove(Index, 1);
                SaveConfig();
            }
        }

        LastConnectedServer = Server;

        if (ViewportOwner.GUIController.OpenMenu("DH_Engine.DHGetPassword", URL, FailCode))
        {
            return;
        }
    }
    else if (FailCode == "NEEDSTATS")
    {
        ViewportOwner.Actor.ClearProgressMessages();

        if (ViewportOwner.GUIController.OpenMenu(StatsPromptMenuClass, "", FailCode))
        {
            GUIController(ViewportOwner.GUIController).ActivePage.OnReopen = OnStatsConfigured;
            return;
        }
    }
    else if (FailCode == "LOCALBAN")
    {
        ViewportOwner.Actor.ClearProgressMessages();
        ViewportOwner.GUIController.OpenMenu(class'GameEngine'.default.DisconnectMenuClass,Localize("Errors","ConnectionFailed", "Engine"), class'AccessControl'.default.IPBanned);
        return;
    }
    else if (FailCode == "SESSIONBAN")
    {
        ViewportOwner.Actor.ClearProgressMessages();
        ViewportOwner.GUIController.OpenMenu(class'GameEngine'.default.DisconnectMenuClass,Localize("Errors","ConnectionFailed", "Engine"), class'AccessControl'.default.SessionBanned);
        return;
    }
    else if (FailCode == "SERVERFULL")
    {
        ViewportOwner.Actor.ClearProgressMessages();
        ViewportOwner.GUIController.OpenMenu(class'GameEngine'.default.DisconnectMenuClass, ServerFullMsg);

        return;
    }
    else if (FailCode == "CHALLENGE")
    {
        ViewportOwner.Actor.ClearProgressMessages();
        ViewportOwner.Actor.ClientNetworkMessage("FC_Challege", "");

        return;
    }
    // _RO_
    else if (FailCode == "STEAMLOGGEDINELSEWHERE")
    {
        ViewportOwner.Actor.ClearProgressMessages();

        LastConnectedServer = Server;

        if (ViewportOwner.GUIController.OpenMenu(SteamLoginMenuClass, URL, FailCode))
        {
            return;
        }
    }
    else if (FailCode == "STEAMVACBANNED")
    {
        ViewportOwner.Actor.ClearProgressMessages();
        ViewportOwner.Actor.ClientNetworkMessage("ST_VACBan", "");

        return;
    }
    else if (FailCode == "STEAMVALIDATIONSTALLED")
    {
        // Lame hack for a Steam problem - take this out when Valve fixes the SteamValidationStalled bug
        if (SteamLoginRetryCount < 5)
        {
            ++SteamLoginRetryCount;

            ViewportOwner.Actor.ClientTravel(URL, TRAVEL_Absolute, false);
            ViewportOwner.GUIController.CloseAll(false, true);
        }
        else
        {
            ViewportOwner.Actor.ClearProgressMessages();
            ViewportOwner.Actor.ClientNetworkMessage("ST_Unknown", "");
        }

        return;
    }
    else if (FailCode == "STEAMAUTH")
    {
        // Check to see if the URL is more than just the IP, if so then use the cut off IP
        if (InStr(URL, "/") != -1)
        {
            ViewportOwner.Actor.ClientTravel(Server,TRAVEL_Absolute, false);
            ViewportOwner.GUIController.CloseAll(false, true);
            return;
        }
        else if (SteamLoginRetryCount < 5) // Try again a few times
        {
            SteamLoginRetryCount++;
            ViewportOwner.Actor.ClientTravel(URL,TRAVEL_Absolute, false);
            ViewportOwner.GUIController.CloseAll(false, true);
            return;
        }
        else
        {
            ViewportOwner.Actor.ClearProgressMessages();
            ViewportOwner.Actor.ClientNetworkMessage("ST_Unknown","");
            return;
        }
    }

    Log("Unhandled connection failure!  FailCode '" $ FailCode @ "'   URL '" $ URL $ "'");
    ViewportOwner.Actor.ProgressCommand("menu:" $ class'GameEngine'.default.DisconnectMenuClass, FailCode, Error);
}

// Modified for DHObjectives
state SpeechMenuVisible
{
    //--------------------------------------------------------------------------
    // build voice command array for attack voices
    //--------------------------------------------------------------------------
    function buildSMAttackArray()
    {
       local DHGameReplicationInfo DHGRI;
       local DHPlayerReplicationInfo DHPRI;
       local int i;

       DHGRI = DHGameReplicationInfo(ViewportOwner.Actor.GameReplicationInfo);
       DHPRI = DHPlayerReplicationInfo(ViewportOwner.Actor.PlayerReplicationInfo);
       SMArraySize = 0;
       PreviousStateName = ROSMS_Commanders;

       for (i = 0; i < arraycount(DHGRI.DHObjectives); ++i)
        {
            if (DHGRI.DHObjectives[i] != none)
            {
                switch (DHPRI.RoleInfo.Side)
                {
                   case SIDE_Axis:
                       if ((DHGRI.DHObjectives[i].IsAllies() || DHGRI.DHObjectives[i].IsNeutral()) && DHGRI.DHObjectives[i].bActive)
                       {
                          SMNameArray[SMArraySize] = DHGRI.DHObjectives[i].ObjName;
                          SMIndexArray[SMArraySize] = DHGRI.DHObjectives[i].ObjNum;
                          SMArraySize++;
                       }
                       break;

                   case SIDE_Allies:
                       if ((DHGRI.DHObjectives[i].IsAxis() || DHGRI.DHObjectives[i].IsNeutral()) && DHGRI.DHObjectives[i].bActive)
                       {
                          SMNameArray[SMArraySize] = DHGRI.DHObjectives[i].ObjName;
                          SMIndexArray[SMArraySize] = DHGRI.DHObjectives[i].ObjNum;
                          SMArraySize++;
                       }

                       break;
                }
            }
        }
    }

    //--------------------------------------------------------------------------
    // build voice command array for defend voices
    //--------------------------------------------------------------------------
    function buildSMDefendArray()
    {
       local DHGameReplicationInfo DHGRI;
       local DHPlayerReplicationInfo DHPRI;
       local int i;

       DHGRI = DHGameReplicationInfo(ViewportOwner.Actor.GameReplicationInfo);
       DHPRI = DHPlayerReplicationInfo(ViewportOwner.Actor.PlayerReplicationInfo);
       SMArraySize = 0;
       PreviousStateName = ROSMS_Commanders;

       //TODO: find out if the number of objectives can be hardcoded (16)
       for (i = 0; i < arraycount(DHGRI.DHObjectives); ++i)
       {
            if (DHGRI.DHObjectives[i] != none)
            {
                switch (DHPRI.RoleInfo.Side)
                {
                   case SIDE_Axis:
                       if (DHGRI.DHObjectives[i].IsAxis())
                       {
                          SMNameArray[SMArraySize] = DHGRI.DHObjectives[i].ObjName;
                          SMIndexArray[SMArraySize] = DHGRI.DHObjectives[i].ObjNum;
                          SMArraySize++;
                       }
                       break;

                   case SIDE_Allies:
                       if (DHGRI.DHObjectives[i].IsAllies())
                       {
                          SMNameArray[SMArraySize] = DHGRI.DHObjectives[i].ObjName;
                          SMIndexArray[SMArraySize] = DHGRI.DHObjectives[i].ObjNum;
                          SMArraySize++;
                       }

                       break;
                }
            }
        }

    }

    function buildSMGotoArray()
    {
       local DHGameReplicationInfo DHGRI;
       local int i;

       DHGRI = DHGameReplicationInfo(ViewportOwner.Actor.GameReplicationInfo);
       SMArraySize = 0;
       PreviousStateName = ROSMS_Vehicle_Orders;

       //TODO: find out if the number of objectives can be hardcoded (16)
       for (i = 0; i < arraycount(DHGRI.DHObjectives); ++i)
       {
            if (DHGRI.DHObjectives[i] != none)
            {
                SMNameArray[SMArraySize] = DHGRI.DHObjectives[i].ObjName;
                SMIndexArray[SMArraySize] = DHGRI.DHObjectives[i].ObjNum;
                SMArraySize++;
            }
        }
    }
}

exec function VehicleTalk()
{
    if (CanUseSayType("VehicleSay"))
    {
        SayType = "VehicleSay";
        TypedStr = "";
        TypedStrPos = 0;
        TypingOpen();
    }
}

exec function TeamTalk()
{
    if (CanUseSayType("TeamSay"))
    {
        SayType = "TeamSay";
        TypedStr = "";
        TypedStrPos = 0;
        TypingOpen();
    }
}

exec function SquadTalk()
{
    if (CanUseSayType("SquadSay"))
    {
        SayType = "SquadSay";
        TypedStr = "";
        TypedStrPos = 0;
        TypingOpen();
    }
}

exec function Talk()
{
    if (CanUseSayType("Say"))
    {
        SayType = "Say";
        TypedStr = "";
        TypedStrPos = 0;
        TypingOpen();
    }
}

exec function StartTyping()
{
    UpdateSayType();
    TypedStr = "";
    TypedStrPos = 0;
    TypingOpen();
}

// Modified to fix reconnect command bug
exec function ConsoleClose()
{
    // If we are locked open, then do nothing and return
    if (bLockConsoleOpen)
    {
        // To prevent from always being locked lets unlock now, this also gives the user a chance to cancel the reconnect by closing the console
        bLockConsoleOpen = false;
        return;
    }

    super.ConsoleClose();
}

function DecrementSayType()
{
    local int i, j, SayTypeIndex;

    SayTypeIndex = GetSayTypeIndex(SayType);
    --SayTypeIndex;

    for (i = 0; i < SayTypes.Length; ++i)
    {
        j = (SayTypeIndex - i) % SayTypes.Length;

        if (j < 0)
        {
            // Unrealscript has an interesting idea of what a modulo operator
            // does, so we need to correct this.
            j = -j;
        }

        if (CanUseSayType(SayTypes[j]))
        {
            SayType = SayTypes[j];
            return;
        }
    }
}

function IncrementSayType()
{
    local int i, j, SayTypeIndex;

    SayTypeIndex = GetSayTypeIndex(SayType);
    ++SayTypeIndex;

    for (i = 0; i < SayTypes.Length; ++i)
    {
        j = (SayTypeIndex + i) % SayTypes.Length;

        if (j < 0)
        {
            // Unrealscript has an interesting idea of what a modulo operator
            // should be doing, so we need to correct it.
            j = -j;
        }

        if (CanUseSayType(SayTypes[j]))
        {
            SayType = SayTypes[j];
            return;
        }
    }
}

static function int GetSayTypeIndex(string SayType)
{
    local int i;

    for (i = 0; i < default.SayTypes.Length; ++i)
    {
        if (SayType == default.SayTypes[i])
        {
            return i;
        }
    }

    return -1;
}

// If the current SayType is invalid, revert to the default say type.
function UpdateSayType()
{
    if (!CanUseSayType(SayType))
    {
        if (CanUseSayType(default.SayType))
        {
            SayType = default.SayType;
        }
        else
        {
            DecrementSayType();
        }
    }
}

function bool CanUseSayType(string SayType)
{
    local DHPlayer PC;

    PC = DHPlayer(ViewportOwner.Actor);

    if (PC == none)
    {
        return false;
    }

    switch (SayType)
    {
        case "Say":
            return true;
        case "TeamSay":
            return PC.PlayerReplicationInfo != none && PC.PlayerReplicationInfo.Team != none;
        case "SquadSay":
            return PC.IsInSquad();
        case "VehicleSay":
            return PC.Pawn != none && PC.Pawn.IsA('Vehicle');
        case "CommandSay":
            return PC.IsSquadLeader();
    }

    return false;
}

static function class<DHLocalMessage> GetSayTypeMessageClass(string SayType)
{
    // TODO: make struct of saytypes instead
    switch (SayType)
    {
        case "Say":
            return class'DHSayMessage';
        case "TeamSay":
            return class'DHTeamSayMessage';
        case "SquadSay":
            return class'DHSquadSayMessage';
        case "VehicleSay":
            return class'DHVehicleSayMessage';
        case "CommandSay":
            return class'DHCommandSayMessage';
    }

    return none;
}

function ConfirmAutoComplete()
{
    local string S;

    if (AutoCompleteStrPos != -1 && AutoCompleteIndex != -1)
    {
        S = FilteredAutoCompleteOptions[AutoCompleteIndex].OptionText;

        // a   @ b a s
        // a   @ B a s n e t t
        // 0 1 2 3 4 5 6 7 8 9 A B C
        // TODO: devise some sort of pre-formatted string token, treat entire
        // token as a single character. Need to use non-printable characters
        // to indicate the start/end of the tokens (do a little research)
        TypedStr = Left(TypedStr, AutoCompleteStrPos) $ S $ Mid(TypedStr, AutoCompleteStrPos + Len(AutoCompleteSearchText) + 1);
        TypedStrPos = AutoCompleteStrPos + Len(S) + 1;

        // Reset auto-complete.
        AutoCompleteStrPos = -1;
        AutoCompleteIndex = -1;
    }
}

state Typing
{
    function bool KeyType(EInputKey Key, optional string Unicode)
    {
        if (bIgnoreKeys)
        {
            return true;
        }

        if (Key >= 0x20)
        {
            if (Unicode != "")
            {
                TypedStr = Left(TypedStr, TypedStrPos) $ Unicode $ Right(TypedStr, Len(TypedStr) - TypedStrPos);
            }
            else
            {
                TypedStr = Left(TypedStr, TypedStrPos) $ Chr(Key) $ Right(TypedStr, Len(TypedStr) - TypedStrPos);
            }

            if (Unicode == AUTOCOMPLETE_CHARACTER)
            {
                BuildAutoCompleteOptions();
            }

            ++TypedStrPos;

            UpdateAutoCompleteState();

            // TODO: if we ever *erase* the auto-complete character we need to reflect that somehow

            return true;
        }

        return false;
    }

    function bool KeyEvent(EInputKey Key, EInputAction Action, FLOAT Delta)
    {
        local string Temp;

        if (Action == IST_Press)
        {
            bIgnoreKeys = false;
        }

        if (Key == IK_Escape)
        {
            if (TypedStr != "")
            {
                TypedStr = "";
                TypedStrPos = 0;
                UpdateAutoCompleteState();
                HistoryCur = HistoryTop;
                SayHistoryCur = -1;
            }
            else
            {
                TypingClose();
            }

             return true;
        }
        else if (Action != IST_Press)
        {
            return false;
        }
        else if (Key == IK_Enter)
        {
            if (TypedStr != "")
            {
                if (AutoCompleteStrPos != -1 && AutoCompleteIndex != -1)
                {
                    ConfirmAutoComplete();
                    return true;
                }
                History[HistoryTop] = SayType @ TypedStr;
                HistoryTop = (HistoryTop + 1) % arraycount(History);

                if (HistoryBot == -1 || HistoryBot == HistoryTop)
                {
                    HistoryBot = (HistoryBot + 1) % arraycount(History);
                }

                HistoryCur = HistoryTop;

                // SayHistory
                SayHistory.Insert(0, 1);
                SayHistory[0] = TypedStr;

                if (SayHistory.Length > SAY_HISTORY_MAX)
                {
                    SayHistory.Length = SAY_HISTORY_MAX;
                }

                SayHistoryCur = -1;

                // Make a local copy of the string.
                Temp = SayType @ TypedStr;
                TypedStr = "";
                TypedStrPos = 0;
                UpdateAutoCompleteState();

                if (!ConsoleCommand(Temp))
                {
                    Message(Localize("Errors", "Exec", "Core"), 6.0);
                }

                Message("", 6.0);
            }

            TypingClose();

            return true;
        }
        else if (Key == IK_Up)
        {
            if (SayHistory.Length == 0)
            {
                return true;
            }

            SayHistoryCur = (SayHistoryCur + 1) % SayHistory.Length;
            TypedStr = SayHistory[SayHistoryCur];
            TypedStrPos = Len(TypedStr);
            UpdateAutoCompleteState();

            return true;
        }

        else if (Key == IK_Down)
        {
            if (SayHistory.Length == 0)
            {
                return true;
            }

            if (SayHistoryCur == -1)
            {
                SayHistoryCur = SayHistory.Length;
            }

            SayHistoryCur = (SayHistoryCur - 1) % SayHistory.Length;
            TypedStr = Eval(SayHistoryCur == -1, "", SayHistory[SayHistoryCur]);
            TypedStrPos = Len(TypedStr);
            UpdateAutoCompleteState();
            return true;
        }
        else if (Key == IK_Backspace)
        {
            // TODO: check if we are still auto-completing anything

            if (TypedStrPos > 0)
            {
                TypedStr = Left(TypedStr, TypedStrPos - 1) $ Right(TypedStr, Len(TypedStr) - TypedStrPos);
                --TypedStrPos;
                UpdateAutoCompleteState();
            }

            return true;
        }
        else if (Key == IK_Delete)
        {
            if (TypedStrPos < Len(TypedStr))
            {
                TypedStr = Left(TypedStr, TypedStrPos) $ Right(TypedStr, Len(TypedStr) - TypedStrPos - 1);
                UpdateAutoCompleteState();
            }

            return true;
        }
        else if (Key == IK_Left)
        {
            TypedStrPos = Max(0, TypedStrPos - 1);
            UpdateAutoCompleteState();
            return true;
        }
        else if (Key == IK_Right)
        {
            TypedStrPos = Min(Len(TypedStr), TypedStrPos + 1);
            UpdateAutoCompleteState();
            return true;
        }
        else if (Key == IK_Home)
        {
            TypedStrPos = 0;
            UpdateAutoCompleteState();
            return true;
        }
        else if (Key == IK_End)
        {
            TypedStrPos = Len(TypedStr);
            UpdateAutoCompleteState();
            return true;
        }
        else if (Key == IK_Tab)
        {
            if (AutoCompleteStrPos != -1)
            {
                IncrementAutoCompleteIndex();
            }
            else
            {
                IncrementSayType();
            }
        }

        return true;
    }
}

defaultproperties
{
    NeedPasswordMenuClass="DH_Engine.DHGetPassword" // lol this doesn't even work, had to replace the reference to this with a direct string

    SayType="Say"
    SayTypes(0)="Say"
    SayTypes(1)="TeamSay"
    SayTypes(2)="SquadSay"
    SayTypes(3)="CommandSay"
    SayTypes(4)="VehicleSay"

    AutoCompleteIndex=-1
    AutoCompleteStrPos=-1
}

