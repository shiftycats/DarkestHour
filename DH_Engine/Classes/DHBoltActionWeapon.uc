//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DHBoltActionWeapon extends DHProjectileWeapon
    abstract;

enum EReloadState
{
    RS_None,
    RS_PreReload,
    RS_ReloadLooped,
    RS_PostReload,
    RS_FullReload
};

var     EReloadState    ReloadState;        // weapon's current reloading state (none means not reloading)
var     bool            bInterruptReload;   // set when one-by-one reload is stopped by player part way through, by pressing fire button

var     name            PreReloadAnim;      // one-off anim when starting to reload
var     name            PreReloadHalfAnim;  // same as above, but when there are one or more rounds in the chamber

var     name            SingleReloadAnim;       // looping anim for inserting a single round
var     name            SingleReloadHalfAnim;   // same as above, but when there are one or more rounds in the chamber

var     name            StripperReloadAnim; // stripper clip reload animation

var     name            PostReloadAnim;     // one-off anim when reloading ends

var     name            FullReloadAnim;     // full reload animation (takes precedence!)

var     int             NumRoundsToLoad;    // how many rounds to be loaded to fill the weapon

// TODO: for refactoring this, when we try to do a reload,
// check if the magazine is empty enough for a full stripper clip to be
// reloaded. if so, do the full stripper clip (N times if need be, unless cancelled!)
// if we can't fit a whole new stripper clip in, we go to *single* reload mode.
// when we do that, we essentially consume a whole clip to break down into singles
// and keep track of the number of singles. if at the end of a reload, we have
// enough singles to make a new clip, consolidate the singles into a clip.
replication
{
    // Functions a client can call on the server
    reliable if (Role < ROLE_Authority)
        ServerSetInterruptReload, ServerPreformReload;
}

// Modified to work the bolt when fire is pressed, if weapon is waiting to bolt
simulated function Fire(float F)
{
    if (bWaitingToBolt && !IsBusy())
    {
        WorkBolt();
    }
    else
    {
        super.Fire(F);
    }
}
simulated event ClientStartFire(int Mode)
{
    Super.ClientStartFire(Mode);
    Log("Post Fire Ammo "$AmmoAmount(0));
}

event ServerStartFire(byte Mode)
{
    Super.ServerStartFire(Mode);
    //Log("Server Start Fire "$AmmoAmount(0));
}

function ServerStopFire(byte Mode)
{
    Super.ServerStopFire(Mode);
    Log("Server Stop Fire "$AmmoAmount(0));
}


// New function to work the bolt
simulated function WorkBolt()
{
    if (bWaitingToBolt && AmmoAmount(0) > 0 && !FireMode[1].bIsFiring && !FireMode[1].IsInState('MeleeAttacking'))
    {
        GotoState('WorkingBolt');

        if (Role < ROLE_Authority)
        {
            ServerWorkBolt();
        }
    }
}

// Client-to-server function to work the bolt
function ServerWorkBolt()
{
    WorkBolt();
}

// State where the bolt is being worked
simulated state WorkingBolt extends WeaponBusy
{
    simulated function bool ShouldUseFreeAim()
    {
        return global.ShouldUseFreeAim();
    }

    simulated function bool WeaponAllowSprint()
    {
        return false;
    }

    simulated function bool CanStartCrawlMoving()
    {
        return false;
    }

    simulated function AnimEnd(int Channel)
    {
        local name  Anim;
        local float Frame, Rate;

        if (InstigatorIsLocallyControlled())
        {
            GetAnimParams(0, Anim, Frame, Rate);

            if (Anim == BoltIronAnim || Anim == BoltHipAnim)
            {
                bWaitingToBolt = false;
            }
        }

        super.AnimEnd(Channel);

        GotoState('Idle');
    }

    simulated function BeginState()
    {
        if (bUsingSights)
        {
            if (bPlayerFOVZooms && InstigatorIsLocallyControlled())
            {
                PlayerViewZoom(false);
            }

            PlayAnimAndSetTimer(BoltIronAnim, 1.0, 0.1);
        }
        else
        {
            PlayAnimAndSetTimer(BoltHipAnim, 1.0, 0.1);
        }

        if (Role == ROLE_Authority && ROPawn(Instigator) != none)
        {
            ROPawn(Instigator).HandleBoltAction(); // play the animation on the pawn
        }
    }

    simulated function EndState()
    {
        if (bUsingSights && bPlayerFOVZooms && InstigatorIsLocallyControlled())
        {
            PlayerViewZoom(true);
        }

        bWaitingToBolt = false;
        FireMode[0].NextFireTime = Level.TimeSeconds - 0.1; // ready to fire fire now
    }
}

