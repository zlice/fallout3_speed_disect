# Fallout 3 Speed Cripple Dissect pt 2

I finally came back to this and came up with a couple (mostly) workable
solutions for speed cripple :) It's still a headache, and has a lot of
factors that can ruin your day. But here's the semi-working fixes.

# TLDR pt 2 (fixes)

### What happens? pt 2

The 1st person hurt animation files seem to be in contention with the
other threads running while loading. If they are slightly slower to load
and everything else is able to finish for QL before cripple goes through -
you can get Speed Cripple easier.

### Drop cache memory

Simply dropping "page cache" on Linux or "Standby List/Memory" on
Windows before restarting the game makes things easier, way easier.

**linux** - `echo 3 > /proc/sys/vm/drop_caches && sync`

On **Windows** I don't have an 'as easy' and verified safe simple tool but
these should be less trouble that 5 billion restarts or 5 hours of not
being able to get speed cripple

---

**RamMap** - https://learn.microsoft.com/en-us/sysinternals/downloads/rammap

This is the safest (as it is a Microsoft tool) if you don't want to worry.

Click `Empty > Standby List`

---

**ISLC** - https://www.wagnardsoft.com/forums/viewtopic.php?t=1256

This is the same software person (vendor?) as DDU commonly used to
fix GPU driver issues.

It's 1 less click ¯\\\_(ツ)_/¯ but, it may flag on virustotal or an
anti-virus from what I was told

---

**EmptyStandbyList.exe** - https://www.downloadcrew.com/article/34150/empty_standby_list

This is a command line tool that you could double click or run in
a `cmd` prompt, but I have no idea where it is originally from.

https://www.portablefreeware.com/forums/viewtopic.php?t=25783

This link claims a virus total scan and has a hash, but the original
wj32 [dot] org site doesn't load for me and I have seen the site
flagged as bad while searching around.

---

### Files On Slower USB (put it on a floppy lol)

Ok no, but seriously I do want to find an adapter and try a floppy now.

I put the animations responsible for speed cripple on a microSD
card with a USB adapter, then symlinked 4 files to
`Fallout3/Data/meshes/characters/_male/locomotion/hurt`.
This may even be a better option than dropping memory cache.

However, sadly, while my microSD works like a charm, another USB
drive I have does not seem to work at all. It may be too slow, as
when I first fired a missile it paused the entire game for a few
seconds.

