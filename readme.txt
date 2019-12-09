NinjaTracker V2.01
------------------

Contents:

ninjatr201.d64
- Disk image with the editor itself and example tunes

example.prg
- Gamemusic player example program

nt2play.s
- DASM format sourcecode for the gamemusic player

ins2nt2.exe
- Utility for converting GoatTracker V1.x or V2.x instruments to use as sound
  effects for the gamemusic player

/src directory
- Sourcecode of the editor & example. DASM, Pucrunch and c64tools package from
  http://covertbitops.c64.org are required to rebuild.



1. Introduction

NinjaTracker V2.x is still a somewhat minimal music editor. Main differences to
previous versions are general purpose commands (or instruments), two-column
tables and a slide function that knows to stop at the target pitch.

Customization is allowed and encouraged!

www: http://covertbitops.c64.org
email: loorni@gmail.com



2. How to use

2.1 General keys

  F1          Play from beginning
  F3          Stop playing
  F4          Switch note entry (PT/DMC)
  F5          Play from mark
  F6          Adjust colors
  F7          Toggle fastforward
  F8          Enter help screen
  <-          Enter disk menu
  /           Silence test notes
  <>          Fast scroll up/down
  [] or ,.    Select octave
  0-9,A-F     Edit hexadecimal data
  Cursors     Move around
  Ins/Del     Delete rows
  Shift+Ins   Insert rows
  Shift+M     Mark copy start/end
  Shift+X,C,V Cut/copy/paste
  Shift+1,2,3 Switch to tracks 1-3
  Shift+4     Switch to pattern
  Shift+5,6,7 Switch to tables
  Shift+8     Switch to commands
  Return      Goto pattern/table/command
  Shift+Ret.  Point and goto next unused
              pattern/table/command

2.2 Track editor special keys

  ;:          Select subtune
  Space       Mark playing position

2.3 Pattern editor special keys

  ;:          Select pattern
  -+          Select command number
  1-7         Select octave (DMC)
  AWSEDFTGY.. Enter notes (DMC)
  ZSXDCVGBH.. Lower octave notes (PT)
  Q2W3ER5T6.. Upper octave notes (PT)
  Space       Enter keyoff/clear column
  Shift+Space Enter keyon
  Shift+Q     Transpose halfstep down
  Shift+A     Transpose halfstep up
  Shift+L     Toggle command legato
  Shift+O     Optimize pattern
  Return      Fill with above note

2.4 Command editor special keys

  Space       Keyoff test note
  Shift+Space Test current command
  Shift+S     Smart paste (references of the source command are pointed to
              destination)

Testing and cut/copy/paste/ins/del works only when the cursor is over the
command parameters, not command name. The test note is C in the currently
selected octave and on the channel active in the track editor.



3. The musicdata

3.1 Track data

There can be a maximum of 16 different songs (subtunes), each with 3 tracks.
All songs share the same 127 patterns, tables and 127 commands.

Values in the track data:

  00    Loop (followed by loop position)
  01-7F Pattern to play
  80-BF Transpose downwards
  C0-FF Transpose upwards (C0 = zero)

The combined length of a subtune's all tracks cannot exceed 256 bytes.

A subtune that plays only once can be realized by playing a silent pattern
(with just a long keyoff note) last and looping to it indefinitely.

3.2 Pattern data

A pattern consists of four columns. From left to right they are:

  Note/Keyoff/Keyon                     
  Command number 01-7F, or legato 81-FF 
  Duration (using decimal notation)     
  Command name (not editable)           
                                        
A note can range from C-1 to B-7. A note without a command number will use the
last used command. Similarly, if the duration column is empty, the last used
duration will apply.

Command numbers 81-FF are the commands 01-7F called in legato mode. In legato
mode hardrestart, init frame waveform setup and auto-keyon will be skipped (when
used with a note), as well as ADSR setup; only the table pointers are set.

