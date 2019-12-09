;-------------------------------------------------------------------------------
; Online help text, goes partially under I/O and Kernal
;-------------------------------------------------------------------------------

onlinehelptext: dc.b "NinjaTrackerV2.04 online help           "
                dc.b "                                        "
                dc.b "Press arrows up/down to scroll and any  "
                dc.b "other key to exit.                      "
                dc.b "                                        "
                dc.b "                                        "
                dc.b "                                        "
                dc.b "1. Introduction                         "
                dc.b "                                        "
                dc.b "NinjaTracker V2.x is still a somewhat   "
                dc.b "minimal music editor. Main differences  "
                dc.b "to previous versions are general purpose"
                dc.b "commands (or instruments), two-column   "
                dc.b "tables and a slide function that knows  "
                dc.b "to stop at the target pitch.            "
                dc.b "                                        "
                dc.b "Customization is allowed and encouraged!"
                dc.b "                                        "
                dc.b "www: http://covertbitops.c64.org        "
                dc.b "email: loorni`gmail.com                 "
                dc.b "                                        "
                dc.b "                                        "
                dc.b "                                        "
                dc.b "2. How to use                           "
                dc.b "                                        "
                dc.b "2.1 General keys                        "
                dc.b "                                        "
                dc.b "  F1          Play from beginning       "
                dc.b "  F3          Stop playing              "
                dc.b "  F4          Switch note entry (PT/DMC)"
                dc.b "  F5          Play from mark            "
                dc.b "  F6          Adjust colors             "
                dc.b "  F7          Toggle fastforward        "
                dc.b "  F8          Enter help screen         "
                dc.b "             Enter disk menu           "
                dc.b "  /           Silence test notes        "
                dc.b "  <>          Fast scroll up/down       "
                dc.b "  {} or ,.    Select octave             "
                dc.b "  0-9,A-F     Edit hexadecimal data     "
                dc.b "  Cursors     Move around               "
                dc.b "  Ins/Del     Delete rows               "
                dc.b "  Shift+Ins   Insert rows               "
                dc.b "  Shift+M     Mark copy start/end       "
                dc.b "  Shift+X,C,V Cut/copy/paste            "
                dc.b "  Shift+1,2,3 Switch to tracks 1-3      "
                dc.b "  Shift+4     Switch to pattern         "
                dc.b "  Shift+5,6,7 Switch to tables          "
                dc.b "  Shift+8     Switch to commands        "
                dc.b "  Return      Goto pattern/table/command"
                dc.b "  Shift+Ret.  Point and goto next unused"
                dc.b "              pattern/table/command     "
                dc.b "                                        "
                dc.b "2.2 Track editor special keys           "
                dc.b "                                        "
                dc.b "  ;:          Select subtune            "
                dc.b "  Space       Mark playing position     "
                dc.b "                                        "
                dc.b "2.3 Pattern editor special keys         "
                dc.b "                                        "
                dc.b "  ;:          Select pattern            "
                dc.b "  -+          Select command number     "
                dc.b "  1-7         Select octave (DMC)       "
                dc.b "  AWSEDFTGY.. Enter notes (DMC)         "
                dc.b "  ZSXDCVGBH.. Lower octave notes (PT)   "
                dc.b "  Q2W3ER5T6.. Upper octave notes (PT)   "
                dc.b "  Space       Enter keyoff/clear column "
                dc.b "  Shift+Space Enter keyon               "
                dc.b "  Shift+Q     Transpose halfstep down   "
                dc.b "  Shift+A     Transpose halfstep up     "
                dc.b "  Shift+L     Toggle command legato     "
                dc.b "  Shift+O     Optimize pattern          "
                dc.b "  Return      Fill with above note      "
                dc.b "                                        "
                dc.b "2.4 Command editor special keys         "
                dc.b "                                        "
                dc.b "  Space       Keyoff test note          "
                dc.b "  Shift+Space Test current command      "
                dc.b "  Shift+S     Smart paste (references of"
                dc.b "              the source command are    "
                dc.b "              pointed to destination)   "
                dc.b "                                        "
                dc.b "Testing and cut/copy/paste/ins/del works"
                dc.b "only when the cursor is over the command"
                dc.b "parameters, not command name. The test  "
                dc.b "note is C in the currently selected     "
                dc.b "octave and on the channel active in the "
                dc.b "track editor.                           "
                dc.b "                                        "
                dc.b "                                        "
                dc.b "                                        "
                dc.b "3. The musicdata                        "
                dc.b "                                        "
                dc.b "3.1 Track data                          "
                dc.b "                                        "
                dc.b "There can be a maximum of 16 different  "
                dc.b "songs (subtunes), each with 3 tracks.   "
                dc.b "All songs share the same 127 patterns,  "
                dc.b "tables and 127 commands.                "
                dc.b "                                        "
                dc.b "Values in the track data:               "
                dc.b "                                        "
                dc.b "  00    Loop (followed by loop position)"
                dc.b "  01-7F Pattern to play                 "
                dc.b "  80-BF Transpose downwards             "
                dc.b "  C0-FF Transpose upwards (C0 = zero)   "
                dc.b "                                        "
                dc.b "Transpose cannot be followed by loop,   "
                dc.b "and the combined length of a subtune's  "
                dc.b "all tracks cannot exceed 256 bytes.     "
                dc.b "                                        "
                dc.b "A subtune that plays only once can be   "
                dc.b "realized by playing a silent pattern    "
                dc.b "(with just a long keyoff note) last and "
                dc.b "looping to it indefinitely.             "
                dc.b "                                        "
                dc.b "3.2 Pattern data                        "
                dc.b "                                        "
                dc.b "A pattern consists of four columns.     "
                dc.b "From left to right they are:            "
                dc.b "                                        "
                dc.b "  Note/Keyoff/Keyon                     "
                dc.b "  Command number 01-7F, or legato 81-FF "
                dc.b "  Duration (using decimal notation)     "
                dc.b "  Command name (not editable)           "
                dc.b "                                        "
                dc.b "A note can range from C-1 to B-7. A note"
                dc.b "without a command number will use the   "
                dc.b "last used command. Similarly, if the    "
                dc.b "duration column is empty, the last used "
                dc.b "duration will apply.                    "
                dc.b "                                        "
                dc.b "Command numbers 81-FF are the commands  "
                dc.b "01-7F called in legato mode. In legato  "
                dc.b "mode hardrestart, init frame waveform   "
                dc.b "setup and auto-keyon will be skipped    "
                dc.b "(when used with a note), as well as ADSR"
                dc.b "setup; only the table pointers are set. "
                dc.b "                                        "
                dc.b "Duration minimum is 3 and maximum is 65."
                dc.b "                                        "
                dc.b "Keyoff is shown as --- and keyon as +++."
                dc.b "There is no function to let the gatemask"
                dc.b "stay in its current value, sorry!       "
                dc.b "                                        "
                dc.b "3.3 Table data                          "
                dc.b "                                        "
                dc.b "In all tables, the left side selects    "
                dc.b "the command/function, and right side has"
                dc.b "additional parameters for that function."
                dc.b "Jump destination 00 will stop execution "
                dc.b "of that table.                          "
                dc.b "                                        "
                dc.b "Wavetable left side values:             "
                dc.b "                                        "
                dc.b "  00-8F Set waveform, right side is     "
                dc.b "        arpeggio (00-7F relative, 8C-DF "
                dc.b "        absolute notes)                 "
                dc.b "  90-BF No waveform, delay arpeggio by  "
                dc.b "        00-2F frames                    "
                dc.b "  C0-DF Vibrato with speed 00-1F, right "
                dc.b "        side is depth                   "
                dc.b "  E0-FE Slide with speed highbyte 00-1E,"
                dc.b "        right side is speed lowbyte     "
                dc.b "  FF    Jump, right side is destination,"
                dc.b "        not to be entered directly from "
                dc.b "        a command                       "
                dc.b "                                        "
                dc.b "Vibrato continues indefinitely. For a   "
                dc.b "delay before vibrato starts, a delayed  "
                dc.b "arpeggio step can be used.              "
                dc.b "                                        "
                dc.b "When slide reaches target pitch, it     "
                dc.b "jumps to the last 'set waveform'-step   "
                dc.b "executed before the slide started.      "
                dc.b "                                        "
                dc.b "Pulse table left side values:           "
                dc.b "                                        "
                dc.b "  01-7F Modulate pulse for 01-7F frames,"
                dc.b "        right side is signed mod.speed  "
                dc.b "  80-FE Set pulse to right side value   "
                dc.b "  FF    Jump, right side is destination,"
                dc.b "        can be entered from a command   "
                dc.b "                                        "
                dc.b "Filter table left side values:          "
                dc.b "                                        "
                dc.b "  01-7F Modulate cutoff for 01-7F frames"
                dc.b "        right side is signed mod.speed  "
                dc.b "  80-FE Set passband (left nybble-8),   "
                dc.b "        channels to be filtered (right  "
                dc.b "        nybble) and cutoff (right side) "
                dc.b "  FF    Jump, right side is destination,"
                dc.b "        can be entered from a command   "
                dc.b "                                        "
                dc.b "When setting filter passband/channels/  "
                dc.b "cutoff, resonance will also be set to   "
                dc.b "the left nybble of the left side byte.  "
                dc.b "                                        "
                dc.b "3.4 Command data                        "
                dc.b "                                        "
                dc.b "Commands act both as instruments (when  "
                dc.b "used with a note) and as general pattern"
                dc.b "commands to alter some part of the sound"
                dc.b "(without notes). A command sets ADSR and"
                dc.b "may set any or all of wave-, pulse- and "
                dc.b "filtertablepointers.                    "
                dc.b "                                        "
                dc.b "The format of a command is:             "
                dc.b "                                        "
                dc.b "  ADSR Wv Pu Fl                         "
                dc.b "                                        "
                dc.b "A pointer value 00 leaves that pointer  "
                dc.b "unchanged, letting the currently running"
                dc.b "table program (if any) continue.        "
                dc.b "                                        "
                dc.b "Commands can be named so that using them"
                dc.b "in patterns becomes easier.             "
                dc.b "                                        "
                dc.b "To avoid setting ADSR, use the command  "
                dc.b "in legato mode (cmd. numbers 81-FF).    "
                dc.b "Furthermore, the packer/relocator can   "
                dc.b "optimize away the ADSR data of commands "
                dc.b "that are only used in legato mode, if   "
                dc.b "they are put to the end of the command  "
                dc.b "list.                                   "
                dc.b "                                        "
                dc.b "You cannot directly stop pulse/filter   "
                dc.b "execution from a command, but you can   "
                dc.b "achieve this by pointing table execution"
                dc.b "to a FF 00 -step.                       "
                dc.b "                                        "
                dc.b "3.5 Global settings                     "
                dc.b "                                        "
                dc.b "These are accessed from the disk menu   "
                dc.b "and allow setting the sustain/release   "
                dc.b "value used in hardrestart (default 00)  "
                dc.b "as well as the note init frame waveform "
                dc.b "(default 09). They are also saved with  "
                dc.b "each song. To get brighter attack to    "
                dc.b "noise waveform, try init frame waveform "
                dc.b "01 (no testbit).                        "
                dc.b "                                        "
                dc.b "3.6 Playback optimizations              "
                dc.b "                                        "
                dc.b "New note data is read from the pattern  "
                dc.b "3 frames before the note starts. On this"
                dc.b "frame slide, vibrato and pulse are all  "
                dc.b "skipped.                                "
                dc.b "                                        "
                dc.b "Track data (only if necessary) is read  "
                dc.b "one frame before note start. Pulse will "
                dc.b "be skipped in that case.                "
                dc.b "                                        "
                dc.b "When executing a command without note,  "
                dc.b "both pulse and wavetable execution are  "
                dc.b "skipped for one frame.                  "
                dc.b "                                        "
                dc.b "To reduce the effect of optimizations,  "
                dc.b "use as long note durations as possible. "
                dc.b "                                        "
                dc.b "                                        "
                dc.b "                                        "
                dc.b "4. Packing/relocating                   "
                dc.b "                                        "
                dc.b "There are two distinct modes in the     "
                dc.b "packer/relocator, Normal and Gamemusic. "
                dc.b "Normal saves the playroutine with the   "
                dc.b "music data, and the calls are usual:    "