// Called by the weapon fire code to send the weapon to the post firing state
simulated function PostFire()
{
    GotoState('PostFiring');
}

// State where the weapon has just been fired
simulated state PostFiring
{
    simulated function bool ReadyToFire(int Mode)
    {
        return false;
    }

    simulated function Timer()
    {
        if (!InstigatorIsHumanControlled())
        {
            if (AmmoAmount(0) > 0)
            {
                GotoState('WorkingBolt');
            }
            else
            {
               GotoState('Reloading');
            }
        }
        else
        {
            GotoState('Idle');
        }
    }

    simulated function BeginState()
    {
        bWaitingToBolt = true;

        if (bUsingSights && DHProjectileFire(FireMode[0]) != none)
        {
            SetTimer(GetAnimDuration(DHProjectileFire(FireMode[0]).FireIronAnim, 1.0), false);
        }
        else
        {
            SetTimer(GetAnimDuration(FireMode[0].FireAnim, 1.0), false);
        }
    }
}

// Modified so bots don't go straight to the reloading state on bolt actions
simulated function OutOfAmmo()
{
    super(ROWeapon).OutOfAmmo();
}

simulated function int GetStripperClipSize()
{
    return 5;   // TODO: get this from the ammo class??
}

// Modified to update number of individual spare rounds
// As weapon doesn't used mags, the existing replicated CurrentMagCount is used to represent the total no. of individual spare rounds
// This is calculated by adding up the rounds in each dummy 'mag' (just a data grouping of individual spare rounds)
// This is primarily used by net clients to display the no. of spare rounds carried, as clients don't have PrimaryAmmoArray data
function UpdateResupplyStatus(bool bCurrentWeapon)
{
    local DHPawn P;
    local int    NumSpareRounds, DummyMagCount, i;

    if (bCurrentWeapon)
    {
        for (i = 1; i < PrimaryAmmoArray.Length; ++i)
        {
            NumSpareRounds += PrimaryAmmoArray[i];
        }

        CurrentMagCount = byte(NumSpareRounds);
    }

    P = DHPawn(Instigator);

    if (P != none)
    {
        DummyMagCount = Max(0, PrimaryAmmoArray.Length - 1); // what CurrentMagCount would normally be, used below to set bWeaponNeedsResupply

        P.bWeaponNeedsResupply = bCanBeResupplied && bCurrentWeapon && DummyMagCount < (MaxNumPrimaryMags - 1) && (TeamIndex == 2 || TeamIndex == P.GetTeamNum());
        P.bWeaponNeedsReload = false;
    }
}

// Modified to prevent reloading if weapon is already reloading or has maximum ammo
simulated function bool AllowReload()
{
    return ReloadState == RS_None && !AmmoMaxed(0) && !IsFiring() && !IsBusy() && CurrentMagCount > 0 && GetRoundsToLoad() > 0;
}





// Modified to allow reloading of individual rounds
function ServerRequestReload()
{
    local byte ReloadAmount;

    if (AllowReload())
    {
        ReloadAmount = GetRoundsToLoad();

        if (Level.NetMode == NM_DedicatedServer)
        {
            NumRoundsToLoad = ReloadAmount;
            GotoState('Reloading');
        }

        ClientDoReload(ReloadAmount);
    }
    else
    {
        ClientCancelReload();
    }
}

// Modified to update (on the client) the number of rounds to be reloaded
simulated function ClientDoReload(optional byte NumRounds)
{
    NumRoundsToLoad = NumRounds;

    super.ClientDoReload(NumRounds);
}

// Out of state this does nothing & should never be called anyway - it is only effective in state Reloading
function ServerSetInterruptReload()
{
}