Duration minimum is 2 and maximum is 65. However, for the last step of a pattern
the minimum duration is 3, if there is a transpose or song loop coming up, or
4 if both transpose and song loop are coming up. If these minimums are not met
the correct pattern will not be played next.

Keyoff is shown as --- and keyon as +++. There is no function to let the gatemask
stay in its current value, sorry!

3.3 Table data

In all tables, the left side selects the command/function, and right side has
additional parameters for that function. Jump destination 00 will stop execution
of that table.

Wavetable left side values:

  00-8F Set waveform, right side is arpeggio (00-7F relative, 8C-DF absolute 
        notes)
  90-BF No waveform, delay arpeggio by 00-2F frames
  C0-DF Vibrato with speed 00-1F, right side is depth
  E0-FE Slide with speed highbyte 00-1E, right side is speed lowbyte
  FF    Jump, right side is destination, not to be entered directly from a
        command

Vibrato continues indefinitely. For a delay before vibrato starts, a delayed
arpeggio step can be used.

When slide reaches target pitch, it jumps to the last arpeggio-step, normal
or delayed, that was executed before the slide started.

Pulse table left side values:

  01-7F Modulate pulse for 01-7F frames, right side is signed mod.speed
  80-FE Set pulse to right side value
  FF    Jump, right side is destination, can be entered from a command

Filter table left side values:

  01-7F Modulate cutoff for 01-7F frames, right side is signed mod.speed
  80-FE Set passband (left nybble-8), channels to be filtered (right nybble) 
        and cutoff (right side)
  FF    Jump, right side is destination, can be entered from a command

When setting filter passband/channels/cutoff, resonance will also be set to
the left nybble of the left side byte.

3.4 Command data

Commands act both as instruments (when used with a note) and as general pattern
commands to alter some part of the sound (without notes). A command sets ADSR and
may set any or all of wave-, pulse- and filtertablepointers.

The format of a command is:

  ADSR Wv Pu Fl

A pointer value 00 leaves that pointer unchanged, letting the currently running
table program (if any) continue.

Commands can be named so that using them in patterns becomes easier.

To avoid setting ADSR, use the command in legato mode (cmd. numbers 81-FF).
Furthermore, the packer/relocator can optimize away the ADSR data of commands
that are only used in legato mode, if they are put to the end of the command
list.

You cannot directly stop pulse/filter execution from a command, but you can
achieve this by pointing table execution to a FF 00 -step.

3.5 Global settings

These are accessed from the disk menu and allow setting the sustain/release
value used in hardrestart (default 00) as well as the note init frame waveform
(default 09). They are also saved with each song. To get brighter attack to
noise waveform, try init frame waveform 01 (no testbit).

3.6 Playback optimizations

Reading pattern data for a new pattern step is split on 2 frames just before
the new step begins. During this time, pulsetable execution is skipped if the
channel has a running wavetable program.

Command execution and new note init is performed on the latter of those frames.
During that, both pulsetable and wavetable execution are skipped.

To minimize the effect of optimizations use as long note durations as possible.



4. Packing/relocating

There are two distinct modes in the packer/relocator, Normal and Gamemusic.
Normal saves the playroutine with the music data, and the calls are usual:

  Start+0 Init, A = subtune
  Start+3 Play, needs 3 bytes zeropage (chosen at relocation)

In Gamemusic mode, you also have to choose the startaddress, but the play-
routine is not saved with the music. This is to save diskspace in a game with
lots of music modules. See the gamemusic player source code (nt2play.s) and the
example (example.s) on how to use.

To adjust volume of playback, find the instructions ORA #$0F; STA $D418 in the 
player code and change the value of the ORA instruction.



5. Closing words

See the included example tunes to best find out how this music system works in
practice. Good luck, and have fun!



Version history

V2.0  - Original

V2.01 - Gamemusic sound effect routine optimized
      - ins2nt2 updated for different data ordering
      - Current time position in pattern is shown alongside total duration
      - Packed size ("Ps") of pattern is shown in hexadecimal
      - Testing the last edited command also works in tables
      - ProTracker and DMC note entry modes are switchable