onlinehelpend:  dc.b "                                        "
                dc.b "  Start+0 Init, A = subtune             "
                dc.b "  Start+3 Play, needs 2 bytes zeropage  "
                dc.b "                (chosen at relocation)  "
                dc.b "                                        "
                dc.b "In Gamemusic mode, you also have to     "
                dc.b "choose the startaddress, but the play-  "
                dc.b "routine is not saved with the music.    "
                dc.b "This is to save diskspace in a game with"
                dc.b "lots of music modules. See the gamemusic"
                dc.b "player source code (nt2play.s) and the  "
                dc.b "example (example.s) on how to use.      "
                dc.b "                                        "
                dc.b "To adjust volume of playback, find the  "
                dc.b "instructions ORA #$0F; STA $D418 in the "
                dc.b "player code and change the value of the "
                dc.b "ORA instruction.                        "
                dc.b "                                        "
                dc.b "                                        "
                dc.b "                                        "
                dc.b "5. Closing words                        "
                dc.b "                                        "
                dc.b "See the included example tunes to best  "
                dc.b "find out how this music system works in "
                dc.b "practice. Good luck, and have fun!      "

                                                               
              dc.b "ORA instruction.                        "
                dc.b "                                        "
                dc.b "                                        "
                dc.b "                                        "
                dc.b "5. Closing words                        "
                dc.b "                                        "
                dc.b "See the included example tunes to best  "
                dc.b "find out how this music system works in "
                dc.b "practice. Good luck, and have fun!      "