// Modified to handle substantially different one round at a time reload system
simulated state Reloading
{
    // Modified to allow interruption of reload by pressing fire
    simulated function Fire(float F)
    {
        if (ReloadState != RS_PostReload)
        {
            bInterruptReload = true;
            ServerSetInterruptReload();
        }
    }

    // New replicated client-to-server function to set bInterruptReload on server
    function ServerSetInterruptReload()
    {
        bInterruptReload = true;
    }

    // Modified to progress through reload stages, playing appropriate anims
    simulated function AnimEnd(int Channel)
    {
        local name  Anim;
        local float Frame, Rate;
        local int ReloadCount;

        //Log("Animation End");

        if (InstigatorIsLocallyControlled())
        {
            GetAnimParams(0, Anim, Frame, Rate);

            // Just finished playing pre-reload anim so now load 1st round
            if (Anim == PreReloadAnim || Anim == PreReloadHalfAnim)
            {
                Log("End Animation Preload");
                SetTimer(0.0, false);

                ReloadState = RS_ReloadLooped;

                PlayReload();

                return;
            }
            else if (Anim == FullReloadAnim)
            {
                Log("End Of Full Reload Animation");
                ReloadState = RS_None;

                if (Role == ROLE_Authority)
                {
                    if (ROPawn(Instigator) != none)
                    {
                        ROPawn(Instigator).StopReload();
                    }

                    //PerformReload(GetMaxLoadedRounds());

                }
                //ServerPreformReload(GetMaxLoadedRounds());
                GotoState('Idle');
            }
            // Just finished playing a single round reload anim
            else if (Anim == SingleReloadAnim || Anim == SingleReloadHalfAnim || Anim == StripperReloadAnim)
            {
                Log("Finished Single Reload");
                // TODO: Alternatively, change this to be some sort of class-level variable.
                if (Anim == SingleReloadAnim || Anim == SingleReloadHalfAnim)
                {
                    ReloadCount = 1;
                }
                else if (Anim == StripperReloadAnim)
                {
                    ReloadCount = GetStripperClipSize();
                }

                // Either loaded last round or player stopped the reload (by pressing fire), so now play post-reload anim
                if (NumRoundsToLoad <= 0 || bInterruptReload)
                {
                    SetTimer(0.0, false);
                    bInterruptReload = false;
                    ReloadState = RS_PostReload;
                    PlayPostReload();

                    if (Role == ROLE_Authority)
                    {
                        if (ROPawn(Instigator) != none)
                        {
                            ROPawn(Instigator).StopReload();
                        }
                    }

                    //PerformReload(ReloadCount);
                    //ServerPreformReload(ReloadCount);
                }
                // Otherwise start loading the next round
                else
                {
                    PlayReload();

                    if (Role == ROLE_Authority)
                    {
                        PerformReload(ReloadCount);
                    }
                }

                return;
            }
        }
    }

    // Modified to progress through reload stages
    simulated function Timer()
    {
        Log("Timer:");
        // Just finished pre-reload anim so now load 1st round
        if (ReloadState == RS_PreReload)
        {
            Log("Timer PreReload");

            // give back the unfired round that was in the chamber
            if(!bWaitingToBolt)
            {
                GiveBackAmmo(1);
            }

            PlayReload();

            if (Role == ROLE_Authority)
            {
                if (NumRoundsToLoad >= GetStripperClipSize())
                {
                    NumRoundsToLoad -= GetStripperClipSize();
                    ReloadState = RS_FullReload;
                }
                else
                {
                    --NumRoundsToLoad;
                    ReloadState = RS_ReloadLooped;
                }
            }
        }
        // Just finished loading some ammo
        else if (ReloadState == RS_ReloadLooped || ReloadState == RS_FullReload)
        {
            // Either loaded last round or player stopped the reload (by pressing fire), so now play post-reload anim
            if ( (NumRoundsToLoad == 0 || bInterruptReload) && ReloadState == RS_ReloadLooped)
            {
                if (Role == ROLE_Authority)
                {
                    if (ROPawn(Instigator) != none)
                    {
                        ROPawn(Instigator).StopReload();
                    }


                    PerformReload();
                }

                bInterruptReload = false;
                ReloadState = RS_PostReload;
                PlayPostReload();
            }
            else if (ReloadState == RS_FullReload && (NumRoundsToLoad == 0 || bInterruptReload))
            {
                Log("Timer Final ");
                PerformReload(GetStripperClipSize());
                GotoState('Idle');
            }
            // Otherwise start loading the next round
            else
            {
                PlayReload();

                if (Role == ROLE_Authority)
                {

                    //based on state we just finished animating, give appropriate ammo.
                    if(ReloadState == RS_FullReload)
                    {
                        PerformReload(GetStripperClipSize());
                    }
                    else if (ReloadState == RS_ReloadLooped)
                    {
                       PerformReload();
                    }

                    //decide next reload type.
                    if (NumRoundsToLoad >= GetStripperClipSize())
                    {
                        NumRoundsToLoad -= GetStripperClipSize();
                        ReloadState = RS_FullReload;
                    }
                    else
                    {
                        --NumRoundsToLoad;
                        ReloadState = RS_ReloadLooped;
                    }
                }
            }
        }
        // Just finished post-reload or full-reload anim so we're finished
        else if (ReloadState == RS_PostReload)
        {
            GotoState('Idle');
        }
    }

    simulated function BeginState()
    {
        Log("Entering Reload State");
        if (Role == ROLE_Authority && ROPawn(Instigator) != none)
        {
            ROPawn(Instigator).StartReload();
        }

        if (ReloadState == RS_None)
        {
            //if (AmmoAmount(0) == 0 && HasAnim(FullReloadAnim))
            if (NumRoundsToLoad >= GetStripperClipSize() && HasAnim(FullReloadAnim))
            {
                //give back the unfired round in the chamber
                if(!bWaitingToBolt)
                {
                    GiveBackAmmo(1);
                }

                Log("Play Full Reload");
                ReloadState = RS_FullReload;
                NumRoundsToLoad -= GetStripperClipSize();
                PlayFullReload();

            }
            else
            {
                ReloadState = RS_PreReload;
                PlayAnimAndSetTimer(GetPreReloadAnim(), 1.0);
            }
        }
    }

    simulated function EndState()
    {
        if (ReloadState == RS_PostReload || ReloadState == RS_FullReload)
        {
            Log("Current Ammo: "$AmmoAmount(0));
            NumRoundsToLoad = 0;
            bWaitingToBolt = false;
            ReloadState = RS_None;
        }
    }
}

