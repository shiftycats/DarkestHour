//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DHHintManager extends Info
    config(User);

struct HintInfo
{
    var localized string    Title; // hint title, displayed on screen
    var localized string    Text;  // hint display text
};

const                   HINT_COUNT = 75;

var     HintInfo        Hints[HINT_COUNT];        // array of hints in default properties
var     array<byte>     QueuedHintIndices;        // queue of hints waiting to be displayed in turn
var     config byte     bUsedUpHints[HINT_COUNT]; // 0 = hint unused, 1 = hint used before (saved in player's local DarkestHouseUser.ini config file)
var     int             CurrentHintIndex;         // index number of the current or most recently displayed hint
var     float           PostHintDisplayDelay;     // how long to wait before displaying any other hint (value higher than 0 needed)

function PostBeginPlay()
{
    super.PostBeginPlay();

    StartCheckingForHints();
}

// Clears any hint queue and starts a repeating hint check timer
function StartCheckingForHints()
{
    QueuedHintIndices.Length = 0;
    QueueHint(0, true);     // Welcome to Darkest Hour!
    QueueHint(52);          // Situation Map
    QueueHint(50);          // Communication
    QueueHint(51);          // VOIP Communication
    SetTimer(1.0, true);
}

// Non-state repeating hint check timer goes to DisplayingHint state if it finds any queued hint(s)
simulated function Timer()
{
    if (QueuedHintIndices.Length > 0)
    {
        GotoState('DisplayingHint');
    }
}

// State while HUD is actively displaying a hint (the one at the front of the queue - index 0)
state DisplayingHint
{
    function BeginState()
    {
        local DHPlayer Player;

        Player = DHPlayer(Owner);

        // Make the HUD display the hint at the front of the queue
        if (Player != none && DHHud(Player.myHud) != none && !DHHud(Player.myHud).bHideHud)
        {
            CurrentHintIndex = QueuedHintIndices[0];
            DHHud(Player.myHud).ShowHint(Hints[CurrentHintIndex].Title, Hints[CurrentHintIndex].Text);
        }
        // But exit & resume repeating hint check timer if player doesn't have an active HUD
        else
        {
            SetTimer(1.0, true);
            GotoState('');
        }
    }

    // Receives notification from HUD that hint has finished displaying, so now we go to PostDisplay state
    function NotifyHintRenderingDone()
    {
        GotoState('PostDisplay');
    }
}

// State for a set period after a hint has finished displaying
state PostDisplay
{
    // Set a timer to exit this state after a set period
    function BeginState()
    {
        SetTimer(PostHintDisplayDelay, false);
    }

    // Delete the recently displayed hint, mark it as used, exit state & resume the repeating hint check timer
    function Timer()
    {
        bUsedUpHints[CurrentHintIndex] = 1;
        SaveConfig();
        QueuedHintIndices.Remove(0, 1);
        SetTimer(1.0, true);
        GotoState('');
    }
}

// Tries to add a new hint to the hint queue (valid if not previously used/displayed & same hint not already in the queue)
function QueueHint(byte HintIndex, optional bool bForceNext)
{
    local int i;

    if (bUsedUpHints[HintIndex] == 1) // exit as we're trying to display a hint that's already been used/shown
    {
        return;
    }

    for (i = 0; i < QueuedHintIndices.Length; ++i)
    {
        if (QueuedHintIndices[i] == HintIndex) // exit as we've found our new hint is already in the queue
        {
            return;
        }
    }

    // bForceNext means our new hint needs to go to the front of the queue
    if (bForceNext)
    {
        // If already displaying a hint, or in the PostHintDisplayDelay period immediately after, then insert our new hint as next one due after current/recent hint (index 1)
        if (IsInState('DisplayingHint') || IsInState('PostDisplay'))
        {
            QueuedHintIndices.Insert(1, 1);
            QueuedHintIndices[1] = HintIndex;
        }
        // Otherwise insert our new hint at the front of the queue (index 0)
        else
        {
            QueuedHintIndices.Insert(0, 1);
            QueuedHintIndices[0] = HintIndex;
        }
    }
    // Otherwise add new hint at the back of the queue
    else
    {
        QueuedHintIndices[QueuedHintIndices.Length] = HintIndex;
    }
}

// Resets previously used/shown hints, so they will be displayed again (called from menu, not in game)
static function StaticReset()
{
    local int i;

    for (i = 0; i < HINT_COUNT; ++i)
    {
        default.bUsedUpHints[i] = 0;
    }

    StaticSaveConfig();
}

// Resets previously used/shown hints, so they will be displayed again, then starts again (called from in game)
function NonStaticReset()
{
    local int i;

    for (i = 0; i < HINT_COUNT; ++i)
    {
        bUsedUpHints[i] = 0;
    }

    SaveConfig();

    GotoState('');
    SetTimer(0.0, false); // clear any timer
    StartCheckingForHints();
}