You will have to use a bsa extractor like
[BAE](https://www.nexusmods.com/skyrimspecialedition/mods/974/)
to grab the required animation files from `Fallout - Meshes.bsa`

##### mtfastbackward_hurt.kf
##### mtfastleft_hurt.kf
##### mtfastforward_hurt.kf
##### mtfastright_hurt.kf

Per file I ran

**linux** `ln -s /usb/anim.kf /path/to/Fallout3/.../hurt/anim.kf`

**windows** `mklink /h C:\path\to\Fallout3\...\hurt\anim.kf E:\anim.kf`

(mklink symbolic links require admin privs for some reason, this is a 'hard' link)

For simplicity, you should be able put the kf files and the appropriate script in
your FO3 Data directory and run from there

[linux-script](./src/linux-sc-symlink.sh)
or
[windows-bat](./src/windows-sc-hardlink.bat)

Obviously you need to 'load loose files' aka `bInvalidateOlderFiles=1` in FalloutPrefs.ini

---

Neither of these are a 100% fix for everyone as you'll see if you read ahead.
But I had no issue getting SC with them and it mostly worked for someone else
testing until they had other factors at play.

# Speed Cripple (Thread Theories)
\============================================================================

There are still a few things to note about speed cripple. It is very
finicky and quite a few things can go wrong that prevent it from being
obtainable at all.

## OS Threading (rambling)

There are plenty of 'gotchyas' when it comes to threading. FO3 has tons of
calls from `CreateThread` (or semaphore or mutex), `WaitForSingleObject` and
`GetTickCount` (which can have 10-16ms of bad accuracy on 32bit machines).

Without going into too much detail, just know that none of these thread
related calls or processes are quite perfect. Especially back in the 32bit
days when dual core CPUs were just created.

## FO3 Threading Overview

There are around 40 threads running for me when I am playing Fallout 3.
A good chunk of these these are audio related. A dozen or so are DirectX9
rendering. The rest are a mix of normal, low, and timecritical (high)
priority Fallout 3 threads. There is a main `BSTaskManagerThread` and
`BackgroundCloneThread` (some type of backup? it seems inactive).
Another is helpfully labeled from the `ps` (linux list process) command:
`Fallout:disk$0`.

The biggest problem, as mentioned originally, is that trying to debug
threads causes all kinds of problems and most of the times crashes
FO3 entirely (since it expect some areas to be time sensitive and work
together in sync).

Without seeing things happen directly, here is what seems to be happening.

## Getting SC

- You get crippled
- The game starts loading animations
- You quick load
- The cripple animations are loading **slower** than expected
- The cripple load pauses while waiting for disk files
- All other QL-bound threads **finish** (or at least pause)
- The game loads goes ahead with QL because the current game 'stopped'
- The game loads the save file's normal animations
- The cripple animations resume loading, then stop because they're no longer needed
- You have speed cripple (or 3rd person only, reverse SC, forward SC only, etc)

There may be something else going on in the last couple steps. Maybe an old
thread doesn't quit but instead thinks the old game is still going? Could
be a few things really going on.

# Speed Cripple Still Haunts you
\============================================================================

## Facts / Show Stoppers

Under normal conditions (not using the tweaks above) these all seem to
be true, or are complete true.

**#1.** The save file doesn't really matter

You can restart the game and load the same save you got SC from and hour ago
but not be able to get it again, or vice versa.

**#2.** 3rd person cripple wobble but normal speed is easy to get

When failing to get SC, you get the 3rd person hurt animation half the time.

**#3.** 3rd person wobble is obtainable with every Fallout thread on a single CPU core

The same hurt animation will happen on a single CPU core.

(However SC does not seem possible even after hours of trying.
This may be performance related. This may be due to load order by name.)

**#4.** Limb damage is RNG

There is RNG in what limbs take damage when you fire a missile. Some of it
may come down to timing but it does not seem humanly possible to reproduce
what limbs get hurt. Looking up instead of down affects what limbs get hurt.
But loading and pressing a keyboard key for attack can hurt different limbs.
Cliff cripple by falling, and the extra physics calculations, I'm sure are
even more RNG.

**#5.** Invincible limbs

This seems harder than SC but I have done it a handful of times. Even with
a missile straight to my feet, limbs-will-not-damage. Healing so you don't
die and trying over and over, certain limbs can become invincible.

Obviously, this can prevent SC.

**#6.** The game doesn't track everything, always, all the time

From looking at the [Void Swim Glitch](./SWIM.md) it is obvious the game
is not 100% accurate in player state, game state, anything. There is an area
54 bytes into the `player` memory that toggles from `102000` (not crippled)
and `102001` (crippled) that seems tracked well, but funny enough changing
the value manually does not seem to have any effect.

Another indicator of this is having a 'zoom-in' as if you were trying to aim
after failing cliff cripple. I never really noticed this until I was testing
with my casual ini settings, which have a bigger FOV.

**#7.** NG+ seems to make SC easy to get

There are multiple people who have been able to get SC, cripple themselves
(losing SC), go to the main menu (NOT exit game), and then load a save and
re-get SC very easy, maybe easier than the above fixes.

This heavily implies there is some type of internal state that helps the
game get SC even without any quirky setup outside of the game itself. Is
this memory related? Thread ordering? System thread scheduling or CPU/core
priority/ordering? It's hard to say.

**#8.** Reverse SC is possible

This is known, but it is important given pickiness of these glitches.
The 1st person 'hurt' animation applies without the 'boost' animation
that is responsible for SC.

**#9.** GPU or CPU intensive programs in the background can interfere

Recording or streaming can cause the memory drop cache fixes to not help.
There have been multiple reports before of people being able to get SC fine
until they go to record a run.

**#10.** HUD, audio and other threads are always running

The HUD PibBoy limb diagram can stay the same or even get stuck while trying
to get SC (going haywire with missile and QL can do this at the right frames).
Quest dialog timers don't seem to care about QL and keep playing.
Audio still plays differently when in pipboy, vs paused, vs the game in the
background running. Which leads us to...

**#11.** This is all threading woes

That you can put a file on a slower device and it allows you to get SC with
ease is a sign of threading, much like many of the above mentions.

There are a lot of variables that attribute to even being able to get SC.
There may be multiple combinations of things that allow for easy SC. Maybe
disabling Fallout audio threads somehow helps, closing other programs,
changing recording settings, increasing/lowering resolution or straight
making settings [potato](./ini/potato/). Even if the game source was
revealed, fully understanding just how a glitch like this works
(especially NG+ SC) may never be achievable. There is a lot of chaos going
on and it seems like SC requires the perfect storm to materialize.

# Future fixes?
\============================================================================

Given the nature of the glitch, and the ghettoness of the fixes, I am a bit
stumped when it comes to future fixes.

What could be done?

## Patched Forced Waits

Find where dispatch is done for animation loading and put a 'sleep'?
This would make every load slower by checking every animation load against
the first person SC related animations and is probably counter productive.
If it worked at all.

## Auto-thread mover (ThreadOverseer)

Simple enough, start FO3 and move everything to separate threads. Every
other program would have to be moved off of FO3's threads. This may help
but given that disk reads are a main factor, this would likely only be a
partial fix.

## Filesystem file priority

There are commands like `ionice` that give you some control over what files
have what priority on disk. This may not help at all (given modern SSDs are
so fast and FO3 came out when everyone still used HDDs). Windows may not have
an easy equivalent. It also still requires having loose files, so it's
probably better to use the USB symlink trick?

## Holy Grail? (NG+ and Animation List)

NG+ seems like the best place to look for a better understanding but, again,
being threading related that seems extremely hard to investigate. Getting a
better understanding of animation lists and the data flow of animations when
getting SC without any fix may be the only thing that opens up any new paths
for SC manipulation.

# Outro pt 2
\============================================================================

Hopefully this helps speedrunners with FO3 and the incredibly notorious SC.
It's not as deep of a dive as last time and more overall OS and game behavior
but it gives some insight into what is going on.

Summary? Computers are hard and they've change a lot since Fallout 3 came out.

If you want to read the original it's below.

Thanks for reading.

Good luck, break a leg :]