simulated function bool CanLoadStripperClip()
{
    return HasAnim(StripperReloadAnim) && NumRoundsToLoad >= GetStripperClipSize();
}

// Modified to use single reload animation (without adding FastTweenTime to timer), & to decrement the number of rounds to load
simulated function PlayReload()
{
    //Log("Play Reload");

    if (InstigatorIsLocallyControlled())
    {
        //Log("Local Control");
        if (CanLoadStripperClip())
        {
            NumRoundsToLoad -= GetStripperClipSize();
            PlayAnimAndSetTimer(StripperReloadAnim, 1.0);
        }
        else
        {
            //Log("Single Animation");
            NumRoundsToLoad -= 1;

            PlayAnimAndSetTimer(GetSingleReloadAnim(), 1.0);
        }
    }
    else
    {

        //GetAnimDuration(Anim, AnimRate)
        if (CanLoadStripperClip())
        {
            Log("SERVER STRIPPER SET TIMER");

            //PlayAnimAndSetTimer(StripperReloadAnim, 1.0);
           SetTimer(GetAnimDuration(StripperReloadAnim,1.0),false);
        }
        else
        {


            //PlayAnimAndSetTimer(GetSingleReloadAnim(), 1.0);
            Log("SERVER SINGLE SET TIMER");
            SetTimer(GetAnimDuration(GetSingleReloadAnim(),1.0),false);
       }
        //SetTimer(,false);
    }
}

simulated function name GetPreReloadAnim()
{
    if (AmmoAmount(0) > 0 && HasAnim(PreReloadHalfAnim))
    {
        return PreReloadHalfAnim;
    }

    return PreReloadAnim;
}

simulated function name GetSingleReloadAnim()
{
    if (AmmoAmount(0) > 0 && HasAnim(SingleReloadHalfAnim))
    {
        return SingleReloadHalfAnim;
    }

    return SingleReloadAnim;
}

simulated function PlayFullReload()
{
    local float Duration;

    Duration = GetAnimDuration(FullReloadAnim, 1.0);

    Level.Game.Broadcast(self, Duration);

    SetTimer(GetAnimDuration(FullReloadAnim, 1.0), false);

    if (InstigatorIsLocallyControlled() && HasAnim(FullReloadAnim))
    {
        PlayAnim(FullReloadAnim, 1.0);
    }
}

// New function to play PostReloadAnim & set a timer for when it ends (without adding FastTweenTime to timer)
simulated function PlayPostReload()
{
    SetTimer(GetAnimDuration(PostReloadAnim, 1.0), false);

    if (InstigatorIsLocallyControlled() && HasAnim(PostReloadAnim))
    {
        PlayAnim(PostReloadAnim, 1.0);
    }
}

simulated function int GetMaxLoadedRounds()
{
    return AmmoClass[0].default.InitialAmount;
}