// Empty as implemented only in DisplayingHint state
function NotifyHintRenderingDone()
{
}

// Just used in other classes (DHPlayer) to get a member of the Hints array, avoiding "context expression: variable is too large" compiler errors
function HintInfo GetHint(int Index)
{
    return Hints[Index];
}

defaultproperties
{
    PostHintDisplayDelay=10.0
    Hints(0)=(Title="Welcome to Darkest Hour!",Text="These hint messages will show up periodically in the game. Pay attention to them, your survival might depend on it! They can be disabled from the HUD tab in the configuration menu.")
    Hints(1)=(Title="Mantling",Text="You are able to mantle on to small obstacles! To mantle, stand in front of any low obstacle until the mantling icon to appears then press %JUMP% to mantle on top of the obstacle.")
    Hints(2)=(Title="Parachutes",Text="You can guide your parachute's trajectory with your movement keys!")
    Hints(3)=(Title="Coloured Smoke Grenades",Text="Coloured smoke grenades are used to communicate on the battlefield with your teammates. Be sure to tell your teammates what the coloured smoke indicates.")
    Hints(6)=(Title="Mortars",Text="While you are holding a mortar you cannot change weapons, sprint, prone or mantle. To deploy your mortar, crouch on flat ground and press %DEPLOY%.")
    Hints(7)=(Title="Mortar Operation",Text="To adjust the traverse of your mortar, hold the A or D keys. To increase the elevation, press the S key. To decrease the elevation, press the W key. To select the next round type, press the %SwitchFireMode% key. To fire a round, press the %Fire% key.")
    Hints(8)=(Title="Artillery Targets",Text="An artillery observer can mark targets that become visible on your map. When a round lands near a target marker, the location of the impact will be marked your map. Use these markers to zero in on your target.")
    Hints(9)=(Title="Mortar Leaving",Text="You may leave your mortar at any time by pressing the %Use% key. While you are off your mortar, you can retrieve ammunition at a resupply area or from your teammates.")
    Hints(10)=(Title="Mortar Undeploy",Text="To undeploy your mortar, press the %Deploy% key. Undeploying your mortar will reset your elevation and traverse settings.")
    Hints(11)=(Title="Artillery Targeting",Text="You can mark targets for your team's mortar and artillery operators while sighted with your binoculars. Pressing %FIRE% to mark a high-explosive target or press %ALTFIRE% to request a smoke target.")
    Hints(12)=(Title="Artillery Officer",Text="You are an artillery officer. You can mark artillery targets with binoculars. Call in long-range artillery with from a radio position or with the help of a radio operator.")
    Hints(13)=(Title="Radio Operator",Text="You are a radio operator! The radio on your back can be used by friendly squad leaders to call in artillery strikes. Be sure to stick with your squad leader in case they need it!")

    Hints(40)=(Title="Vehicle Engines",Text="You have entered a vehicle. To start or stop the engine, press %FIRE%.")
    Hints(42)=(Title="Higgins Boat",Text="You are driving a Higgins boat. Lower the bow ramp by pressing %PREVWEAPON% so passengers and yourself can exit. To raise the bow ramp hit %NEXTWEAPON%.")
    Hints(43)=(Title="Resupply Trucks",Text="You are close to a resupply truck. Stand outside the back of the truck to resupply your ammunition.")
    Hints(44)=(Title="Resupply Trucks",Text="You are driving a resupply truck. This vehicle can resupply vehicles, mortars and infantry. Be sure to park it in a safe place.")
    Hints(46)=(Title="Externally mounted MG",Text="This machine gun is externally mounted and can only be fired or reloaded if you unbutton the hatch")
    Hints(47)=(Title="Remote controlled MG",Text="This machine gun can only be fired from inside the vehicle, but it is externally mounted and you must unbutton the hatch to reload")
    Hints(48)=(Title="Externally mounted MG reload",Text="You need to unbutton the hatch (& not be using binoculars) to reload this externally mounted machine gun")

    Hints(50)=(Title="Communication",Text="On the battlefield, communication is king! Press %STARTTYPING% to begin a text message. While typing, you can press TAB to cycle through communication channels.")
    Hints(51)=(Title="VOIP Communication",Text="Use a microphone for communicating with your teammates! Press and hold %VOICETALK% to activate your microphone.")
    Hints(52)=(Title="Situation Map",Text="Get situated! Press %SHOWOBJECTIVES% to toggle display of the situation map.")
    Hints(53)=(Title="Map Interaction",Text="While viewing the situation map, you can press %JUMP% to toggle map interaction. You can zoom (scroll wheel) and pan (left-click and drag) the map.")
    Hints(54)=(Title="Welcome, Squad Leader!",Text="You are now a squad leader! As a squad leader, your main job is to keep your squad fighting and working together effectively. Being a great squad leader can make all the difference in battle. These hint messages will help you get oriented in your new role!")
    Hints(55)=(Title="Command Menu",Text="As a squad leader or assistant, press and hold [%CAPSLOCK%] to bring up your command menu. From this menu, you can place constructions, create rally points, spot enemies and more!")
    Hints(56)=(Title="Squad Rally Points",Text="You are able to place rally points (spawn points) by pressing %PLACERALLYPOINT% when you have at least one other squadmate nearby. The rally point indicator in the bottom right of your screen indicates your ability to place a rally point.")
    Hints(57)=(Title="Squad Rally Points",Text="Keeping at least one rally point active for your squad is the single most important thing you can do as a squad leader. Without one, it will be difficult for your squad to get to the front lines and fight together.")
    Hints(58)=(Title="Squad Orders",Text="It’s important to let your squad know objective (eg. attack, defend, move). You can set your squad’s current objective by right-clicking on the situation map.")
    Hints(59)=(Title="Squad Rally Points",Text="Enemy fire and nearby enemies can destroy your squad’s rally points. Be sure to place them in safe areas so that you and your squad can get to the front lines quickly!")
    Hints(60)=(Title="Managing Rally Points",Text="You are able to maintain two (2) rally points at once. However, only one may be active at a time. From the situation map, you can swap the active rally point by right-clicking the active rally point and selecting “Set as Secondary”.")
    Hints(61)=(Title="Behind Enemy Lines",Text="You are behind enemy lines! Rally points behind enemy lines are less effective. Be sure to place your squad’s rally points in your own territory whenever possible.")
    Hints(62)=(Title="Map Markers",Text="As a squad leader or assistant, you are able to place markers on the map that are visible to your whole team. To add a marker, right-click the map and select one of the markers. For example, you can add an “Enemy Tank”marker to alert your team of enemy tank in an area.")
    Hints(63)=(Title="Shovels",Text="The shovel is used to build constructions. Press [%FIRE%] while looking at a friendly construction to help in the build effort!")
    Hints(64)=(Title="Shovels",Text="Shovels can also be used to deconstruct constructions! Press [%ALTFIRE%] while looking at a construction to begin deconstruction. If a friendly supply cache is nearby, the supply cost of deconstructed friendly constructions will be refunded to that cache. In a pinch, they can also be used as a melee weapon!")
    Hints(65)=(Title="Logistics & Supply",Text="You are in a supply zone! This means that there is a nearby supply truck or supply cache. Supplies are used for the creation of constructions such as anti-tank guns, resupply points and fortifications. While you are in a supply zone, the number of available supplies will be displayed at the top of your screen.")
    Hints(66)=(Title="Platoon HQ",Text="A Platoon HQ is an extremely useful construction as it provides a team-wide spawn point. An effective team will be sure to always build Platoon HQs in safe areas so that your forces can get to the battlefield quickly.")
    Hints(67)=(Title="Squad Assistants",Text="Being a squad leader can sometimes be a tough job! To help you manage your squad, you can assign one of your squad members to be your assistant. Squad assistants are able to place constructions and create map markers. To assign an assistant, press [%SQUADMENU%], then right-click one of your squad members, and select “Assign as Assistant”.")
    Hints(68)=(Title="Squad Management",Text="To manage your squad members, press [%SQUADMENU%] and right-click a squad member. You may also look at your squadmate and use the Command Menu (%SHOWORDERMENU%).")
    Hints(69)=(Title="Squad Invites",Text="You can invite unassigned teammates to your squad by looking at them and bringing up the Command Menu (%SHOWORDERMENU%), then selecting the player option.")
    Hints(70)=(Title="Supply Cache",Text="Supply Caches are constructions that store and slowly generate supplies over time. Be sure that you and your team create new Supply Caches as the battle progresses so that supplies are always within reach.")
    Hints(71)=(Title="Supply Transfers",Text="While driving a Logistics Truck near a Supply Cache, you are able to transfer supplies between your truck and the Supply Cache. This can be extremely useful for moving supplies around the battlefield! Press [%RELOAD%] to load supplies, and [%ROMGOPERATION%] to unload supplies from the truck.")
    Hints(72)=(Title="Radio Operator",Text="You are a radio operator! The radio on your back can be used by friendly squad leaders to call in artillery strikes, so be sure to stick with your squad leader in case they need it!")
    Hints(73)=(Title="Constructions",Text="As a squad leader, you can create constructions (fortifications, ammunition to help your team in the fight.Most constructions cost supplies to create. Some constructions like the")
    Hints(74)=(Title="Command Chat",Text="As a squad leader, you have access to a private Command chat channel for squad leaders only. Use this channel to")
    Hints(75)=(Title="VOIP Channel",Text="To switch between Squad and Local (proximity) VOIP channels, press %SPEAK SQUAD% and %SPEAK LOCAL%, respectively.")
}