\============================================================================
# ORIGINAL (pt1)

# Fallout 3 Speed Cripple Dissect

I was watching a Fallout 3 speedrun and everyone was talking about how horrid
the Speed Cripple glitch was to get. It always sounded like it was random,
but sometimes seemed it was in a "good state" and there would be little
problems getting it. The Fallout glitch God, Kungkobra, said I was welcome
to try to figure out a way to make it stable, and for some reason I was obssessed.

The urge to figure out what is going on behind the infamous Fallout 3
Speed Cripple glitch consumed me, even if I couldn't fix it.

Here's what I found.

# Disclaimer (TLDR)

### Pseudo fix

There still really isn't a fix for this.
The best I've come to is controlling what threads Fallout runs on,
while also moving everything off Fallout's cores/threads.
Very well could be luck or wanting to believe it helps.

**windows** - `start /affinity 3 Fallout.exe`

**linux** - `taskset -c 4,5 wine Fallout3.exe`

### What happens?

Your animations change when you get crippled.
A 3rd person animation is used in 1st person when you are crippled.
This animation seems to compensate for your slower `player/character speed`
and less `1st person animation distance`.

When you freak the game out, you end up with the 3rd person animation,
but regular player speed and 1st person animations.

Boom, you now have speed cripple.

# Dissect

## Where to start?
\============================================================================

Some people said they had no issues getting SC (Speed Cripple) offline,
but streaming or capturing would make it almost impossible.
Others would say it was easier to get on older hardware.

Had a few hunches about threads and FPU but wasn't really sure what was going on.

Older CPUs were slower, so I tried to lower my CPU clock speed - no dice.

When FO3 came out I was running it on a Core2Duo: no more than 4 cores/threads.
Limiting FO3 to only a couple threads on a single core *seemed* like it yielded better results.
But it was still inconsistent and I still had no idea what the actual cause was.