// New function to calculate the number of rounds to be loaded to fill the weapon
simulated function byte GetRoundsToLoad()
{
    local int  CurrentLoadedRounds, MaxLoadedRounds;
    local byte AmountNeeded;

    if (CurrentMagCount == 0)
    {
        return 0;
    }

    CurrentLoadedRounds = AmmoAmount(0) - int(!bWaitingToBolt);

    //ensure we haven't dipped below 0
    CurrentLoadedRounds = Max(0,CurrentLoadedRounds);

    MaxLoadedRounds = GetMaxLoadedRounds();
    AmountNeeded = MaxLoadedRounds - CurrentLoadedRounds;

    return Min(AmountNeeded, CurrentMagCount);
}


function ServerPreformReload(optional int Count)
{
    PerformReload(Count);
}

// Modified to load one round each time
// 'Mags' for this weapon aren't really mags, they are just dummy mags that act as data groupings of individual spare rounds
// Each dummy mag contains the max no. of rounds that can be loaded into the weapon
// Mag zero represents the weapon's currently loaded rounds (so CurrentMagIndex is not cycled as usual & always remains zero)
// When reloading, individual rounds are stripped one at a time from mag 1 & loaded into the weapon
// When mag 1 is empty it is deleted (removed from PrimaryAmmoArray) so the next mag becomes mag 1 & that is used for any further loading
// It's done this way to work with existing mag-based functionality, while allowing one at a time loading up to a max no. limited by the dummy mag size
function PerformReload(optional int Count)
{
    local int loaded,withdraw; // How many rounds have been loaded in so far.



    // TODO: we need to deduct 5 after reloading a stripper clip!
    // server + client need to know about this (use different state, maybe, or keep track of how many we are loading (pass arg??)
    if (CurrentMagCount < 1 || PrimaryAmmoArray.Length <= 1)
    {
        return;
    }

    // Ensure we attempt to reload at least one.
    Count = Max(1, Count);
    Log("Preform Reload: "$Count);


    loaded = 0;
    while (loaded < Count)
    {
        // Check if there is a first mag to deduct from
        if(PrimaryAmmoArray.Length == 1)
        {
            break;
        }

        withdraw = 0;

        // take all the rounds in the mag as possible.
        withdraw = Min(Count - loaded, PrimaryAmmoArray[1]);
        PrimaryAmmoArray[1] -= withdraw;
        loaded += withdraw;

        // If mag is now empty, delete it.
        if(PrimaryAmmoArray[1] == 0)
        {
            PrimaryAmmoArray.Remove(0, 1);
        }
    }

    AddAmmo(loaded,0);

    // Update the weapon attachment ammo status
    if (AmmoAmount(0) > 0 && ROWeaponAttachment(ThirdPersonActor) != none)
    {
        ROWeaponAttachment(ThirdPersonActor).bOutOfAmmo = false;
    }

    UpdateResupplyStatus(true);
}


function GiveBackAmmo(int Count)
{
    if (CurrentMagCount < 1 || PrimaryAmmoArray.Length <= 1)
    {
        return;
    }
    Log (PrimaryAmmoArray[0]);
    PrimaryAmmoArray[1] += Count;
    PrimaryAmmoArray[0] -= Count;

    // Update the weapon attachment ammo status
    if (AmmoAmount(0) > 0 && ROWeaponAttachment(ThirdPersonActor) != none)
    {
        ROWeaponAttachment(ThirdPersonActor).bOutOfAmmo = false;
    }

    UpdateResupplyStatus(true);
}

simulated function bool ShouldDrawPortal()
{
    local name SeqName;
    local float AnimFrame, AnimRate;

    if (!super.ShouldDrawPortal())
    {
        return false;
    }

    GetAnimParams(0, SeqName, AnimFrame, AnimRate);

    return SeqName != PostFireIronIdleAnim;
}

defaultproperties
{
    SwayModifyFactor=0.6

    FreeAimRotationSpeed=6.0
    BobModifyFactor=0.66
    ZoomOutTime=0.4

    IronIdleAnim="Iron_idle"
    PostFireIdleAnim="Idle"
    PostFireIronIdleAnim="Iron_idlerest"
    BoltHipAnim="bolt"
    BoltIronAnim="iron_boltrest"
    MagEmptyReloadAnim="Reload"

    AIRating=0.4
    CurrentRating=0.4
    bSniping=true
}