From here there is only one way to go - into code.
A good debugging start was running `strings`,
a common tool to grab text strings from a file.

`strings Fallout3.exe`

The [dump of strings output](./fo3_strings.txt) can contain some garbage,
but from everyone's consensus, it sounded like your speed was getting increased about 1.6x,
so I looked for "speed", "run" and the like.

There were a couple values that were familiar or seemed to do with speed.

<pre>
fMoveRunMult
SpeedMult
</pre>

## The Process (debug 101)
\============================================================================

Hunting down variables was a common task. If you haven't debugged
a game before, this is the process.

Luckily, Bethesda has an in game console that allows you to get
and change engine values. This was the biggest help with finding
values to set breakpoints on and work from there.

Occasionally I'd use a "game cheat memory search" tool to find
values, but this was before knowing the in-game console/engine references.

Finding memory locations of variables went something like this...

#### The easy way

 - run `getgs fMoveRunMult` in game
 - (the game tells you it's `4`)
 - search memory for the value `4`
 - `setgs fMoveRunMult 5`
 - search memory results for the new value

Eventually you get to a memory location
(that may be static or dynamic - usually dynamic),
set a breakpoint - and bob's your uncle.
You start hitting areas in code that reference the variable you're looking
for and can get to crackin'.

#### The hard way

Some values ended up not being what you set. Searching memory for
greater/lessthan values becomes a pain. Some scripting is possible
to automate searching but it's still undesirable and clunky.

The alternative ? You can set a breakpoint on the string itself
you want to look for.

 - find the string (e.g. "fMoveRunMult") in memory (may have multiple hits)
 - set a breakpoint on byte access
 - you end up somewhere in the game's text/ascii display system

![ascii_hell](./img/fmoverunmult_c00.png)

From here you have to pay close attention. There are format string
prints like `"%.02f"` you have to look for. Sometimes you have to
back trace rets, set breakpoints before the string is accessed,
and *eventually* find a memory location.

Set a breakpoint in code, make note, and don't go through this again.

## Start cont... (speed search)
\============================================================================

`fMoveRunMult` lead to a couple functions I didn't quite understand yet.
I could see it was only called under certain circumstances
(changing armor, drawing/holstering weapons, getting crippled).
And that triggering calls would usually change the end values.

#### fMoveRunMult referenced in wrapper call (F61098)

![wrapper](./img/moverunmult_wrapper.png)

#### Speed() function the wrapper calls
![speedfunc](./img/speed_func.png)

I noticed the common explanation of speed being increased didn't happen
when you actually got SC. There would still be the same float value
(e.g. `325`) for speed when you load a game, and after getting SC.

My scatter brain got the better of me and I started looking elsewhere.

I gathered a [useful string list](./useful_strings.txt) to get going.
Most of these were dead ends, some were leftovers in Gamebryo's engine.
Other values seemed unused, or related to the Havok physics engine.

## Not speed...Where to next?
\============================================================================

I figured in a 3D game the actual thing "moving" is the camera, not the player.

These are the two main camera strings that caught my eye and lead somewhere.

<pre>
IsPC1stPerson
sUActnTogglepov (ended up with nothing)
</pre>

#### Camera POV code

![cam_pov1](./img/cam_pov1.png)

![cam_pov2](./img/cam_pov2.png)

![cam_pov3](./img/cam_pov3.png)


Getting here wasn't exactly helpful, and didn't have a hint of movement.

Some of the "useful strings" I collected were more of the same.
Code that didn't clearly lead to anything SC related,
and/or I couldn't piece it together yet.

But there were a couple variables I initially overlooked.

### Mobility Condition (Limb Health)

<pre>
LeftMobilityCondition
RightMobilityCondition
</pre>

These variables probably tripped me up the most. I could not find limb related
values anywhere, completely missed this while looking at strings,
and got lost looking at camera and game quick/load functions.

Why didn't I find them sooner? Limb health is not 0-100, 255,
or even a sensible float value. They seemed to be based around 77 (hex)
and had to be found looking for greater- and less-than values.
They would bottom out around 30s (hex) and got no higher than
low 100s (hex). This ended up leading somewhere I've been before,
where `IgnoreCrippledLimbs` was. But it had a lot of depth
so I didn't bother going further.

![limb_health](./img/limb_func.png)

This actually got called somewhere else familiar, twice in fact.
The speed function. (582B30)

![speedfunc](./img/speed_func.png)

The player speed side was making more sense.
But it still didn't seem like it was related to SC directly.

## Animations
\============================================================================

There was still one thing that I didn't look into.
And if you've messed around with SC, there's a really big clue.

When you have SC, you only go faster in 1st person. In 3rd
person you have a cripple animation but your real
world speed is obviously slower. I downloaded a BSA file
extractor and NifSkope to start examining animations.

There was a string I saw referenced a few times in the debugger
crossing other code - `1hpfastforward.nif`.
Comparing the `\meshes\characters\_1stPerson\locomotion` normal
vs "hurt" animations there was an obvious differences.

**FastForward_Hurt**

![1hpff_hurt](./img/1hpff_hurt.png)

**FastForward normal**

![1hpff](./img/1hpff.png)

They move forward a different amount, about half or twice as far.

I knew there was a way to override the animations with modding
but hadn't modded FO3 in a while.
Luckily a avid modder, Cheefii, reminded me how to go about it.
Not only was I going about using "Loose Files" wrong, but like
Cheefii said, "Make sure you have the right file."

1hpfastfoward is **not** the right file. Replacing `fastforward`
with the `hurt` version wasn't changing anything in game.
But I wasn't doing "Loose Files" wrong anymore. Double and triple
checking, making sure the filenames were right, I had to check memory.
Searching memory for animation files came back with nothing.
Searching for parts of animation files came back with nothing.

Cycling through the "forward animations, I found the **right animation**
is `mtfastforward`. This WAS in memory. And it would hit breakpoints.
Finally got somewhere.

![mtff_mem](./img/mtff_mem.png)

It was only part of the file. Because of how things are loaded
and used only partial, crucial bits, are stored in memory. Some
leftover text info from the beginning of animation files may be
present in memory, but for the most part they get cycled
through and then the memory is re-used. There was some
data around the animation data itself that wasn't clear.

The animation itself was also a bit different.

**mt FastForward_hurt**

![mtff](./img/mtff_hurt.png)

**mt FastForward normal**

![mtff](./img/mtff.png)

**1hp FastForward normal**

![1hpff](./img/1hpff.png)

Compared to `1hpfastforward` the `mtfastforward` goes
a bit farther in 3D space.

Finally figuring out the right animation, things started to speed up.

## Animation functions
\============================================================================

Setting a breakpoint on `mtfastforward` data verified
the animation was being used. As soon as you press
forward (**W**) the game is interrupted. The function
gets routed through a few calls.

### Animation data breakpoint

![anim_func](./img/anim_func_bp.png)

### Animation function call 1

![anim_call1](./img/anim_func_call1.png)

### Animation function call 2

![anim_call2](./img/anim_func_call2.png)

(Dynamic functions that result in something like `call edx` are common in FO3's code.)

This last call has a bunch of hardcoded references before it.
Some hardcode locations are values, others are pointers, there's
even some with tables of functions to call dynamically.

### Animation outer function

![anim_func_outer](./img/anim_func_outer.png)

The code here and before deals with frames and animation types.
Once all that is determined, the animation
is used in different ways in separate functions.

### Hardcode function pointer

![anim_hardcode_func](./img/anim_hardcode_func.png)

This `call edx` is sourced from the table at `10924F0`.

### MTFF Animation math
![anim_func_floatmath](./img/anim_func_floatmath.png)

What's related to `mtfastforward` is handled in a function at `8A4C50`.
I assumed these were 1st player skeleton movements. What I was looking
for a difference in values. The FPU (Floating-Point Unit of the CPU)
works a bit differently than standard registers. Without digesting
everything here, an animation value gets read and transforms
a piece of data. The easiest way to conceptualize this is matrix
math (sometimes with some conditionals applied).

<pre>
   input                   anim operation+data             output
[ 0.0,  1.1,  5.1, -2.3 ] [ +0.3,  *.5,  -.2,  +0.4 ]  [ .3,  .55,  4.9,  -1.9 ]
[ 1.0,  0.0,  2.3,  4.2 ] [ +0.0,  ?=0,   +2,  *1.1 ]  [ 1,   0.0,  4.3,  4.62 ]
[ 6.0, -0.4,  2.3,  3.1 ] [ ?<6,   *2.4,  +2,  *1.1 ]  [ 6,   -.4,  2.3,   3.1 ]

</pre>

(Fun fact. Float operations are not always precise. Especially
when moving between FPU and CPU. A value of `4.621119` may become `4.621`.
This is an over-simplification, but bits can get cut off.)


At this point I still didn't know how to tell more than "number different".
And there were a lot of numbers going on. Animation data did seem
consistent in memory when getting SC - not the memory location but
it wasn't corrupted in any way. It was still the same `mtfastforward`
being accessed when you have SC.

Doing some simple testing like modifying a single animation float to
be 600 instead of 0.3 did lead to interesting results;
like propelling so fast it caused the physics to register a "hard landing"
where the player stops like they fell far, but not far enough to damage limbs.
It was enough to convince me I was on the right track.

There was another value right before the animation data that didn't seem
to change. It was always `174` (hex), and adding that value to where
the data started was the perfect size to hit the end of the animation data.

![mtff_len](./img/mtff_mem_174.png)

## Animation formats
\============================================================================

There was a lot of back and forward looking at game loading and animation data.
This is how the animation data shook out and what lead to the previous
code making any sense.

### Animation beginning

![mtff](./img/mtff_mem.png)

### Animation ending

![mtff_end](./img/mtff_mem_end.png)

There was the `174` (hex) size of `mtfastforward` that stayed constant.
Around the animation and size were these highlighted dwords
(32bits, 4 bytes). These are highlighted by the debugger to signify
they are possible pointers to data (blue) or code (green).
Looking at the first one near the end of the animation data, and
going through some endian hell, shows it's a reference to the spot
this animation begins.

I made a [script to crawl animation pointers](anim_crawl.scr) and quickly
found out...there are a LOT. This is a vector added to over time. Some
animations may have garbage around them (text from radio, quest, so on).
Some pointers started and stoped immediately, a few bytes away.

Searching for some of these pointers in memory didn't find much.
But if you search for values next to them, like where the animation data
starts, you get some hits. At first these seemed like garbage. But
going back and setting breakpoints shows that the previous animation code
doesn't get these addresses directly, but from data structures with base
pointers to these pointers.

**Animation pointer-pointer code**

![anim_ptr_ref](./img/anim_func_ptr_ref.png)

This `ebx` value has a base used to get the pointer for yet
another pointer to the animation data.
Then `eax` (prevously the 1st level pointer to an animation) overwrites
itself with the direct pointer to the animation being used.

**Animation pointer1**

![mtff_ptr1](./img/mtff_mem_ptr1.png)

**Animation pointer 2**

![mtff_ptr2](./img/mtff_mem_ptr2.png)

How to grab the pointer pointers (mind endian)

 - search for animation data
 - search for the animation's start address (4 bytes after the anim length)
 - get the 1st level pointer address
 - subtract 24 (hex) from that address
 - search for the adjusted address
 - result is the second level pointer

Going through bits of code while looking at these
areas of memory and tracing them landed a few important values.

The second pointer has a `current frame` counter next to it.

![mtff_ptr2_pos](./img/mtff_mem_ptr2_pos.png)

The first one has a `animation size` (17 hex) and a `chunk size` (10 hex).
There are 17 chunks of 10 (170 bytes total)

![mtff_ptr1_sz](./img/mtff_mem_ptr1_sizes.png)

This info was nice to know, but SC was still unexplainable. And trying to
reverse every animation and data type seemed out of the question.

I started asking different questions.
What happens when these values get loaded? Where do they get loaded?
Maybe animation lengths or sizes are corrupted?

# Quickload (Load with a wrapper)
\============================================================================

`quicksave` is a hardcoded name in memory and easy to use.
Leads to FO3 QL (quickload) function at `6D5920`

![ql](./img/ql_func.png)

The second call, calls to "load: proper". If you choose a file and load
it, the debugger will break here. (It's right before QL in memory.)

![load](./img/load_func.png)

Unfortunately, this is where things looked grim.
Stepping over/into each call, searching for `mtfastforward` in
memory ended up proving one thing.

Loading animation data is threaded.
There are two big give-aways that game object loads are threaded.

InterlockedDecrement and InterlockedIncrement - which are atomic functions.
(they freeze the CPU access to memory to ensure multiple threads can't
access a resource at the same time)

RtlEnterCriticalSection and RtlLeaveCriticalSection which are related to
threads getting access/ownership to memory.

Going through QL wasn't leading anywhere. Stepping a single instruction could
give another thread the OK to run, and debugging threads is hell. FO3 is
fairly large - too large to be able to collect all information on threads,
or pause them and step through each. Plus these were relying on each other
for memory addresses, allocation and probably just signaling - trying to do
anything fancy only brought crahses.

# Animation loading, try 2
\============================================================================

Back to the animation data, the size seemed like it would have to be used
when loading the animations, right? Breaking on them didn't exactly get to
a "load", but more of a "check".

![anim_load_chk](./img/anim_load_check.png)

From what I could tell, this and the preceding calls were looping through
every animation in the `Fallout - Meshes.bsa`. Ultimately it was the same
as trying to poke around QL - stepping one instruction may load `mtfastforward`.

(There's a lot of string functions here... Things like
chop "\characters\_male\locomotion\hurt" to "\locomotion")

One important take away is that the `animation length` from earlier can
get a `40` (hex) binary `or`'d onto it. I think the `40` signifies a "disabled"
animation, or maybe un-needed memory. Some animations in the animation vector have
this `40` in their length, and those animations were either missing data or it
looked incomplete.


# Breakthrough
\============================================================================

At this point there was still no answer to why SC was happening. I started
dumping memory and doing mass searches for anmations. Cut parts out of all of the
1st and 3rd person locomotion animations and did some compares between fresh
game loads, ones with a bunch of QL-ing, some crippled instances and some with SC.

It actually showed something interesting. Animations were not always
loaded in identically except for a fresh load. There had been times trying
to debug there were one or two locations with the same animation data. I
didn't really think anything of it and figured QL was just loading the same
stuff in twice, and that it was leftover. But what if it wasn't? Was it
being re-used? What if SC was using hurt and normal animations together?
The animation vector was too big to take on, so I decided I'd limit it
down to what animations ARE being used.

 - find an animation in memory
 - breakpoint the data
 - see if it hits anything

I found out that for some reason, **3rd person** had a **`mtfastforward`** animation.

Except it didn't have a `mt` animation for regular movement -
only a **`mtfastforward_hurt`** animation. I tried to break on access
to it and bam - 1st person used the 3rd person animation.

I've been through so many dead ends at this point I was excited and losing
hope at the same time. I figured I'd try something less debug-y and loaded
the `mt` 3rd person animation over 1st person, then felt crushed

**1st person (data\meshses\characters\_1stPerson\locomotion)**

---

|animation|replaced_by|animation|result|
|----|----|----|----|
|mtfastfoward         |replaced_by   |mtfastforwrad_hurt |you go slower (as expected)|
|mtfastforward_hurt   |replaced_by   |mtfastforward      |you go faster once hurt, but not SC fast|

**3rd person (data\meshes\characters\_male\locomotion)**

---

|animation|replaced_by|animation|result|
|----|----|----|----|
|(1st)mtfastforward   |replaced_by   |(3rd)mtfastfoward_hurt |your camera turns left and you go slow, weird huh?|
|(3rd)mtfastforward_hurt |replaced_by   |(1st)mtfastfoward |your character is halfway in the ground, sideways, pretty slow|

The 3rd person `mtfastforward_hurt` was moving the camera and making you slow, uncrippled.

I was about to call it but noticed this string of leftover text next to the
animation I was looking at in memory.

From President Eden over the radio...

![patience](./img/patience_fo3.png)

Legit LOL. Decided to truck through a bit more, and the next step finally showed
what was going on.

|animation|replaced_by|animation|result|
|----|----|----|----|
|(1st)mtfastforward_hurt |replaced_by  |(3rd)mtfastfoward_hurt |you go faster once hurt, but not SC fast|

FINALLY - it made sense.

Replacing 1st person `mtff_hurt` with the 3rd person `mtff_hurt` animation
had the same effect as being replaced by the 1st person `mtff` animation.

**3rd person `mtff_hurt` actually moves you more to compensate for your
slower player speed and reduced 1st person animation travel distance.**


### Crippled normally

Normal 1st person animations get replaced by "hurt" versions that are slower.

You get a new 3rd person animation.

You also get your player speed reduced.

|status|multiplier|
|----|----|
|not crippled| 1.00x|
|1 leg crip  | 0.85x|
|2 legs      | 0.75x|

Combined, you go slower overall.

### Speed Cripple

You get crippled but quickload -
the game threads different loads at the same time.

You get the 3rd person `mtff_hurt` animation attached to your current set.

You get your limbs and player speed restore to your pre-crippled save.

Normal 1st person animations are loaded.

1st person "hurt" animations don't get loaded.

### Unwanted glitches

There are still mishaps like reverse speed, or temporary SC. I had these
happen way less in testing and didn't chase after them, but I have to
assume it's the same mechanics causing them.

You can get fast<u>forward</u> but not fast<u>right</u>, left, or back.
(IME left was usually a slow direction, maybe it gets loaded first?)

A "normal" 1st person animation or the new 3rd
person animation may get disabled (40 hex), and any check done
(like another QL) will remove them.

Or, maybe you get no 3rd mtff_hurt animation but reduced player speed,
and there's no compensation from the 3rd person animation doesn't move
your camera faster.

### Problems

The exact setup to perform SC is still a uknown. Maybe there's a way to
set up certain threads and memory, turn off as much randomness as possible:
like grass, AI, terrain, draw distance, etc. It could be an RNG hell hole.

Other programs running will cause your OS to move programs across threads
and cores. It will cause different areas of memory to be used. Using a
swap/page file may affect how fast some memory actions are. There are a
lot of variables to account for. Windows 2003 (XP) changed the way
"Critical Section Objects" (threads) work, maybe something else
changed since then?

As stated at the beginning, the best luck I had to reproduce SC was starting
FO3 on certain threads and kicking everything else off of them.

**windows** - `start /affinity 3 Fallout.exe`

**linux** - `taskset -c 4,5 wine Fallout3.exe`

This could be my imagination. I did notice having anything media heavy
running seemed to drastically reduce my odds, and other's have said the same.

# Outro
\============================================================================

Either way, I'm just glad to know what's going on. I didn't expect to learn
nearly as much as I did about Fallout 3's code. I thought it'd would be
a quicker path to more or less the same conclusion. Animations weren't even on
my radar until I dug into everything.

This was my first time really opening a debugger in years. Felt good to get
where I was going. The universe teasing me at the end with Eden's
"have a little patience", good stuff.

There are parts I left out like time sinks, distractions, or dumb mistakes.

Hope it's been interesting for at least someone out there.

Keep breaking shit =)

# Misc
\============================================================================

## Tools used

x64dbg, gdb, strings, gameconqueror, NifSkope, BAE (Bethesda Archive Extractor)

## Un-obtainables

**Threading** - debugging exactly what is going on would be nice

**Input** - without remote debugging I'm not sure it's possible to trace things
with keybord or mouse input. The game pauses immediately when it notices
it isn't the center of attention. Not that important I guess.

## Files

`strings Fallout3.exe` output [fo3_strings](./fo3_strings.txt)

Trimmed [useful_strings](./useful_strings.txt)

A file with a "name" and "signature" to search on.
(These are not all accurate and may find more than one location.)
[animation signatures](./animation_signatures.txt)

[breakpoint list](./bp.txt) dumped from x64dbg

[anim_crawl](./anim_crawl.asm) x64dbg script

## Code digest

[player speed](./player_speed.asm)

[speed backup](./speed_backup.asm)

[limb hell-th](./limb_health.asm)

[animation](./animation.asm)

[movement direction](./anim_move_dir_status.asm)

[cam pov](./cam_pov.asm)

## Other Glitches

[Void Swim Glitch](./SWIM.md)
